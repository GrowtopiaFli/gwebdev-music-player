package gwebdev.io;

import haxe.io.Path;
#if sys
import sys.FileSystem;
import sys.io.File as SysFile;
#end
import openfl.display.BitmapData;
import openfl.utils.Assets;
import haxe.io.Bytes;
import openfl.utils.AssetType;
import openfl.utils.ByteArray;

using StringTools;

class File
{
	public static var soundExt:String = #if web "mp3" #else "ogg" #end;
	public static var assetPath = 'assets';

	public static function getAssetBytes(id:String, ?lib:String):Bytes
	{
		#if web
		return null;
		#end
		var assetsPath:String = getAssetPath(id, lib);
		if (Assets.exists(assetsPath))
		{
			var assetPath:String = Assets.getPath(assetsPath);
			return ByteArray.fromFile(assetPath);
		}
		#if (sys && !mobile)
		else if (FileSystem.exists(assetsPath))
		{
			return SysFile.getBytes(assetsPath);
		}
		#end
		else
			return null;
	}
	
	public static function getAssetPath(id:String, ?lib:String):String
	{
		var openflAssetList:Array<String> = Assets.list();
		var sysAssetList:Array<String> = getSysAssetsList(assetPath);
		var collectedAssets:Array<String> = [];
		for (asset in openflAssetList)
			if ( (lib != null && asset.startsWith(lib + ":") && asset.contains(id) ) || (lib == null && asset.contains(id)) )
				collectedAssets.push(asset);
		if (collectedAssets.length == 0)
		{
			for (asset in sysAssetList)
			{
				// libraries are useless for sys lol
				if (asset.contains(id))
					collectedAssets.push(asset);
			}
		}
		// copied from https://ashes999.github.io/learnhaxe/sorting-an-array-of-strings-in-haxe.html lol
		collectedAssets.sort(
			function(a:String, b:String):Int
			{
				a = a.toUpperCase();
				b = b.toUpperCase();
				
				if (a <  b)
					return -1;
				else if (a > b)
					return 1;
				else
					return 0;
			}
		);
		if (collectedAssets.length > 0)
			return collectedAssets[0];
		else
			return "";
	}

	public static function getSysAssetsList(assPath:String, paths:Array<String> = null):Array<String>
	{
		#if !(sys && !mobile)
		return [];
		#else
		if (FileSystem.exists(assPath))
		{
			if (paths == null)
				paths = [];

			var files;
			try
			{
				files = FileSystem.readDirectory(assPath);
			}
			catch (e:Dynamic)
			{
				return paths;
			}
			
			for (file in FileSystem.readDirectory(assPath))
			{
				var path = assPath + "/" + file;
				
				try
				{
					if (FileSystem.isDirectory(path))
						getSysAssetsList(path, paths);
					else
						paths.push(path);
				}
				catch (e:Dynamic)
				{
					return paths;
				}
			}
			
			return paths;
		}
		
		return [];
		#end
	}
}
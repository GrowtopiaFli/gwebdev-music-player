package;

import flixel.FlxG;
import haxe.Http;
import haxe.Json;
#if sys
import sys.thread.Thread;
#end
import haxe.io.Bytes;

import lime.app.Future;
import lime.app.Promise;

import openfl.utils.ByteArray;

class Requester
{
	#if (haxe >= "4.0.0")
	public static var requests:Map<String, Bytes> = new Map();
	#else
	public static var requests:Map<String, Bytes> = new Map<String, Bytes>();
	#end
	
	public static function isJson(data:String):Bool
	{
		try
		{
			Json.parse(data);
			return true;
		}
		catch (e:Dynamic)
		{
			return false;
		}
	}
	
	#if sys
	public static function readFile(filePath:String):Bytes
	{
		var fSize:Int = sys.FileSystem.stat('assets/latest_ver.txt').size;
		var fStream:sys.io.FileInput = sys.io.File.read('assets/latest_ver.txt');
		var bBuffer:haxe.io.BytesBuffer = new haxe.io.BytesBuffer();
		for (i in 0...fSize)
			bBuffer.addByte(fStream.readByte());
		return bBuffer.getBytes();
	}
	#end
	
	public static function sendRequest(id:String, url:String, binary:Bool = false):Future<Bool>
	{
		var promise:Promise<Bool> = new Promise<Bool>();
		
		if (binary)
			requestBytes(id, url).onComplete
			(
				function(ret:Bool)
				{
					promise.complete(ret);
				}
			).onError
			(
				function(e:Dynamic)
				{
					// idk how this shit would happen lol
					promise.complete(false);
				}
			);
		else
			requestString(id, url).onComplete
			(
				function(ret:Bool)
				{
					promise.complete(ret);
				}
			).onError
			(
				function(e:Dynamic)
				{
					// idk how this shit would happen lol
					promise.complete(false);
				}
			);
			
		return promise.future;
	}
	
	public static function requestString(id:String, url:String):Future<Bool>
	{
		var promise:Promise<Bool> = new Promise<Bool>();

		#if sys
		Thread.create(() -> {
		#end
		var http:Http = new Http(url);
		
		http.onData = function(dat:String)
		{
			requests.set(id, Bytes.ofString(dat));
			promise.complete(true);
		}
		
		http.onError = function(e:Dynamic)
		{
			promise.complete(false);
		}
		
		http.request();
		#if sys
		});
		#end

		return promise.future;
	}
	
	public static function requestBytes(id:String, url:String):Future<Bool>
	{
		var promise:Promise<Bool> = new Promise<Bool>();

		#if sys
		Thread.create(() -> {
		#end
		var http:Http = new Http(url);
		
		http.onBytes = function(dat:Bytes)
		{
			requests.set(id, dat);
			promise.complete(true);
		}
		
		http.onError = function(e:Dynamic)
		{
			promise.complete(false);
		}
		
		http.request();
		#if sys
		});
		#end

		return promise.future;
	}
}
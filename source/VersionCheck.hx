package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import haxe.io.Bytes;

class VersionCheck extends FlxState
{
	public var text:FlxText;

	override function create()
	{
		text = new FlxText(0, 0, FlxG.width,
			"Checking Version",
			32);
		text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		text.screenCenter();
		add(text);
		
		super.create();
		
		init();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
	
	function init():Void
	{
		#if sys
		sys.thread.Thread.create(() -> {
		#end
		Requester.sendRequest('github_version', "https://raw.githubusercontent.com/GrowtopiaFli/gwebdev-music-player/main/current.version", false).onComplete
		(
			function(ret:Bool)
			{
				if (ret || (!ret && Requester.requests.exists('github_version')))
				{
					compare(Requester.requests.get('github_version').toString());
				}
				else
				{
					#if sys
					if (sys.FileSystem.exists('assets/latest_ver.txt'))
						compare(Requester.readFile('assets/latest_ver.txt').toString());
					else
					#end
						err();
				}
			}
		).onError
		(
			function(e:Dynamic)
			{
				err();
			}
		);
		#if sys
		});
		#end
	}
	
	function err():Void
	{
		text.text = "Cannot Check For Version...\nProceeding To Player In 3 Seconds\n";
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			menuSwitch();
		});
	}
	
	function compare(data:String):Void
	{
		#if (sys && !mobile)
		sys.io.File.saveBytes('assets/latest_ver.txt', Bytes.ofString(data));
		#end
		OutdatedSubState.daVer = data;
		UpdatedSubState.daVer = data;
		if (VersionParser.parse(CurrentVersion.get()) < VersionParser.parse(data) && !OutdatedSubState.leftState)
			FlxG.switchState(new OutdatedSubState());
		else if (VersionParser.parse(CurrentVersion.get()) >  VersionParser.parse(data) && !UpdatedSubState.leftState)
			FlxG.switchState(new UpdatedSubState());
		else
			menuSwitch();
	}
	
	function menuSwitch():Void
	{
		FlxG.switchState(new PlayState());
	}
}
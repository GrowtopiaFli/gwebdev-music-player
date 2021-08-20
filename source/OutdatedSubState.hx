package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

import haxe.Http;
import haxe.io.Bytes;

class OutdatedSubState extends FlxState
{
	public static var leftState:Bool = false;
	public static var daVer:String = "I DONT KNOW";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var ver = "v" + Application.current.meta.get('version');
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Your Version Of My Music Player Is Outdated...\n" +
			"You Have Version " + CurrentVersion.get() + "\n" +
			"While The Latest Version Of The Player Is " + daVer + "\n" +
			"Press ENTER If You Want To Go To The Github Page\n" +
			"Press BACK If You Want To Use This Version Of The Player",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		var accepted:Bool = FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE;
		var backed:Bool = FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE;

		if (accepted)
		{
			openUrl('https://github.com/GrowtopiaFli/gwebdev-music-player');
		}
		if (backed)
		{
			leftState = true;
			FlxG.switchState(new PlayState());
		}
		super.update(elapsed);
	}
	
	function openUrl(url:String):Void
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [url, "&"]);
		#else
		FlxG.openURL(url);
		#end
	}
}

package;

import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.display.FPS;

class Main extends Sprite
{
	public var gWidth:Int = 1280;
	public var gHeight:Int = 720;
	public var fps:Int = 60;
	public var removeSplash:Bool = false;
	public var fullscreen:Bool = true;

	public function new()
	{
		super();
		
		addChild(new FlxGame(gWidth, gHeight, VersionCheck, 1280 / gWidth, fps, fps, removeSplash, fullscreen));

		addChild(new FPS(10, 3, 0xFFFFFFFF));
	}
}

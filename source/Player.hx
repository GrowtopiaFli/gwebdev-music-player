package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.typeLimit.OneOfTwo;
import haxe.io.Bytes;
import lime.media.AudioBuffer;
import openfl.media.Sound;
import gwebdev.io.File;
import flixel.ui.FlxBar;
import flixel.math.FlxMath;

class Player extends FlxState
{
	public var circleSize:Float = 30;
	public var playerCircle:FlxShapeCircle;
	public var curSong:FlxSound;
	public var progressBar:FlxBar;
	public var overlay:FlxSprite;
	public var overlayBG:FlxSprite;
	public var barCol1:FlxColor = FlxColor.WHITE;
	public var barCol2:FlxColor = FlxColor.GRAY;
	public var barHeight:Int = 20;
	public var overlayCol:FlxColor = 0xFF232946;
	public var overlayBGAlpha:Float = 0.2;
	public var overlayHeight:Int = 100;
	public var songPos:Float = 0;
	public var pauseTrans:Float = 0.5;
	public var paused:Bool = false;
	
	public function new(songData:String)
	{
		super();
		this.curSong = new FlxSound().loadEmbedded(Sound.fromAudioBuffer(AudioBuffer.fromBytes(File.getAssetBytes(songData))));
	}

	override function create()
	{
		FlxG.sound.list.add(curSong);
		curSong.play();
		
		overlayBG = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		overlayBG.alpha = overlayBGAlpha;
		add(overlayBG);
		
		overlay = new FlxSprite(0, FlxG.height).makeGraphic(FlxG.width, overlayHeight, overlayCol);
		overlay.y -= overlay.height;
		add(overlay);
		
		progressBar = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width, barHeight, this, 'songPos', 0, 1);
		progressBar.createFilledBar(barCol2, barCol1);
		progressBar.numDivisions = 2147483647;
		add(progressBar);
		
		playerCircle = new FlxShapeCircle(0, 0, circleSize / 2, { color: FlxColor.BLACK, thickness: 2 }, FlxColor.WHITE);
		add(playerCircle);
	
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.R)
		{
			paused = false;
			curSong.resume();
			curSong.time = 0;
			curSong.play();
		}
		
		if (FlxG.keys.justPressed.SPACE)
			paused = !paused;
			
		if (paused)
		{
			curSong.pause();
			overlay.alpha = FlxMath.lerp(1, overlay.alpha, (pauseTrans / 60) * FlxG.updateFramerate);
			overlayBG.alpha = FlxMath.lerp(overlayBGAlpha, overlayBG.alpha, (pauseTrans / 60) * FlxG.updateFramerate);
			overlay.y = FlxMath.lerp(FlxG.height - overlay.height, overlay.y, (pauseTrans / 60) * FlxG.updateFramerate);
		}
		else
		{
			curSong.resume();
			overlay.alpha = FlxMath.lerp(0, overlay.alpha, (pauseTrans / 60) * FlxG.updateFramerate);
			overlayBG.alpha = FlxMath.lerp(0, overlayBG.alpha, (pauseTrans / 60) * FlxG.updateFramerate);
			overlay.y = FlxMath.lerp(FlxG.height, overlay.y, (pauseTrans / 60) * FlxG.updateFramerate);
		}

		progressBar.alpha = overlay.alpha;
		playerCircle.alpha = overlay.alpha;
	
		progressBar.x = 0;
		progressBar.y = overlay.y;
		
		playerCircle.x = progressBar.x + (progressBar.width * (progressBar.percent / 100)) - playerCircle.radius;
		playerCircle.y = progressBar.y + progressBar.height / 2 - playerCircle.radius;
	
		songPos = curSong.time / curSong.length;
		
		super.update(elapsed);
	}
}
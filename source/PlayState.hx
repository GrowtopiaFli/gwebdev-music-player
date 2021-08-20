package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.util.helpers.FlxRangeBounds;
import flixel.math.FlxPoint;
import gwebdev.ParticleSystem;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import haxe.io.Bytes;
import openfl.media.Sound;
import lime.media.AudioBuffer;
import flixel.system.FlxSound;
import gwebdev.io.File;
import openfl.utils.Assets;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import lime.graphics.Image;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import hxconf.ConfigFile;

class PlayState extends FlxState
{
	// public var waveform:Waveform;
	public var particleCam:FlxCamera;
	public var controllerCam:FlxCamera;
	
	public var particles:ParticleSystem;
	
	public var thumbnails:FlxTypedGroup<ThumbSprite>;
	public var curIndex:Int = 0;
	
	public var circleSize:Float = 30;
	public var playerCircle:FlxShapeCircle;
	public var progressBar:FlxBar;
	public var overlay:FlxSprite;
	public var barCol1:FlxColor = FlxColor.RED;
	public var barCol2:FlxColor = FlxColor.GRAY;
	public var barCol3:FlxColor = FlxColor.YELLOW;
	public var barHeight:Int = 10;
	public var overlayCol:FlxColor = 0xFF0F0E17;
	public var overlayHeight:Int = 50;
	public var songPos:Float = 0;
	public var paused:Bool = false;
	public var title:FlxText;
	public var curPlaying:FlxText;
	public var timestamp:FlxText;
	public var bar2:FlxBar;
	public var bar3:FlxBar;
	public var bottomCam1:FlxCamera;
	public var bottomCam2:FlxCamera;
	public var bottomCam3:FlxCamera;
	public var highestCam:FlxCamera;
	public var yellowPos:Float = 0;
	public var wasPaused:Bool = false;
	public var canMove:Bool = false;
	public var middleText:FlxText;
	public var doUpdate:Bool = false;
	public var musicPlayerText:FlxText;
	public var bScreen:FlxSprite;
	public var pauseIndicator:FlxText;
	public var loopIndicator:FlxText;
	public var isLoop:Bool = false;
	
	#if (haxe >= "4.0.0")
	public var iniData:Map<String, Map<String, String>>;
	#else
	public var iniData:Map<String, Map<String, String>>;
	#end
	public var iniArrShit:Array<String>;

	override public function create()
	{
		particleCam = new FlxCamera();
		particleCam.bgColor.alpha = 0;
		controllerCam = new FlxCamera();
		controllerCam.bgColor.alpha = 0;
		bottomCam1 = new FlxCamera();
		bottomCam1.bgColor.alpha = 0;
		bottomCam2 = new FlxCamera();
		bottomCam2.bgColor.alpha = 0;
		bottomCam3 = new FlxCamera();
		bottomCam3.bgColor.alpha = 0;
		highestCam = new FlxCamera();
		highestCam.bgColor.alpha = 0;
		
		FlxG.cameras.reset(particleCam);
		FlxG.cameras.add(controllerCam);
		FlxG.cameras.add(bottomCam1);
		FlxG.cameras.add(bottomCam2);
		FlxG.cameras.add(bottomCam3);
		FlxG.cameras.add(highestCam);
		
		FlxCamera.defaultCameras = [controllerCam];
		
		particles = new ParticleSystem();
		particles.cameras = [particleCam];
		add(particles);
		
		var txtData:String = File.getAssetBytes('data/menudata.cfg').toString();
		var conf:ConfigFile = new ConfigFile();
		conf.read(txtData);
		iniData = conf.settings;
		
		thumbnails = new FlxTypedGroup<ThumbSprite>();
		add(thumbnails);
		
		iniArrShit = [];
		
		for (shit in iniData.keys())
			iniArrShit.push(shit);
			
		iniArrShit.sort(
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
		
		// trace(iniArrShit);
		// trace(iniData[iniArrShit[0]]["icon"]);
		// shitty testing
		
		for (i in 0...iniArrShit.length)
		{
			var tSprite:ThumbSprite = new ThumbSprite();
			var nullBS:String = iniData[iniArrShit[i]]["scale"] != null ? iniData[iniArrShit[i]]["scale"] : "0";
			var givenScale:Float = Std.parseFloat(nullBS);
			tSprite.doScale(givenScale);
			// tSprite.loadGraphic(BitmapData.fromImage(Image.fromBytes(File.getAssetBytes(iniData[iniArrShit[i]]["icon"]))));
			// i have a new idea lol
			var iconPath:String = iniData[iniArrShit[i]]["icon"];
			var forAssets:String = 'assets/' + iniData;
			if (Assets.exists(forAssets))
				tSprite.loadGraphic(forAssets);
			else
				tSprite.loadGraphic(BitmapData.fromImage(Image.fromBytes(File.getAssetBytes(iconPath))));
			tSprite.idStr = iniData[iniArrShit[i]]["name"];
			tSprite.idIndex += i;
			tSprite.musPath = iniData[iniArrShit[i]]["path"];
			var PACKED_COLOR = 0xFFFFFFFF;
			var ourArr:Array<Int> = [];
			var daCol:String = iniData[iniArrShit[i]]["color"] != null ? iniData[iniArrShit[i]]["color"] : "";
			var tempShit:Array<String> = daCol.split(",");
			for (shit in tempShit)
			{
				ourArr.push(Std.parseInt(shit));
			}
			if (ourArr.length == 4)
			{
				var canUse:Bool = true;
				for (fuck in 0...ourArr.length)
				{
					if (!(ourArr[fuck] <= 255 && ourArr[fuck] >= 0))
					{
						canUse = false;
					}
				}
				if (canUse)
				{
					PACKED_COLOR = (ourArr[0] & 0xFF) << 24 | (ourArr[1] & 0xFF) << 16 | (ourArr[2] & 0xFF) << 8 | (ourArr[3] & 0xFF);
				}
			}
			tSprite.col = PACKED_COLOR;
			tSprite.antialiasing = true;
			thumbnails.add(tSprite);
		}
		
		title = new FlxText(0, 0, FlxG.width, '', 32);
		title.setFormat('Monsterrat', 32, FlxColor.WHITE, CENTER);
		title.screenCenter(X);
		add(title);

		overlay = new FlxSprite(0, FlxG.height).makeGraphic(FlxG.width, overlayHeight, overlayCol);
		overlay.y -= overlay.height;
		overlay.cameras = [bottomCam1];
		add(overlay);
		
		bar2 = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width, barHeight, this, 'songPos', 0, 1);
		bar2.createFilledBar(barCol2, barCol2);
		bar2.numDivisions = 2147483647;
		bar2.cameras = [bottomCam1];
		add(bar2);
		
		bar3 = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width, barHeight, this, 'yellowPos', 0, 1);
		bar3.createFilledBar(FlxColor.TRANSPARENT, barCol3);
		bar3.numDivisions = 2147483647;
		bar3.cameras = [bottomCam2];
		add(bar3);
		
		progressBar = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width, barHeight, this, 'songPos', 0, 1);
		progressBar.createFilledBar(FlxColor.TRANSPARENT, barCol1);
		progressBar.numDivisions = 2147483647;
		progressBar.cameras = [bottomCam3];
		add(progressBar);

		playerCircle = new FlxShapeCircle(0, 0, circleSize / 2, {}, FlxColor.RED);
		playerCircle.cameras = [bottomCam3];
		add(playerCircle);
	
		curPlaying = new FlxText(0, 0, FlxG.width, 'Playing: ', 32);
		curPlaying.setFormat('Monsterrat', 32, FlxColor.WHITE, CENTER);
		curPlaying.screenCenter(X);
		add(curPlaying);
		
		timestamp = new FlxText(0, 0, FlxG.width, '00:00 / 00:00', 20);
		timestamp.setFormat('Monsterrat', 20, FlxColor.WHITE, LEFT);
		timestamp.cameras = [bottomCam3];
		add(timestamp);
		
		middleText = new FlxText(0, 0, FlxG.width, '00:00', 20);
		middleText.setFormat('Monsterrat', 20, FlxColor.YELLOW, CENTER);
		middleText.visible = false;
		middleText.cameras = [bottomCam3];
		add(middleText);
		
		pauseIndicator = new FlxText(0, 0, FlxG.width, 'PAUSED', 32);
		pauseIndicator.setFormat('Monsterrat', 32, FlxColor.WHITE, RIGHT);
		pauseIndicator.visible = false;
		add(pauseIndicator);
		
		loopIndicator = new FlxText(0, 0, FlxG.width, 'LOOPED', 32);
		loopIndicator.setFormat('Monsterrat', 32, FlxColor.WHITE, RIGHT);
		loopIndicator.y = pauseIndicator.y + pauseIndicator.height;
		loopIndicator.visible = false;
		add(loopIndicator);
		
		bScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bScreen.cameras = [highestCam];
		add(bScreen);

		musicPlayerText = new FlxText(0, 0, FlxG.width, 'GWebDev Music Player', 32); 
		musicPlayerText.setFormat('Monsterrat', 32, FlxColor.WHITE, CENTER);
		musicPlayerText.screenCenter();
		musicPlayerText.cameras = [highestCam];
		add(musicPlayerText);
		
		createEmitter();
		
		FlxG.sound.play('assets/sounds/start.ogg');
		
		var del:Float = 1;
		
		FlxTween.tween(highestCam, { alpha: 0 }, del, { ease: FlxEase.circIn, onComplete: function(twn:FlxTween)
			{
				doUpdate = true;
			}
		});

		super.create();
	}
	
	public function createEmitter(col:FlxColor = FlxColor.WHITE):Void
	{
		particles.killAllEmitters();
		particles.createEmitter(
		"bam", // id
		FlxG.width / 2, // x pos
		FlxG.height / 2, // y pos
		0, // maximum particles (0 = unlimited)
		3, // lifespan in seconds
		3, // width
		3, // height
		1, // X scale
		1, // Y scale
		col, // color
		null, // image
		FlxPoint.get(0.8, 0.8), // alphaRange
		new FlxRangeBounds<Float>(-5, -5, 5, 5), // speedRange minX, minY, maxX, maxY,
		ALPHA, // destroyType
		0, // num of particles (only works if not explode)
		false, // (is explode)
		3, // frequency (number of particles to spawn every delay if explode is false)
		0 // delay (how many seconds before spawning more particles)
		);
	}
	
	public function scrollThumbnails(change:Int = 0):Void
	{
		curIndex += change;
		if (curIndex >= thumbnails.members.length)
			curIndex = 0;
		if (curIndex < 0)
			curIndex = thumbnails.members.length - 1;
		FlxG.sound.play('assets/sounds/whoosh.ogg');
	}

	override public function update(elapsed:Float)
	{
		// progressBar.alpha = overlay.alpha;
		// playerCircle.alpha = overlay.alpha;
		
		overlay.y = FlxG.height - overlay.height;
		
		timestamp.y = overlay.y + overlay.height / 2 - timestamp.height / 2;
		middleText.y = timestamp.y;
		
		overlay.alpha = FlxMath.lerp(1, overlay.alpha, 0.32);
		
		progressBar.x = 0;
		progressBar.y = overlay.y;
		
		bar2.x = progressBar.x;
		bar2.y = progressBar.y;
		
		bar3.x = progressBar.x;
		bar3.y = progressBar.y;
		
		playerCircle.x = progressBar.x + (progressBar.width * progressBar.value) - playerCircle.radius;
		playerCircle.y = progressBar.y + progressBar.height / 2 - playerCircle.radius;
	
		// trace(lerpDel * (60 / FlxG.updateFramerate));
		thumbnails.forEachAlive(
			function(thumbnail:ThumbSprite)
			{
				// trace("idShit:" + thumbnail.idIndex);
				thumbnail.screenCenter(Y);
				thumbnail.x = FlxMath.lerp(FlxG.width / 2 + (FlxG.width * (thumbnail.idIndex - curIndex)) - thumbnail.width / 2, thumbnail.x, 0.8);
				thumbnail.alpha = FlxMath.lerp(1, thumbnail.alpha, 0.32);
			}
		);
		
		title.text = thumbnails.members[curIndex].idStr;
		title.screenCenter(X);
		var calculated:Float = thumbnails.members[curIndex].height * thumbnails.members[curIndex].scale.y;
		title.y = FlxMath.lerp(thumbnails.members[curIndex].y + (calculated + (thumbnails.members[curIndex].height - calculated) / 2) + 5, title.y, 0.4);
	
		if (doUpdate)
		{
			if (FlxG.keys.justPressed.R)
				paused = false;
		
			if (FlxG.sound.music != null)
			{
				if (FlxG.keys.justPressed.R)
				{
					FlxG.sound.music.resume();
					FlxG.sound.music.time = 0;
					FlxG.sound.music.play();
				}
				
				if (FlxG.mouse.overlaps(progressBar))
				{
					yellowPos = FlxG.mouse.x / FlxG.width;
					middleText.text = formatMS(yellowPos * FlxG.sound.music.length);
					middleText.visible = true;
					bar3.visible = true;
					if (FlxG.mouse.justPressed)
					{
						if (paused)
							wasPaused = true;
						else
							wasPaused = false;
						canMove = true;
					}
				}
				else
				{
					bar3.visible = false;
					middleText.visible = false;
				}
				if (canMove)
				{
					if (FlxG.mouse.pressed)
					{
						yellowPos = FlxG.mouse.x / FlxG.width;
						bar3.visible = true;
						middleText.text = formatMS(yellowPos * FlxG.sound.music.length);
						middleText.visible = true;
						FlxG.sound.music.time = yellowPos * FlxG.sound.music.length;
						if (!wasPaused)
							paused = true;
					}
					if (FlxG.mouse.justReleased)
					{
						if (!wasPaused)
							paused = false;
						canMove = false;
					}
				}

				if (paused)
					FlxG.sound.music.pause();
					// overlay.alpha = FlxMath.lerp(1, overlay.alpha, (pauseTrans / 60) * FlxG.updateFramerate);
				else
					FlxG.sound.music.resume();
					// overlay.alpha = FlxMath.lerp(0, overlay.alpha, (pauseTrans / 60) * FlxG.updateFramerate);
				pauseIndicator.visible = paused;
					
				FlxG.sound.music.looped = isLoop;

				loopIndicator.visible = isLoop;
			
				songPos = FlxG.sound.music.time / FlxG.sound.music.length;
				
				timestamp.text = formatMS(songPos * FlxG.sound.music.length) + " / " + formatMS(FlxG.sound.music.length);
			}
			else
			{
				timestamp.text = "00:00 / 00:00";
				middleText.visible = false;
				bar3.visible = false;
			}
			
			if (FlxG.keys.justPressed.SPACE)
				paused = !paused;
			if (FlxG.keys.pressed.SPACE)
				overlay.alpha = 0.5;
			if (FlxG.keys.justPressed.L)
				isLoop = !isLoop;
				
			var leftRight:Array<Bool> = [FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT];
			
			if (leftRight[0])
				scrollThumbnails(-1);
			if (leftRight[1])
				scrollThumbnails(1);
			
			if (FlxG.keys.pressed.ENTER)
				thumbnails.members[curIndex].alpha = 0.3;
			
			if (FlxG.keys.justPressed.ENTER)
			{
				paused = false;
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				curPlaying.text = 'Playing: ' + thumbnails.members[curIndex].idStr;
				createEmitter(thumbnails.members[curIndex].col);
				#if sys
				sys.thread.Thread.create(() -> {
				#end
				// ram consuming
				// FlxG.sound.playMusic(Sound.fromAudioBuffer(AudioBuffer.fromBytes(File.getAssetBytes(thumbnails.members[curIndex].musPath))));
				var musPath:String = thumbnails.members[curIndex].musPath;
				var forAssets:String = 'assets/' + musPath;
				if (Assets.exists(forAssets))
					FlxG.sound.playMusic(forAssets);
				else
					FlxG.sound.playMusic(Sound.fromAudioBuffer(AudioBuffer.fromBytes(File.getAssetBytes(musPath))));
				#if sys
				});
				#end
			}

			pauseIndicator.y = 0;
			loopIndicator.y = pauseIndicator.y + pauseIndicator.height;
		
			if (FlxG.keys.justPressed.F)
				FlxG.fullscreen = !FlxG.fullscreen;
		}
			
		FlxG.autoPause = false;
		
		super.update(elapsed);
	}
	
	public function formatMS(toFormat:Float):String
	{
		var secs:Int = Std.int(toFormat / 1000);
		var mins:Int = Std.int(secs / 60);
		var hours:Int = Std.int(mins / 60);
		var secsStr:String = Std.string(Std.int(secs - mins * 60));
		var minsStr:String = Std.string(Std.int(mins - hours * 60));
		var hoursStr:String = Std.string(hours);
		if (secsStr.length == 1)
		{
			var secsStrArr:Array<String> = secsStr.split("");
			secsStrArr.unshift("0");
			secsStr = secsStrArr.join("");
		}
		if (minsStr.length == 1)
		{
			var minsStrArr:Array<String> = minsStr.split("");
			minsStrArr.unshift("0");
			minsStr = minsStrArr.join("");
		}
		if (hours > 0)
			return hoursStr + ":" + minsStr + ":" + secsStr;
		else
			return minsStr + ":" + secsStr;
	}
}

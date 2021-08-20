package;
/*
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import openfl.media.Sound;
import lime.media.AudioBuffer;
import openfl.geom.Rectangle;
import haxe.io.Bytes;
import flixel.system.FlxSound;

class Waveform extends FlxSprite
{
	// https://github.com/gedehari/HaxeFlixel-Waveform-Rendering/blob/master/source/PlayState.hx
	// Thanks gedehari
	
	public var buffer:AudioBuffer;
	public var bufferBytes:Bytes;
	public var sound:Sound;
	public var flxSound:FlxSound;
	
	public var funiColor:FlxColor;

	public function new(audioData:AudioBuffer, col:FlxColor = FlxColor.WHITE, maxHeight:Int = 40)
	{
		makeGraphic(0, maxHeight);
		this.buffer = audioData;
		this.bufferBytes = buffer.toBytes();
		this.sound = Sound.fromAudioBuffer(buffer);
		this.flxSound = FlxG.sound.playMusic(sound);
		this.funiColor = col;
		
		#if sys
		sys.thread.Thread.create(() -> {
		#end
		var index:Int = 0;
		var drawIndex:Int = 0;
		var samplesPerCollumn:Int = 600;
		
		var min:Float = 0;
		var max:Float = 0;
		
		var isUp:Bool = false;
		
		while ((index * 4) < (bufferBytes.length - 1))
		{
			var byte:Int = bufferBytes.getUInt16(index * 4);
			
			if (byte > 65535 / 2)
			{
				byte -= 65535;
				isUp = true;
			}
			
			var sample:Float = (byte / 65535);
			
			if (sample > 0)
				if (sample > max)
					max = sample;
			else if (sample < 0)
				if (sample < min)
					min = sample;
					
			if ((index % samplesPerCollumn) == 0)
			{
				if (drawIndex > FlxG.width)
					drawIndex = 0;
					
				var pixelsMin:Float = Math.abs(min * 300);
				var pixelsMax:Float = max * 300;
				
				pixels.fillRect(new Rectangle(drawIndex, 0, 1, height), funiColor);
				if (isUp)
					pixels.fillRect(new Rectangle(drawIndex, -pixelsMin, 1, pixelsMin + pixelsMax), funiColor);
				else
					pixels.fillRect(new Rectangle(drawIndex, FlxG.height - pixelsMin, 1, pixelsMin + pixelsMax), funiColor);
				drawIndex++;
				
				min = 0;
				max = 0;
			}
			
			index++;
		}
		#if sys
		});
		#end
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
*/
// laggy piece of shit
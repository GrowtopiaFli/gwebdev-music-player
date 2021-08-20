package gwebdev;

import gwebdev.Particle;
import gwebdev.ParticleDestroyType;
import gwebdev.Particle.ParticleGroup;
import gwebdev.ParticleEmitter;
import gwebdev.ParticleEmitterData;
import gwebdev.ParticleEmitter.ParticleEmitterGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxRangeBounds;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class ParticleSystem extends FlxTypedSpriteGroup<ParticleEmitterGroup>
{
	public var emitters:ParticleEmitterGroup;
	
	public function new()
	{
		super();
		
		emitters = new ParticleEmitterGroup();
		add(emitters);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
	
	public function createEmitter(id:String = "emitter1", x:Float = 0, y:Float = 0, m:Int = 0, lifeSpan:Float = 1, width:Int = 0, height:Int = 0, scaleX:Float = 1, scaleY:Float = 1, color:FlxColor = FlxColor.WHITE, ?image:Null<FlxGraphicAsset>, ?alphaRange:FlxPoint, ?speedRange:FlxRangeBounds<Float>, destroyType:ParticleDestroyType, count:Int = 1, explode:Bool = false, freq:Int = 1, delay:Float = 0.1):Void
	{
		if (count < 1)
			count = 1;
		var emitter:ParticleEmitter = new ParticleEmitter(x, y, m);
		emitter.particleData(lifeSpan, width, height, scaleX, scaleY, color, image, alphaRange, speedRange, destroyType, explode, freq, delay);
		emitter.id = id;
		emitter.spawnParticles(count);
		emitter.emit();
		emitters.add(emitter);
	}
	
	public function killEmitter(id:String):Void
	{
		emitters.forEachAlive(
			function(emitter:ParticleEmitter)
			{
				if (emitter.id == id)
				{
					emitter.killEmitter();
					emitters.remove(emitter, true);
					emitter.destroy();
				}
			}
		);
	}
	
	public function killAllEmitters():Void
	{
		emitters.forEachAlive(
			function(emitter:ParticleEmitter)
			{
				emitter.killEmitter();
			}
		);
		emitters.forEach(
			function(emitter:ParticleEmitter)
			{
				emitters.remove(emitter, true);
				emitter.destroy();
			}
		);
	}
}
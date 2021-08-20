package gwebdev;

import flixel.FlxG;
import gwebdev.Particle;
import gwebdev.Particle.ParticleGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxRangeBounds;
import flixel.math.FlxPoint;
import gwebdev.ParticleEmitterData;
import gwebdev.ParticleDestroyType;

import gwebdev.values.DefaultValues;

typedef ParticleEmitterGroup = FlxTypedSpriteGroup<ParticleEmitter>;

class ParticleEmitter extends FlxTypedSpriteGroup<ParticleGroup>
{
	public var emitterData:ParticleEmitterData = DefaultValues.defaultEmitterData;
	public var particles:ParticleGroup;
	public var emitting:Bool = false;

	public var delayTimer:Int = 0;
	
	public var delay:Float = 0.1;
	public var lifeSpan:Float = 1;
	
	public var freq:Int = 1;
	public var isExplode:Bool = false;
	
	public var dead:Bool = false;
	public var id:String = "emitter1";
	
	public var doneExplode:Bool = false;

	public function new(x:Float = 0, y:Float = 0, m:Int = 0)
	{
		super(m);
		
		this.x = x;
		this.y = y;

		particles = new ParticleGroup();
		add(particles);
	}

	public function particleData(lifeSpan:Float = 1, width:Int = 0, height:Int = 0, scaleX:Float = 1, scaleY:Float = 1, color:FlxColor = FlxColor.WHITE, ?image:Null<FlxGraphicAsset>, ?alphaRange:FlxPoint, ?speedRange:FlxRangeBounds<Float>, destroyType:ParticleDestroyType, explode:Bool = false, freq:Int = 1, delay:Float = 0.1):Void
	{
		if (alphaRange == null)
			alphaRange = FlxPoint.get(1, 1);
		if (speedRange == null)
			speedRange = new FlxRangeBounds<Float>(-1, -1, 1, 1);
		emitterData.lifeSpan = lifeSpan;
		emitterData.width = width;
		emitterData.height = height;
		emitterData.scaleX = scaleX;
		emitterData.scaleY = scaleY;
		emitterData.color = color;
		emitterData.image = image;
		emitterData.alphaRange = alphaRange;
		emitterData.speedRange = speedRange;
		emitterData.destroyType = destroyType;
		emitterData.explode = explode;
		emitterData.freq = freq;
		emitterData.delay = delay;
	}
	
	public function spawnParticles(count:Int = 1):Void
	{
		if (count < 1)
			count = 1;
		for (i in 0...count)
			spawnParticle();
	}
	
	public function spawnParticle():Void
	{
		createParticle(
		emitterData.lifeSpan,
		emitterData.width,
		emitterData.height,
		emitterData.scaleX,
		emitterData.scaleY,
		emitterData.color,
		emitterData.image,
		emitterData.alphaRange,
		emitterData.speedRange
		);
	}

	public function createParticle(lifeSpan:Float = 1, width:Int = 0, height:Int = 0, scaleX:Float = 1, scaleY:Float = 1, color:FlxColor = FlxColor.WHITE, ?image:Null<FlxGraphicAsset>, alphaRange:FlxPoint, speedRange:FlxRangeBounds<Float>):Void
	{
		if (width < 0)
			width = 0;
		if (height < 0)
			height = 0;
		var particle:Particle = new Particle();
		if (image != null)
		{
			particle.loadGraphic(image);
			var shouldScaleX:Bool = scaleX != 1;
			var shouldScaleY:Bool = scaleY != 1;
			if (shouldScaleX)
				particle.scale.x = scaleX;
			if (shouldScaleY)
				particle.scale.y = scaleY;
			particle.setGraphicSize(
				(!shouldScaleX && width != 0) ? width : Math.round(particle.width),
				(!shouldScaleY && height != 0) ? height : Math.round(particle.height)
			);
		}
		else
			particle.makeGraphic(width, height, color);
		particle.updateHitbox();
		particle.speed = speedRange;
		particle.randomize();
		var alphaMin:Float = alphaRange.x;
		var alphaMax:Float = alphaRange.y;
		if (alphaMin < 0)
			alphaMin = 0;
		if (alphaMax < 0)
			alphaMax = 0;
		if (alphaMin > 1)
			alphaMin = 1;
		if (alphaMax > 1)
			alphaMax = 1;
		var daAlpha:Float = FlxG.random.float(alphaMin, alphaMax);
		particle.Alpha = daAlpha;
		particle.alpha = daAlpha;
		particle.lifespan = lifeSpan;
		particle.lifeSpan = lifeSpan;
		if (!emitting)
			particle.visible = false;
		particles.add(particle);
	}
	
	public function changeSpeed(?newSpeed:FlxRangeBounds<Float>):Void
	{
		if (newSpeed == null)
			newSpeed = new FlxRangeBounds<Float>(-1, -1, 1, 1);
		particles.forEachAlive(
			function(particle:Particle)
			{
				emitterData.speedRange = newSpeed;
				particle.speed = emitterData.speedRange;
				particle.randomize();
			}
		);
	}
	
	public function removeAll():Void
	{
		particles.forEachAlive(
			function(particle:Particle)
			{
				particle.kill();
			}
		);
		particles.forEach(
			function(particle:Particle)
			{
				particles.remove(particle, true);
				particle.destroy();
			}
		);
	}
	
	public function showAll():Void
	{
		particles.forEachAlive(
			function(particle:Particle)
			{
				particle.visible = true;
			}
		);
	}
	
	public function emit():Void
	{
		// Freq = how many goddamn particles it will spawn every delay
		this.delay = emitterData.delay;
		if (emitterData.freq < 1)
			emitterData.freq = 1;
		this.freq = emitterData.freq;
		this.isExplode = emitterData.explode;
		emitting = true;
		if (!isExplode)
			removeAll();
	}
	
	public function checkLifeSpan(fps:Float):Void
	{
		particles.forEachAlive(
			function(particle:Particle)
			{
				if (particle.visible)
				{
					particle.lifeSpan -= fps;
					if (emitterData.destroyType == ParticleDestroyType.ALPHA)
						particle.alpha = particle.Alpha * (particle.lifeSpan / particle.lifespan);

					if (particle.lifeSpan <= 0)
					{
						particle.kill();
						particles.remove(particle, true);
						particle.destroy();
					}
				}
			}
		);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (emitting)
		{
			delayTimer++;
			var fps:Int = FlxG.updateFramerate;
			var delayFps:Float = delay * fps;
			var lifeSpanFps:Float = 1 / fps;
			if (!isExplode)
			{
				if (delayTimer > delayFps)
				{
					delayTimer = 0;
					spawnParticles(freq);
				}
			}
			else
			{
				if (delayTimer > delayFps && !doneExplode)
				{
					doneExplode = true;
					showAll();
				}

				if (particles.countLiving() < 1)
					killEmitter();
			}
			checkLifeSpan(lifeSpanFps);
		}
		else
			delayTimer = 0;
	}
	
	public function killEmitter():Void
	{
		removeAll();
		emitting = false;
		kill();
	}
}
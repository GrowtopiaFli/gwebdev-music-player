package gwebdev;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.helpers.FlxRangeBounds;

typedef ParticleGroup = FlxTypedSpriteGroup<Particle>;

class Particle extends FlxSprite
{
	// I made this because i need to put variables lol
	public var lifespan:Float = 1;
	public var lifeSpan:Float = 1;
	public var speed:FlxRangeBounds<Float> = new FlxRangeBounds<Float>(-1, -1, 1, 1);
	public var xVel:Float = 0;
	public var yVel:Float = 0;
	public var Alpha:Float = 1;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
	}
	
	public function randomize():Void
	{
		xVel = FlxG.random.float(speed.start.min, speed.end.min);
		yVel = FlxG.random.float(speed.start.max, speed.end.max);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (visible)
		{
			x += xVel;
			y += yVel;
		}
	}
}
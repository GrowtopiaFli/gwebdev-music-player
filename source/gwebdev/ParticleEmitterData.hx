package gwebdev;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxRangeBounds;
import flixel.math.FlxPoint;
import gwebdev.ParticleDestroyType;

typedef ParticleEmitterData =
{
	lifeSpan:Float,
	width:Int,
	height:Int,
	scaleX:Float,
	scaleY:Float,
	color:FlxColor,
	image:Null<FlxGraphicAsset>,
	alphaRange:FlxPoint,
	speedRange:FlxRangeBounds<Float>,
	destroyType:ParticleDestroyType,
	explode:Bool,
	freq:Int,
	delay:Float
};
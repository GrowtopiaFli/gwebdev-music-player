package gwebdev.values;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxPoint;
import flixel.util.helpers.FlxRangeBounds;
import gwebdev.ParticleEmitterData;

class DefaultValues
{
	public static var defaultEmitterData:ParticleEmitterData = { lifeSpan: 1, width: 0, height: 0, scaleX: 1, scaleY: 1, color: FlxColor.WHITE, image: null, alphaRange: FlxPoint.get(1, 1), speedRange: new FlxRangeBounds<Float>(-1, -1, 1, 1), destroyType: INSTANT, explode: false, freq: 1, delay: 0.1 };
}
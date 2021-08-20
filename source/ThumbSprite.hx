package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class ThumbSprite extends FlxSprite
{
	public var idStr:String = "";
	public var idIndex:Int = 0;
	public var idName:String = "";
	public var musPath:String = "";
	public var col:FlxColor = FlxColor.WHITE;

	public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:Null<FlxGraphicAsset>)
	{
		super(X, Y, SimpleGraphic);
	}
	
	public function doScale(scaleGiven:Float = 0):Void
	{
		if (scaleGiven <= 0 && width > FlxG.width)
		{
			setGraphicSize(FlxG.width);
		}
		else if (scaleGiven > 0)
		{
			scale.set(scaleGiven, scaleGiven);
			width = Math.round(width * scaleGiven);
			height = Math.round(height * scaleGiven);
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
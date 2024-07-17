package objects.game;

import flixel.group.FlxSpriteGroup;
import openfl.display.BitmapData;
import shaders.RGBShader;

class SustainNote extends FlxSprite
{
	public var head:Note;

	public function new()
	{
		super();
	}

	public function generateSustain(length:Float, speed:Float)
	{
		var daSprite:BitmapData = null;

		var holdSprite:BitmapData = openfl.utils.Assets.getBitmapData(Paths.location.image('ui/notes/hold'));
		var endSprite:BitmapData = openfl.utils.Assets.getBitmapData(Paths.location.image('ui/notes/end'));

		var daCalculatedLength:Float = length / Conductor.stepCrochet;
		var daCalculatedHeight:Float = (44 * Math.floor(daCalculatedLength) - 1) * Conductor.stepCrochet / 100 * 1.5 * speed;

		if (daCalculatedHeight > 64)
			daCalculatedHeight -= 64;
		else
			daCalculatedHeight = 0;

		daSprite = new BitmapData(49, Std.int(daCalculatedHeight) + 64, true, 0x0);

		if (daCalculatedHeight > 0)
		{
			for (susNote in 0...Std.int(daCalculatedHeight))
				daSprite.draw(holdSprite, new openfl.geom.Matrix(1, 0, 0, 1, 0, susNote), null, null, null, antialiasing);
		}

		daSprite.draw(endSprite, new openfl.geom.Matrix(1, 0, 0, 1, 0, Std.int(daCalculatedHeight)), null, null, null, antialiasing);

		loadGraphic(daSprite);

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
	}
}

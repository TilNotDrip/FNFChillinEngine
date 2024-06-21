package objects.game;

import flixel.group.FlxSpriteGroup;
import openfl.display.BitmapData;
import shaders.RGBShader;

class SustainNote extends FlxSprite
{
    private var rgbShader:RGBShader = new RGBShader();

    public function new(length:Float, ?speed:Float = 1)
    {
        var daSprite:BitmapData = null;

        var holdSprite:BitmapData = BitmapData.fromFile(Paths.getPath('images/ui/notes/hold.png', IMAGE, null));

        var daCalculatedLength:Float = length / Conductor.stepCrochet;
        var daCalculatedHeight:Float = (44 * Math.floor(daCalculatedLength)-1) * Conductor.stepCrochet / 100 * 1.5 * speed;
        daSprite = new BitmapData(49, Std.int(daCalculatedHeight), true, 0x0);
        
        for (susNote in 0...Std.int(daCalculatedHeight))
		{
            daSprite.draw(holdSprite, new openfl.geom.Matrix(1, 0, 0, 1, 0, susNote));
        }

        //Math.floor(daCalculatedLength)

        super();
        
        loadGraphic(daSprite);

        setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
    }
}
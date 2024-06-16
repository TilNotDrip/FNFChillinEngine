package objects.game;

import flixel.group.FlxSpriteGroup;
import openfl.display.BitmapData;
import shaders.RGBShader;

class SustainNote extends FlxSprite
{
    private var rgbShader:RGBShader = new RGBShader();

    public function new(length:Float)
    {
        var daSprite:BitmapData = null;

        var holdSprite:BitmapData = BitmapData.fromFile(Paths.getPath('images/ui/notes/hold.png', IMAGE, null));

        var daCalculatedLength:Float = length / Conductor.stepCrochet;
        
        daSprite = new BitmapData(49, Math.floor(daCalculatedLength), true, 0x0);
        
        for (susNote in 0...Math.floor(daCalculatedLength))
		{
            daSprite.draw(holdSprite, new openfl.geom.Matrix(1, 1, 1, 1, 0, susNote));
        }

        //Math.floor(daCalculatedLength)

        super();
        
        loadGraphic(daSprite);

        setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
    }
}
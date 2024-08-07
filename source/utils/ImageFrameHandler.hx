import flixel.graphics.FlxGraphic;

import flixel.graphics.frames.FlxFrame;
import flixel.graphics.frames.FlxFramesCollection;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;

class ImageFrameHandler extends FlxFramesCollection
{
    public function new(images:Map<String, Array<FlxGraphic>>)
    {
        super(null, FlxFrameCollectionType.IMAGE);

        var daFramez:Array<Array<FlxFrame>> = [];
        var daIThing:Int = 0;
        var firstPass = true;
		var frameSize:FlxPoint = new FlxPoint(0, 0);

        for(i in images.keys())
        {
            daFramez.push([]);

            for(b in images.get(i))
            {
                if (firstPass)
                {
                    frameSize.set(b.width,b.height);
                    firstPass = false;
                }

                var theFrame = new FlxFrame(b);
                theFrame.parent = b;
                theFrame.name = i + daIThing;
                theFrame.sourceSize.set(frameSize.x, frameSize.y);
                theFrame.frame = new FlxRect(0, 0, b.width, b.height);
                daFramez[daFramez.length-1].push(theFrame);
                daIThing++;
            }
        }

        for(x in daFramez) for(y in x) pushFrame(y);
    }
}
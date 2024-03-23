package states;

import openfl.display.Loader;
import openfl.net.URLRequest;
import openfl.events.Event;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

class CreditsState extends MusicBeatState
{
    override function create()
    {
        changeWindowName('Credits Menu');
        //cast Json.parse('https://api.github.com/repos/TechnikTil/ChillinEngine/contributors'.trim());
        //bg.color = FlxColor.interpolate(bg.color, coolColors[songs[curSelected].week % coolColors.length], CoolUtil.camLerpShit(0.045));
    }

    public static function fromWeb(url:String):FlxGraphic
    {
        var daGraphic:FlxGraphic = null;
        
        var loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):Void 
            daGraphic = FlxGraphic.fromBitmapData(cast(loader.content, BitmapData))
        );
        loader.load(new URLRequest(url));

        return daGraphic;
    }
}
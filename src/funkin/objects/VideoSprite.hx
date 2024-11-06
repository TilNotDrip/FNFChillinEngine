package funkin.objects;

#if hxvlc
#else
import flixel.FlxVideo;
#end
import flixel.group.FlxSpriteGroup;

/**
 * A video sprite that contains helpers for either FlxVideo or hxvlc (depending on platform.)
 */
class VideoSprite extends FlxSpriteGroup
{
	/**
	 * @param fileName The name of the video file to display.
	 */
	public function new(fileName:String)
	{
		super();
	}
}

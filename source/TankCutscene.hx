package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.sound.FlxSound;

class TankCutscene extends FlxSprite
{
	public var startSyncAudio:FlxSound;

	public function new(x:Float, y:Float)
	{
		super(x, y);
	}

	var startedPlayingSound:Bool = false;

	override function update(elapsed:Float)
	{
		if(animation.curAnim == null) return;
		if (animation.curAnim.curFrame >= 1 && !startedPlayingSound)
		{
			startSyncAudio.play();
			startedPlayingSound = true;
		}

		super.update(elapsed);
	}
}

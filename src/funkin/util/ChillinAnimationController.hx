package funkin.util;

import flixel.animation.FlxAnimationController;

class ChillinAnimationController extends FlxAnimationController
{
	override public function update(elapsed:Float):Void
	{
		if (curAnim != null)
		{
			if (curAnim.finished && exists(curAnim.name + '-loop'))
				play(curAnim.name + '-loop', true);
		}

		super.update(elapsed);
	}
}

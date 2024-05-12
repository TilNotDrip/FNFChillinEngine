package addons;

import flixel.animation.FlxAnimationController;

class FunkinAnimationController extends FlxAnimationController
{
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if(!curAnim.name.endsWith('-loop') && curAnim.finished && exists(curAnim.name + '-loop'))
            play(curAnim.name + '-loop', true);

    }
}
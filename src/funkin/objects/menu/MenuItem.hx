package funkin.objects.menu;

import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

class MenuItem extends FlxSprite
{
	/**
	 * The name of the item.
	 */
	public var name:String;

	/**
	 * The function to call when this item is pressed.
	 */
	public var pressCallback:Void->Void = null;

	/**
	 * The function to call when this item disappears.
	 */
	public var disappearCallback:Void->Void = null;

	/**
	 * How long to wait until it plays the functions after a press.
	 */
	public var waitTime:Float = 1;

	public function new(y:Float, name:String)
	{
		this.name = name;

		super(0, y);

		frames = Paths.content.sparrowAtlas('mainmenu/items/' + name);
		animation.addByPrefix('idle', name + ' idle', 24);
		animation.addByPrefix('selected', name + ' selected', 24);
		animation.play('idle');
	}

	/**
	 * Flickers the visibility and runs a timer then runs a custom callback if one exists.
	 *
	 * This is meant for the selected item only.
	 */
	public function press():Void
	{
		FlxTransitionableState.skipNextTransIn = false;
		FlxTransitionableState.skipNextTransOut = false;

		if (FunkinOptions.get('flashingLights'))
			FlxFlicker.flicker(this, 1, 0.06, false, false);

		new FlxTimer().start(waitTime, function(tmr:FlxTimer)
		{
			if (pressCallback == null)
				FlxG.resetState();

			pressCallback();
		});
	}

	/**
	 * Runs a tween to make this item disappear.
	 *
	 * This is meant for all the non selected items.
	 */
	public function disappear():Void
	{
		FlxTween.tween(this, {alpha: 0}, 0.4, {
			ease: FlxEase.quadOut
		});

		new FlxTimer().start(waitTime, function(tmr:FlxTimer)
		{
			if (disappearCallback != null)
				disappearCallback();
		});
	}
}

package options.substates;

import flixel.FlxCamera;
import flixel.FlxObject;
import options.objects.Option;
import options.states.OptionsState;

/**
 * The base structure for an options substate.
 *
 * You can just extend this and add all the options in the create function.
 */
class BaseSubState extends MusicBeatSubstate
{
	public static var parent:OptionsState;

	private static var curSelected:Int = 0;

	private var options:Array<Option> = [];

	override public function create():Void
	{
		super.create();

		for (i in 0...options.length)
		{
			options[i].y = 100 + (90 * i);
			options[i].optionTxt.targetY = i;
		}

		changeItem();
	}

	override public function update(elapsed:Float):Void
	{
		if (controls.BACK)
		{
			OptionsState.optionItems.visible = true;

			#if DISCORD
			DiscordRPC.state = null;
			#end

			close();
		}

		if (controls.UI_UP_P)
			changeItem(-1);

		if (controls.UI_DOWN_P)
			changeItem(1);

		if (controls.UI_LEFT_P)
			changeOptionValue(-1);

		if (controls.UI_RIGHT_P)
			changeOptionValue(1);

		if (controls.ACCEPT)
		{
			if (options[curSelected].type == CHECKBOX)
				options[curSelected].press();
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;

		if (curSelected >= options.length)
			curSelected = 0;

		var targetPlacement:Int = 0;

		for (i in 0...options.length)
		{
			options[i].optionTxt.targetY = targetPlacement - curSelected;
			options[i].alpha = 0.6;

			targetPlacement++;
		}

		options[curSelected].alpha = 1;
	}

	function changeOptionValue(change:Int = 0):Void
	{
		if (options[curSelected].type == NUMBER)
		{
			var multiplier:Float = 1;

			if (options[curSelected].numType == Float)
				multiplier = 0.1;

			options[curSelected].changeValue(change * multiplier);
		}
		else if (options[curSelected].type == SELECTION)
			options[curSelected].changeValue(change);
	}

	function addOption(option:Option):Void
	{
		options.push(option);
		add(option);
	}
}

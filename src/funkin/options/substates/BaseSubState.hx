package funkin.options.substates;

import funkin.options.objects.Option;
import funkin.options.states.OptionsState;

class BaseSubState extends MusicBeatSubstate
{
	public static var parent:OptionsState;

	static var curSelected:Int = 0;

	var options:Array<Option> = [];

	override public function create()
	{
		super.create();

		for (i in 0...options.length)
		{
			options[i].screenCenter(X);
			options[i].y = 100 + (90 * i);
		}

		changeItem();
	}

	override public function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			OptionsState.optionItems.visible = true;

			#if FUNKIN_DISCORD_RPC
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

	function changeItem(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;

		if (curSelected >= options.length)
			curSelected = 0;

		for (i in 0...options.length)
			options[i].alpha = 0.6;

		options[curSelected].alpha = 1;
	}

	function changeOptionValue(change:Int = 0)
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

	function addOption(option:Option)
	{
		options.push(option);
		add(option);
	}
}

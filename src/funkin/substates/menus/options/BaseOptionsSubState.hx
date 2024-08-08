package funkin.substates.menus.options;

import funkin.states.menus.OptionsState;

class BaseOptionsSubState extends MusicBeatSubstate
{
	static var curSelected:Int = 0;

	var options:Array<Option> = [];

	override public function create():Void
	{
		super.create();

		for (i in 0...options.length)
		{
			options[i].optionTxt.isMenuItem = true;
			options[i].optionTxt.targetY = i;
		}

		changeItem();
	}

	var holdTimer:Float = 0;

	override public function update(elapsed:Float):Void
	{
		if (controls.BACK)
		{
			FunkinOptions.settingsSave.flush();

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

		if (controls.UI_LEFT || controls.UI_RIGHT)
		{
			holdTimer += elapsed;

			if (controls.UI_LEFT_P || controls.UI_RIGHT_P || holdTimer > 0.5)
			{
				if (controls.UI_LEFT)
					changeOptionValue(-1);
				else if (controls.UI_RIGHT)
					changeOptionValue(1);
			}
		}

		if (controls.UI_LEFT_R || controls.UI_RIGHT_R)
			holdTimer = 0;

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
			var timer:Float = holdTimer / 750;

			if (options[curSelected].numType == Int)
				timer = Math.round(holdTimer / 1500);

			var multiplier:Float = 1;

			if (options[curSelected].numType == Float)
				multiplier = 0.1;

			options[curSelected].changeValue((change * multiplier) + ((change <= 0) ? -timer : timer));
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

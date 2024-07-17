package options.states;

import options.substates.BaseSubState;
import options.substates.options.*;

class OptionsState extends MusicBeatState
{
	private var optionsList:Array<String> = ['Controls', 'Display', 'Gameplay', 'Flixel', 'Other'];

	private static var curSelected:Int = 0;

	public static var optionItems:FlxTypedGroup<Alphabet>;

	override public function create()
	{
		changeWindowName('Options Menu');

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = 'Options Menu';
		#end

		FlxG.cameras.reset(new SwagCamera());

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.content.image('menuUI/menuBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);

		optionItems = new FlxTypedGroup<Alphabet>();
		add(optionItems);

		for (i in 0...optionsList.length)
		{
			var optionItem = new Alphabet(0, 100 + (90 * i), optionsList[i], BOLD);
			optionItem.screenCenter(X);
			optionItem.ID = i;
			optionItems.add(optionItem);
		}

		changeSelection();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
			changeSelection(-1);

		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
			openMenu(optionsList[curSelected]);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.location.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	private function changeSelection(change:Int = 0)
	{
		if (!optionItems.visible)
			return;

		curSelected += change;

		if (curSelected < 0)
			curSelected = optionsList.length - 1;

		if (curSelected >= optionsList.length)
			curSelected = 0;

		optionItems.forEach(function(option:Alphabet)
		{
			if (option.ID == curSelected)
				option.alpha = 1;
			else
				option.alpha = 0.6;
		});

		FlxG.sound.play(Paths.location.sound('scrollMenu'), 0.4);
	}

	private function openMenu(option:String)
	{
		optionItems.visible = false;

		switch (option.formatToPath())
		{
			case 'controls':
				openSubState(new ControlsSubState());
			case 'display':
				openSubState(new Display());
			case 'gameplay':
				openSubState(new Gameplay());
			case 'flixel':
				openSubState(new Flixel());
			case 'other':
				openSubState(new Other());
		}
	}
}

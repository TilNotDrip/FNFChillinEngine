package options.states;

import options.substates.*;

class OptionsState extends MusicBeatState
{
    var optionsList:Array<String> = ['Controls', 'Display', 'Gameplay', 'Flixel', 'Other'];
    static var curSelected:Int = 0;

    var optionItems:FlxTypedGroup<Alphabet>;

    override function create()
    {
		changeWindowName('Options Menu');

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuUI/menuBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);

        optionItems = new FlxTypedGroup<Alphabet>();
        add(optionItems);

        for (i in 0...optionsList.length)
        {
            var optionItem = new Alphabet(0, 100 + (90 * i), optionsList[i], true, false);
			optionItem.screenCenter(X);
			optionItem.ID = i;
            optionItems.add(optionItem);
        }

        changeSelection();

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (controls.UI_UP_P)
			changeSelection(-1);

		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
			openMenu(optionsList[curSelected]);

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxG.switchState(new MainMenuState());
        }

        super.update(elapsed);
    }

    function changeSelection(change:Int = 0)
    {
        if(!optionItems.visible) return;

        curSelected += change;

		if (curSelected < 0)
			curSelected = optionsList.length - 1;
		if (curSelected >= optionsList.length)
			curSelected = 0;

        optionItems.forEach(function(option:Alphabet) {
            if (option.ID == curSelected)
                option.alpha = 1;
            else
                option.alpha = 0.6;
        });

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
    }

	function openMenu(option:String)
	{
        optionItems.visible = false;

		switch (option.formatToPath())
		{
            case 'controls':
                openSubState(new ControlsSubState(this));
			case 'display' | 'gameplay' | 'flixel' | 'other':
				openSubState(new BaseSubState(this));
		}
	}

    public function closeMenu() optionItems.visible = true;
}
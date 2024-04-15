package options.substates.options;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import options.states.OptionsState;

class ControlsSubState extends MusicBeatSubstate
{
    public static var parent:OptionsState;

    private static var curSelected:Int = 0;
    private var controlMap:Map<String, Array<Array<String>>>;
    private var options:FlxTypedSpriteGroup<FlxTypedSpriteGroup<Alphabet>>;

    override public function create()
    {
        super.create();

        controlMap = PlayerSettings.getControls(0);
        options = new FlxTypedSpriteGroup<FlxTypedSpriteGroup<Alphabet>>();

        for (control in controlMap.keys())
        {
            var optionGroup:FlxTypedSpriteGroup<Alphabet> = new FlxTypedSpriteGroup<Alphabet>();

            var nameOption:Alphabet = new Alphabet(0, 0, control);
            optionGroup.screenCenter(X);
            optionGroup.y = 100 + (90 * options.length);
            options.add(optionGroup);
        }

        changeItem();
    }

    override public function update(elapsed:Float)
    {
        if (controls.BACK)
        {
            parent.closeMenu();
            close();
        }

        if(controls.UI_UP_P)
            changeItem(-1);

        if(controls.UI_DOWN_P)
            changeItem(1);

        if(controls.UI_LEFT_P)
            changeOptionValue(-1);

        if(controls.UI_RIGHT_P)
            changeOptionValue(1);

        if (controls.ACCEPT)
        {
            if (options[curSelected].type == CHECKBOX)
                options[curSelected].press();
        }

        super.update(elapsed);
    }

    private function changeItem(change:Int = 0)
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

    private function changeOptionValue(change:Int = 0)
    {
        if (options[curSelected].type == NUMBER && options[curSelected].numType == Int)
            options[curSelected].changeValue(change);
        else if (options[curSelected].type == NUMBER && options[curSelected].numType == Float)
            options[curSelected].changeValue(change * 0.1);
    }

    private function addOption(option:Option)
    {
        options.push(option);
        add(option);
    }
}

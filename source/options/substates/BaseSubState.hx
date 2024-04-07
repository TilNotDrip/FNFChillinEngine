package options.substates;

import options.objects.Option;
import options.states.OptionsState;

class BaseSubState extends MusicBeatSubstate
{
    public static var parent:OptionsState;
    var canDoShit:Bool = false;

    private static var curSelected:Int = 0;
    private var options:Array<Option> = [];

    override function create()
    {
        super.create();

        new FlxTimer().start(0.001, function(timer:FlxTimer) {
            canDoShit = true; // stupid fix
        });

        for (i in 0...options.length)
        {
            options[i].screenCenter(X);
            options[i].y = 100 + (90 * i);
        }

        changeItem();
    }

    override function update(elapsed:Float)
    {
        if (controls.BACK)
        {
            parent.closeMenu();
            close();
        }

        if(controls.UI_UP_P && canDoShit)
            changeItem(-1);

        if(controls.UI_DOWN_P && canDoShit)
            changeItem(1);

        if(controls.UI_LEFT_P && canDoShit)
            changeOptionValue(-1);

        if(controls.UI_RIGHT_P && canDoShit)
            changeOptionValue(1);

        if (controls.ACCEPT && canDoShit)
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
package options.substates;

import options.objects.Option;
import options.states.OptionsState;

class BaseSubState extends MusicBeatSubstate
{
    public static var parent:OptionsState;
    var canDoShit:Bool = false;

    private static var curSelected:Int = 0;
    private var options:FlxTypedGroup<Option>;

    public function new()
    {
        super();

        options = new FlxTypedGroup<Option>();
        add(options);

        new FlxTimer().start(0.001, function(timer:FlxTimer) {
            canDoShit = true; // stupid fix
        });

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

        if (controls.ACCEPT && canDoShit)
        {
            options.forEach(function(option:Option) {
                if (option.ID == curSelected && option.type == CHECKBOX)
                    option.press(!option.value);
            });
        }

        super.update(elapsed);
    }

    function changeItem(change:Int = 0)
	{
		curSelected += change;

		if (curSelected >= options.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = options.length - 1;

        options.forEach(function(option:Option) {
            if (option.ID == curSelected)
                option.alpha = 1;
            else
                option.alpha = 0.6;
        });
	}
}
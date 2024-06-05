package options.substates;

import flixel.FlxCamera;
import flixel.FlxObject;
import options.objects.Option;

import options.states.OptionsState;

class BaseSubState extends MusicBeatSubstate
{
    public static var parent:OptionsState;

    private static var curSelected:Int = 0;
    private var options:Array<Option> = [];
    
    private var camFollow:FlxObject = new FlxObject();

    override public function create()
    {
        super.create();

        camFollow.x = FlxG.width / 2;

        var camOptions:FlxCamera = new SwagCamera();
        camOptions.follow(camFollow, LOCKON, 0.04);
        camOptions.focusOn(camFollow.getPosition());
        camOptions.bgColor.alpha = 0;
        FlxG.cameras.add(camOptions, false);

        for (i in 0...options.length)
        {
            options[i].screenCenter(X);
            options[i].y = 100 + (180 * i);
            options[i].cameras = [camOptions];
        }

        changeItem();
    }

    override public function update(elapsed:Float)
    {
        if (controls.BACK)
        {
            OptionsState.optionItems.visible = true;

            #if DISCORD
            DiscordRPC.state = null;
            #end

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

        camFollow.setPosition(options[curSelected].getGraphicMidpoint().x, options[curSelected].getGraphicMidpoint().y);
	}

    private function changeOptionValue(change:Int = 0)
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

    private function addOption(option:Option)
    {
        options.push(option);
        add(option);
    }
}
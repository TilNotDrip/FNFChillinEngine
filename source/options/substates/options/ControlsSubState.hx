package options.substates.options;


import flixel.effects.FlxFlicker;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import flixel.input.keyboard.FlxKey;

import options.states.OptionsState;

class ControlsSubState extends MusicBeatSubstate
{
    private static var curSelected:Int = 0;
    private var controlOptions:Array<String> = [];
    private var optionHeader:Alphabet;
    private var optionControls:Alphabet;
    private var rebindNotice:Alphabet;

    override function create()
    {
        #if DISCORD
        DiscordRPC.state = 'Controls';
        #end

        super.create();

        optionHeader = new Alphabet(0, 0, '', BOLD);
        optionHeader.scrollFactor.set();

        optionControls = new Alphabet(0, 0, '', DEFAULT);
        optionControls.scrollFactor.set();
        
        rebindNotice = new Alphabet(0, 0, '', DEFAULT);
        rebindNotice.screenCenter();
        rebindNotice.scrollFactor.set();

        for (controlName in PlayerSettings.getControls(0).keys())
            controlOptions.push(controlName);

        add(optionHeader);
        add(optionControls);
        add(rebindNotice);

        rebindNotice.visible = false;

        changeItem();
    }

    var escapeTimer:Float = 0;
    override function update(elapsed:Float)
    {
        if (controls.BACK && rebindingStage == -1)
        {
            OptionsState.optionItems.visible = true;
            close();
        }

        if (controls.ACCEPT && rebindingStage == -1)
            rebindKey();

        if (controls.UI_LEFT_P && rebindingStage == -1)
            changeItem(-1);

        if (controls.UI_RIGHT_P && rebindingStage == -1)
            changeItem(1);

        if(FlxG.keys.justReleased.ANY && rebindingStage != -1 && okAcceptIsOver)
        {
            var daKey:FlxKey = FlxG.keys.firstJustReleased();
            PlayerSettings.getControls(0).get(controlOptions[curSelected])[0].push(daKey);
            optionControls.text = PlayerSettings.getControls(0).get(controlOptions[curSelected])[0].toString();
            rebindingStage++;
        }

        if (controls.checkKey('ACCEPT', 'released')  && !okAcceptIsOver)
            okAcceptIsOver = true;

        if(controls.checkKey('BACK') && rebindingStage != -1)
        {
            escapeTimer -= elapsed;

            if(escapeTimer <= 0)
            {
                rebindingStage = -1;

                FlxFlicker.stopFlickering(optionHeader);
                FlxFlicker.stopFlickering(optionControls);
                rebindNotice.visible = false;

                changeItem();

                escapeTimer = 3;
            }
        }

        if(rebindingStage == -1 || (!controls.checkKey('BACK') && rebindingStage != -1))
            escapeTimer = 3;

        FlxG.watch.addQuick('timer', escapeTimer);

        if(!rebindNotice.text.contains(Std.string(Math.round(escapeTimer))))
        {
            rebindNotice.text = 'Rebinding...\nHold your back key for ' + Math.round(escapeTimer) + ' sec to exit';
            rebindNotice.screenCenter();
            rebindNotice.x += rebindNotice.height * 2;
        }

        super.update(elapsed);
    }

    function changeItem(change:Int = 0)
	{
		curSelected += change;

        if (curSelected < 0)
			curSelected = controlOptions.length - 1;

		if (curSelected >= controlOptions.length)
			curSelected = 0;

        optionHeader.text = controlOptions[curSelected];
        optionControls.text = PlayerSettings.getControls(0).get(controlOptions[curSelected])[0].toString();

        optionHeader.updateHitbox();
        optionHeader.screenCenter();
        optionHeader.y -= optionHeader.height;

        optionControls.updateHitbox();
        optionControls.screenCenter();
        optionControls.y += optionControls.height;
	}

    var rebindingStage:Int = -1;
    var okAcceptIsOver:Bool = false;
    function rebindKey()
    {
        FlxFlicker.flicker(optionHeader, 0, 0.3, false, false);
        FlxFlicker.flicker(optionControls, 0, 0.3, false, false);

        rebindingStage++;

        PlayerSettings.getControls(0).get(controlOptions[curSelected])[0] = [];

        rebindNotice.visible = true;
        okAcceptIsOver = false;
    }
}

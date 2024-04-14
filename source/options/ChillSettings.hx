package options;

class ChillSettings
{
    public static var everyCategory(get, never):Array<String>;
    static var controls:Map<String, Dynamic> = new Map(); // Honestly have no idea if or when im gonna use this -Crusher Im implementing
    static var displaySettings:Map<String, Dynamic> = new Map();
    static var gameplaySettings:Map<String, Dynamic> = new Map();
    static var flixelSettings:Map<String, Dynamic> = new Map();
    static var otherSettings:Map<String, Dynamic> = new Map();

    static function get_everyCategory():Array<String> // stupid for right now, but for softcoded options maybe
    {
        var yea:Array<String> = [
            'controls',
            'display',
            'gameplay',
            'flixel',
            'other'
        ];

        return yea;
    }

    public static function get(option:String, category:String):Dynamic
    {
        var returnThing:Dynamic = null;

        switch (category.formatToPath())
        {
            case 'controls': returnThing = controls.get(option);
            case 'display': returnThing = displaySettings.get(option);
            case 'gameplay': returnThing = gameplaySettings.get(option);
            case 'flixel': returnThing = flixelSettings.get(option);
            case 'other': returnThing = otherSettings.get(option);
        }

        if(returnThing == null)
            returnThing = getNullOption(option, category.formatToPath());

        return returnThing;
    }

    public static function set(option:String, category:String, value:Dynamic)
    {
        switch (category.formatToPath())
        {
            case 'display':
                displaySettings.set(option, value);
                FlxG.save.data.displaySettings = displaySettings;

            case 'gameplay':
                gameplaySettings.set(option, value);
                FlxG.save.data.gameplaySettings = gameplaySettings;

            case 'flixel':
                flixelSettings.set(option, value);
                FlxG.save.data.flixelSettings = flixelSettings;

            case 'other':
                otherSettings.set(option, value);
                FlxG.save.data.otherSettings = otherSettings;
        }

        trace('Set Option ${category}/${option} to ${value}!');
        FlxG.save.flush();
    }

    public static function loadSettings()
    {
        setDefaultSettings();

        // Display
        {
            displaySettings = FlxG.save.data.displaySettings;

            FlxG.updateFramerate = ChillSettings.get('fps', 'display');
            FlxG.drawFramerate = ChillSettings.get('fps', 'display');

            if (Main.fpsCounter != null)
                Main.fpsCounter.visible = ChillSettings.get('fpsCounter', 'display');

            FlxG.fullscreen = ChillSettings.get('fullscreen', 'display');
    
            FlxSprite.defaultAntialiasing = ChillSettings.get('antialiasing', 'display');

            trace('Loaded Display Settings!');
        }

        // Gameplay
        {
            gameplaySettings = FlxG.save.data.gameplaySettings;
            trace('Loaded Gameplay Settings!');
        }

        // Flixel
        {
            flixelSettings = FlxG.save.data.flixelSettings;

            FlxG.autoPause = ChillSettings.get('autoPause', 'flixel');
            #if FLX_MOUSE
            FlxG.mouse.useSystemCursor = ChillSettings.get('systemCursor', 'flixel');
            #end

            trace('Loaded Flixel Settings!');
        }

        // Other
        {
            otherSettings = FlxG.save.data.otherSettings;
            trace('Loaded Other Settings!');
        }

        // I know I might be adding audio things but if even if I dont minus well
        if(FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;
    }

    static function setDefaultSettings()
    {
        var optionsToCheckFor:Array<Array<Dynamic>> = [];
        for(category in everyCategory)
        {
            switch (category.formatToPath())
            {
                case 'display':
                    optionsToCheckFor = [
                        ['fps', 60],
                        ['fpsCounter', true],
                        ['fullscreen', false],
                        ['antialiasing', true],
                        ['flashingLights', true]
                    ];

                case 'gameplay':
                    optionsToCheckFor = [
                        ['camZoom', true],
                        ['ghostTapping', true],
                        ['downScroll', false],
                        ['middleScroll', false],
                        ['noteSplashes', true],
                        ['cutscenes', true]
                    ];

                case 'flixel':
                    optionsToCheckFor = [
                        ['autoPause', false]
                    ];

                    #if FLX_MOUSE
                    optionsToCheckFor.push(['systemCursor', true]);
                    #end

                case 'other':
                    #if discord_rpc
                    optionsToCheckFor.push(['discordRPC', true]);
                    #end
                    #if MOD_SUPPORT
                    optionsToCheckFor.push(['safeMode', false]);
                    #end
                    optionsToCheckFor.push(['devMode', false]);
            }

            for(i in 0...optionsToCheckFor.length)
            {
                var option:String = Std.string(optionsToCheckFor[i][0]);
                var toSetTo:Dynamic = optionsToCheckFor[i][1];

                if(get(option, category.formatToPath()) == null)
                    set(option, category.formatToPath(), toSetTo);
            }
        }

        trace('Updated settings!');
    }

    // might use for softcoded functions if i feel nice
    static function setNullOption(option:String, category:String)
    {
        return null;
    }

    static function getNullOption(option:String, category:String):Dynamic
    {
        //FlxG.log.error(option + ' option doesn\'t exist in category: ' + category);
        return null;
    }
}
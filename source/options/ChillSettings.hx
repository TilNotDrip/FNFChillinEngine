package options;

import flixel.util.FlxSave;

class ChillSettings
{
    private static var chillSettings:FlxSave;

    private static var controls:Map<String, Dynamic> = new Map();
    private static var displaySettings:Map<String, Dynamic> = new Map();
    private static var gameplaySettings:Map<String, Dynamic> = new Map();
    private static var flixelSettings:Map<String, Dynamic> = new Map();
    private static var otherSettings:Map<String, Dynamic> = new Map();

    public static function get(option:String, category:OptionType):Dynamic
    {
        var returnThing:Dynamic;

        switch (category)
        {
            case CONTROLS: returnThing = controls.get(option);
            case DISPLAY: returnThing = displaySettings.get(option);
            case GAMEPLAY: returnThing = gameplaySettings.get(option);
            case FLIXEL: returnThing = flixelSettings.get(option);
            case OTHER: returnThing = otherSettings.get(option);
        }

        return returnThing;
    }

    public static function set(option:String, category:OptionType, value:Dynamic)
    {
        switch (category)
        {
            case CONTROLS:
                controls.set(option, value);
                chillSettings.data.controls = controls;

            case DISPLAY:
                displaySettings.set(option, value);
                chillSettings.data.displaySettings = displaySettings;

            case GAMEPLAY:
                gameplaySettings.set(option, value);
                chillSettings.data.gameplaySettings = gameplaySettings;

            case FLIXEL:
                flixelSettings.set(option, value);
                chillSettings.data.flixelSettings = flixelSettings;

            case OTHER:
                otherSettings.set(option, value);
                chillSettings.data.otherSettings = otherSettings;
        }

        chillSettings.flush();
        trace('Set Option ${category}/${option} to ${value}!');
    }

    public static function loadSettings()
    {
        chillSettings = new FlxSave();
		chillSettings.bind('settings', CoolTools.getSavePath());

        controls = chillSettings.data.controls;
        displaySettings = chillSettings.data.displaySettings;
        gameplaySettings = chillSettings.data.gameplaySettings;
        flixelSettings = chillSettings.data.flixelSettings;
        otherSettings = chillSettings.data.otherSettings;

        checkNulls();
        setDefaultSettings();

        FlxG.updateFramerate = ChillSettings.get('fps', DISPLAY);
        FlxG.drawFramerate = ChillSettings.get('fps', DISPLAY);

        if (Main.fpsCounter != null)
            Main.fpsCounter.visible = ChillSettings.get('fpsCounter', DISPLAY);

        FlxG.fullscreen = ChillSettings.get('fullscreen', DISPLAY);

        FlxSprite.defaultAntialiasing = ChillSettings.get('antialiasing', DISPLAY);

        FlxG.autoPause = ChillSettings.get('autoPause', FLIXEL);
        #if FLX_MOUSE
        FlxG.mouse.useSystemCursor = ChillSettings.get('systemCursor', FLIXEL);
        #end

        // I know I might be adding audio things but if even if I dont minus well
        if(FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;
    }

    private static function checkNulls()
    {
        if (controls == null)
			controls = new Map<String, Dynamic>();
		if (displaySettings == null)
			displaySettings = new Map<String, Dynamic>();
		if (gameplaySettings == null)
			gameplaySettings = new Map<String, Dynamic>();
        if (flixelSettings == null)
			flixelSettings = new Map<String, Dynamic>();
        if (otherSettings == null)
			otherSettings = new Map<String, Dynamic>();

        if (chillSettings.data.controls == null)
			chillSettings.data.controls = new Map<String, Dynamic>();
		if (chillSettings.data.displaySettings == null)
			chillSettings.data.displaySettings = new Map<String, Dynamic>();
		if (chillSettings.data.gameplaySettings == null)
			chillSettings.data.gameplaySettings = new Map<String, Dynamic>();
        if (chillSettings.data.flixelSettings == null)
			chillSettings.data.flixelSettings = new Map<String, Dynamic>();
        if (chillSettings.data.otherSettings == null)
			chillSettings.data.otherSettings = new Map<String, Dynamic>();
    }

    private static function setDefaultSettings()
    {
        // Display
        if (chillSettings.data.displaySettings.get('fps') == null)
			set('fps', DISPLAY, 60);
        if (chillSettings.data.displaySettings.get('fpsCounter') == null)
			set('fpsCounter', DISPLAY, true);
        if (chillSettings.data.displaySettings.get('fullscreen') == null)
			set('fullscreen', DISPLAY, false);
        if (chillSettings.data.displaySettings.get('antialiasing') == null)
			set('antialiasing', DISPLAY, true);
        if (chillSettings.data.displaySettings.get('flashingLights') == null)
			set('flashingLights', DISPLAY, true);

        // Gameplay
        if (chillSettings.data.gameplaySettings.get('camZoom') == null)
			set('camZoom', GAMEPLAY, true);
        if (chillSettings.data.gameplaySettings.get('ghostTapping') == null)
			set('ghostTapping', GAMEPLAY, true);
        if (chillSettings.data.gameplaySettings.get('downScroll') == null)
			set('downScroll', GAMEPLAY, false);
        if (chillSettings.data.gameplaySettings.get('middleScroll') == null)
			set('middleScroll', GAMEPLAY, false);
        if (chillSettings.data.gameplaySettings.get('noteSplashes') == null)
			set('noteSplashes', GAMEPLAY, true);
        if (chillSettings.data.gameplaySettings.get('cutscenes') == null)
			set('cutscenes', GAMEPLAY, true);

        // Flixel
        if (chillSettings.data.flixelSettings.get('autoPause') == null)
			set('autoPause', FLIXEL, false);

        #if FLX_MOUSE
        if (chillSettings.data.flixelSettings.get('systemCursor') == null)
			set('systemCursor', FLIXEL, true);
        #end

        // Other
        #if discord_rpc
        if (chillSettings.data.otherSettings.get('discordRPC') == null)
			set('discordRPC', OTHER, true);
        #end
        #if MOD_SUPPORT
        if (chillSettings.data.otherSettings.get('safeMode') == null)
			set('safeMode', OTHER, false);
        #end
        if (chillSettings.data.otherSettings.get('devMode') == null)
			set('devMode', OTHER, false);
    }
}

enum abstract OptionType(String)
{
    var CONTROLS = 'control';
	var DISPLAY = 'display';
	var GAMEPLAY = 'gameplay';
    var FLIXEL = 'flixel';
    var OTHER = 'other';
}
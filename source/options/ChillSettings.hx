package options;

import flixel.util.FlxSave;

class ChillSettings
{
    private static var chillSettings:FlxSave;

    private static var displaySettings:Map<String, Dynamic> = new Map();
    private static var gameplaySettings:Map<String, Dynamic> = new Map();
    private static var flixelSettings:Map<String, Dynamic> = new Map();
    private static var otherSettings:Map<String, Dynamic> = new Map();

    public static function get(option:String, category:OptionType):Dynamic
    {
        var returnThing:Dynamic;

        switch (category)
        {
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

        displaySettings = chillSettings.data.displaySettings;
        gameplaySettings = chillSettings.data.gameplaySettings;
        flixelSettings = chillSettings.data.flixelSettings;
        otherSettings = chillSettings.data.otherSettings;

        checkNulls();

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
		if (displaySettings == null)
			displaySettings = new Map<String, Dynamic>();
		if (gameplaySettings == null)
			gameplaySettings = new Map<String, Dynamic>();
        if (flixelSettings == null)
			flixelSettings = new Map<String, Dynamic>();
        if (otherSettings == null)
			otherSettings = new Map<String, Dynamic>();

		if (chillSettings.data.displaySettings == null)
			chillSettings.data.displaySettings = new Map<String, Dynamic>();

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

		if (chillSettings.data.gameplaySettings == null)
			chillSettings.data.gameplaySettings = new Map<String, Dynamic>();

        if (chillSettings.data.gameplaySettings.get('camZoom') == null)
			set('camZoom', GAMEPLAY, true);
        if (chillSettings.data.gameplaySettings.get('ghostTapping') == null)
			set('ghostTapping', GAMEPLAY, true);
        if (chillSettings.data.gameplaySettings.get('hudType') == null)
			set('hudType', GAMEPLAY, 'Score / Rating Counter / Health');
        if (chillSettings.data.gameplaySettings.get('downScroll') == null)
			set('downScroll', GAMEPLAY, false);
        if (chillSettings.data.gameplaySettings.get('middleScroll') == null)
			set('middleScroll', GAMEPLAY, false);
        if (chillSettings.data.gameplaySettings.get('noteSplashes') == null)
			set('noteSplashes', GAMEPLAY, true);
        if (chillSettings.data.gameplaySettings.get('cutscenes') == null)
			set('cutscenes', GAMEPLAY, true);

        if (chillSettings.data.flixelSettings == null)
			chillSettings.data.flixelSettings = new Map<String, Dynamic>();

        if (chillSettings.data.flixelSettings.get('autoPause') == null)
			set('autoPause', FLIXEL, false);
        #if FLX_MOUSE
        if (chillSettings.data.flixelSettings.get('systemCursor') == null)
			set('systemCursor', FLIXEL, true);
        #end

        if (chillSettings.data.otherSettings == null)
			chillSettings.data.otherSettings = new Map<String, Dynamic>();

        #if DISCORD
        if (chillSettings.data.otherSettings.get('discordRPC') == null)
			set('discordRPC', OTHER, true);
        #end
        #if MOD_SUPPORT
        if (chillSettings.data.otherSettings.get('safeMode') == null)
			set('safeMode', OTHER, false);
        #end

        set('devMode', OTHER, false);
    }
}

enum abstract OptionType(String)
{
	var DISPLAY = 'display';
	var GAMEPLAY = 'gameplay';
    var FLIXEL = 'flixel';
    var OTHER = 'other';
}
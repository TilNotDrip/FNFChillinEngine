package options;

import flixel.util.FlxSave;

class ChillSettings
{
	private static var chillSettings:FlxSave;

	private static var options:Map<String, Dynamic> = new Map();

	public static function get(option:String):Dynamic
	{
		return options.get(option);
	}

	public static function set(option:String, value:Dynamic)
	{
		options.set(option, value);
		chillSettings.data.options = options;

		chillSettings.flush();
		trace('Set Option ${option} to ${value}!');
	}

	public static function loadSettings()
	{
		chillSettings = new FlxSave();
		chillSettings.bind('settings', CoolUtil.getSavePath());

		options = chillSettings.data.options;

		setDefaults();

		FlxG.updateFramerate = ChillSettings.get('fps');
		FlxG.drawFramerate = ChillSettings.get('fps');

		if (Main.fpsCounter != null)
			Main.fpsCounter.visible = ChillSettings.get('fpsCounter');

		FlxG.fullscreen = ChillSettings.get('fullscreen');

		FlxSprite.defaultAntialiasing = ChillSettings.get('antialiasing');

		FlxG.autoPause = ChillSettings.get('autoPause');
		#if FLX_MOUSE
		FlxG.mouse.useSystemCursor = ChillSettings.get('systemCursor');
		#end

		// I know I might be adding audio things but if even if I dont minus well
		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;
	}

	private static function setDefaults():Void
	{
		if (options == null)
			options = new Map<String, Dynamic>();

		if (chillSettings.data.options == null)
			chillSettings.data.options = new Map<String, Dynamic>();

		// Display Settings
		if (chillSettings.data.options.get('fps') == null)
			set('fps', 60);
		if (chillSettings.data.options.get('fpsCounter') == null)
			set('fpsCounter', true);
		if (chillSettings.data.options.get('fullscreen') == null)
			set('fullscreen', false);
		if (chillSettings.data.options.get('antialiasing') == null)
			set('antialiasing', true);
		if (chillSettings.data.options.get('flashingLights') == null)
			set('flashingLights', true);

		// Gameplay Settings
		if (chillSettings.data.options.get('camZoom') == null)
			set('camZoom', true);
		if (chillSettings.data.options.get('ghostTapping') == null)
			set('ghostTapping', true);
		if (chillSettings.data.options.get('hudType') == null)
			set('hudType', 'Simple');
		if (chillSettings.data.options.get('downScroll') == null)
			set('downScroll', false);
		if (chillSettings.data.options.get('middleScroll') == null)
			set('middleScroll', false);
		if (chillSettings.data.options.get('noteSplashes') == null)
			set('noteSplashes', true);
		if (chillSettings.data.options.get('cutscenes') == null)
			set('cutscenes', true);

		// Flixel Settings
		if (chillSettings.data.options.get('autoPause') == null)
			set('autoPause', false);
		#if FLX_MOUSE
		if (chillSettings.data.options.get('systemCursor') == null)
			set('systemCursor', true);
		#end

		// Other Settings
		#if DISCORD
		if (chillSettings.data.options.get('discordRPC') == null)
			set('discordRPC', true);
		#end
		#if MOD_SUPPORT
		if (chillSettings.data.options.get('safeMode') == null)
			set('safeMode', false);
		#end

		if (chillSettings.data.options.get('devMode') == null)
			set('devMode', false);
	}
}

package funkin.data;

import flixel.util.FlxSave;

/**
 * A class that handles the options in game.
 *
 * To get an option value simply just
 * ```haxe
 * FunkinOptions.get('optionName');
 */
class FunkinOptions
{
	public static var settings:Map<String, Dynamic> = new Map();

	public static var settingsSave:FlxSave = new FlxSave();

	public static function get(option:String):Dynamic
	{
		return settings.get(option);
	}

	public static function set(option:String, value:Dynamic):Void
	{
		settings.set(option, value);
		trace('Set Option ${option} to ${value}!');
	}

	public static function loadSettings():Void
	{
		settingsSave.bind('settings', CoolTools.getSavePath());

		settings = settingsSave.data.settings;

		setDefault();

		FlxG.updateFramerate = get('fps');
		FlxG.drawFramerate = get('fps');

		if (Main.fpsCounter != null)
			Main.fpsCounter.visible = get('fpsCounter');

		FlxG.fullscreen = get('fullscreen');

		FlxSprite.defaultAntialiasing = get('antialiasing');

		FlxG.autoPause = get('autoPause');

		#if FLX_MOUSE
		FlxG.mouse.useSystemCursor = get('systemCursor');
		#end

		// I know I might be adding audio things but if even if I dont minus well
		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;
	}

	static function setDefault():Void
	{
		if (settings == null)
			settings = new Map<String, Dynamic>();

		if (settingsSave.data.settings == null)
			settingsSave.data.settings = new Map<String, Dynamic>();

		if (settingsSave.data.settings.get('fps') == null)
			set('fps', 60);

		if (settingsSave.data.settings.get('fpsCounter') == null)
			set('fpsCounter', true);

		if (settingsSave.data.settings.get('fullscreen') == null)
			set('fullscreen', false);

		if (settingsSave.data.settings.get('antialiasing') == null)
			set('antialiasing', true);

		if (settingsSave.data.settings.get('flashingLights') == null)
			set('flashingLights', true);

		if (settingsSave.data.settings.get('camZoom') == null)
			set('camZoom', true);

		if (settingsSave.data.settings.get('ghostTapping') == null)
			set('ghostTapping', true);

		if (settingsSave.data.settings.get('hudType') == null)
			set('hudType', 'Simple');

		if (settingsSave.data.settings.get('downScroll') == null)
			set('downScroll', false);

		if (settingsSave.data.settings.get('middleScroll') == null)
			set('middleScroll', false);

		if (settingsSave.data.settings.get('noteSplashes') == null)
			set('noteSplashes', true);

		if (settingsSave.data.settings.get('cutscenes') == null)
			set('cutscenes', true);

		if (settingsSave.data.settings.get('autoPause') == null)
			set('autoPause', false);

		#if FLX_MOUSE
		if (settingsSave.data.settings.get('systemCursor') == null)
			set('systemCursor', true);
		#end

		#if FUNKIN_DISCORD_RPC
		if (settingsSave.data.settings.get('discordRPC') == null)
			set('discordRPC', true);
		#end

		#if FUNKIN_MOD_SUPPORT
		if (settingsSave.data.settings.get('safeMode') == null)
			set('safeMode', false);
		#end

		if (settingsSave.data.settings.get('devMode') == null)
			set('devMode', false);
	}
}

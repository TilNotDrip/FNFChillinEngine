package data;

import flixel.util.FlxSave;

class ChillSettings
{
	public static var optionsSave:FlxSave = new FlxSave();

	static var options:Map<String, Dynamic> = new Map();

	public static function get(option:String):Dynamic
	{
		return options.get(option);
	}

	public static function set(option:String, value:Dynamic):Void
	{
		options.set(option, value);
		optionsSave.data.options = options;

		trace('Set Option ${option} to ${value}!');
	}

	public static function loadSettings():Void
	{
		optionsSave.bind('settings', CoolUtil.getSavePath());

		options = optionsSave.data.options;

		setDefaults();

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

	private static function setDefaults():Void
	{
		if (options == null)
			options = new Map<String, Dynamic>();

		if (optionsSave.data.options == null)
			optionsSave.data.options = new Map<String, Dynamic>();

		// Display Settings
		if (optionsSave.data.options.get('fps') == null)
			set('fps', 60);
		if (optionsSave.data.options.get('fpsCounter') == null)
			set('fpsCounter', true);
		if (optionsSave.data.options.get('fullscreen') == null)
			set('fullscreen', false);
		if (optionsSave.data.options.get('antialiasing') == null)
			set('antialiasing', true);
		if (optionsSave.data.options.get('flashingLights') == null)
			set('flashingLights', true);

		// Gameplay Settings
		if (optionsSave.data.options.get('camZoom') == null)
			set('camZoom', true);
		if (optionsSave.data.options.get('ghostTapping') == null)
			set('ghostTapping', true);
		if (optionsSave.data.options.get('hudType') == null)
			set('hudType', 'Simple');
		if (optionsSave.data.options.get('downScroll') == null)
			set('downScroll', false);
		if (optionsSave.data.options.get('middleScroll') == null)
			set('middleScroll', false);
		if (optionsSave.data.options.get('noteSplashes') == null)
			set('noteSplashes', true);
		if (optionsSave.data.options.get('cutscenes') == null)
			set('cutscenes', true);

		// Flixel Settings
		if (optionsSave.data.options.get('autoPause') == null)
			set('autoPause', false);
		#if FLX_MOUSE
		if (optionsSave.data.options.get('systemCursor') == null)
			set('systemCursor', true);
		#end

		// Other Settings
		#if FUNKIN_DISCORD_RPC
		if (optionsSave.data.options.get('discordRPC') == null)
			set('discordRPC', true);
		#end
		#if FUNKIN_MOD_SUPPORT
		if (optionsSave.data.options.get('safeMode') == null)
			set('safeMode', false);
		#end

		if (optionsSave.data.options.get('devMode') == null)
			set('devMode', false);
	}
}

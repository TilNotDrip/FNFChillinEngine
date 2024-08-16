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
	public static var options:Map<String, Dynamic> = new Map();

	public static var optionsSave:FlxSave = new FlxSave();

	/**
	 * Initializes and loads Friday Night Funkin' Options.
	 */
	public static function initialize():Void
	{
		optionsSave.bind('options', CoolUtil.getSavePath());

		options = optionsSave.data.options;

		setDefaultOptions(false);

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

	public static function get(option:String):Dynamic
	{
		return options.get(option);
	}

	public static function set(option:String, value:Dynamic):Void
	{
		options.set(option, value);
	}

	/**
	 * Sets the default options.
	 * @param forced Force a reset or just check for null options?
	 */
	public static function setDefaultOptions(forced:Bool = false):Void
	{
		if (options == null)
			options = new Map<String, Dynamic>();

		if (optionsSave.data.options == null)
			optionsSave.data.options = new Map<String, Dynamic>();

		setDefaultVariable('fps', Std.int(FlxMath.bound(FlxG.stage.application.window.displayMode.refreshRate, 30, 360)), forced);
		setDefaultVariable('fpsCounter', true, forced);
		setDefaultVariable('fullscreen', false, forced);
		setDefaultVariable('antialiasing', true, forced);
		setDefaultVariable('flashingLights', true, forced);
		setDefaultVariable('camZoom', true, forced);
		setDefaultVariable('ghostTapping', true, forced);
		setDefaultVariable('hudType', 'Simple', forced);
		setDefaultVariable('downScroll', false, forced);
		setDefaultVariable('middleScroll', false, forced);
		setDefaultVariable('noteSplashes', true, forced);
		setDefaultVariable('cutscenes', true, forced);
		setDefaultVariable('autoPause', false, forced);

		#if FLX_MOUSE
		setDefaultVariable('systemCursor', true, forced);
		#end

		#if FUNKIN_DISCORD_RPC
		setDefaultVariable('discordRPC', true, forced);
		#end

		#if FUNKIN_MOD_SUPPORT
		setDefaultVariable('safeMode', false, forced);
		#end

		setDefaultVariable('devMode', false, forced);
	}

	static function setDefaultVariable(variable:String, value:Dynamic, forced:Bool = false):Void
	{
		if (optionsSave.data.options.get(variable) == null || forced)
			set(variable, value);
	}
}

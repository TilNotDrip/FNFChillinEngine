package funkin.options.substates.options;

import funkin.options.objects.Option;

class Flixel extends BaseSubState
{
	override public function create()
	{
		#if FUNKIN_DISCORD_RPC
		DiscordRPC.state = 'Flixel';
		#end

		var autoPause:Option = new Option('Auto Pause', 'Whether to freeze the game is unfocused.', 'autoPause', FLIXEL, CHECKBOX);
		autoPause.onChange = autopausing;
		addOption(autoPause);

		#if FLX_MOUSE
		var systemCursor:Option = new Option('System Cursor', 'Whether to use your systems default cursor or not.', 'systemCursor', FLIXEL, CHECKBOX);
		systemCursor.onChange = changeCursor;
		addOption(systemCursor);
		#end

		super.create();
	}

	function autopausing()
		FlxG.autoPause = ChillSettings.get('autoPause', FLIXEL);

	#if FLX_MOUSE
	function changeCursor()
		FlxG.mouse.useSystemCursor = ChillSettings.get('systemCursor', FLIXEL);
	#end
}

package options.substates.options;

import display.FPS;
import openfl.Lib;
import options.objects.Option;

class Flixel extends BaseSubState
{
	override public function create()
	{
		#if FUNKIN_DISCORD_RPC
		DiscordRPC.state = 'Flixel';
		#end

		var autoPause:Option = new Option('Auto Pause', 'Whether to freeze the game is unfocused.', 'autoPause', CHECKBOX);
		autoPause.onChange = autopausing;
		addOption(autoPause);

		#if FLX_MOUSE
		var systemCursor:Option = new Option('System Cursor', 'Whether to use your systems default cursor or not.', 'systemCursor', CHECKBOX);
		systemCursor.onChange = changeCursor;
		addOption(systemCursor);
		#end

		super.create();
	}

	private function autopausing()
		FlxG.autoPause = ChillSettings.get('autoPause');

	#if FLX_MOUSE
	private function changeCursor()
		FlxG.mouse.useSystemCursor = ChillSettings.get('systemCursor');
	#end
}

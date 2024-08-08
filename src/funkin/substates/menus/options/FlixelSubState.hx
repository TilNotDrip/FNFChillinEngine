package funkin.substates.menus.options;

class FlixelSubState extends BaseOptionsSubState
{
	override public function create():Void
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

	function autopausing():Void
		FlxG.autoPause = FunkinOptions.get('autoPause');

	#if FLX_MOUSE
	function changeCursor():Void
		FlxG.mouse.useSystemCursor = FunkinOptions.get('systemCursor');
	#end
}

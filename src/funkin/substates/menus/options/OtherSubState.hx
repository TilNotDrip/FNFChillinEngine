package funkin.substates.menus.options;

class OtherSubState extends BaseOptionsSubState
{
	override public function create():Void
	{
		#if FUNKIN_DISCORD_RPC
		DiscordRPC.state = 'Other';
		#end

		#if FUNKIN_DISCORD_RPC
		var discordRPC:Option = new Option('Discord Rich Presence', 'Displays this game on your Discord Profile.', 'discordRPC', CHECKBOX);
		discordRPC.onChange = discordRPCChange;
		addOption(discordRPC);
		#end

		#if FUNKIN_MOD_SUPPORT
		var safeMode:Option = new Option('Safe Mode', 'Prevents mods from doing harmful stuff to your computer.', 'safeMode', CHECKBOX);
		addOption(safeMode);
		#end

		var devMode:Option = new Option('Developer Mode', 'Let\'s you access developer tools like Charting Menu.', 'devMode', CHECKBOX);
		addOption(devMode);

		super.create();
	}

	#if FUNKIN_DISCORD_RPC
	function discordRPCChange():Void
	{
		if (FunkinOptions.get('discordRPC'))
			DiscordRPC.initialize();
		else
			DiscordRPC.shutdown();
	}
	#end
}
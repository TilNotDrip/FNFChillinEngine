package funkin.options.substates.options;

import funkin.options.objects.Option;

class Other extends BaseSubState
{
	override public function create()
	{
		#if FUNKIN_DISCORD_RPC
		DiscordRPC.state = 'Other';
		#end

		#if FUNKIN_DISCORD_RPC
		var discordRPC:Option = new Option('Discord Rich Presence', 'Displays this game on your Discord Profile.', 'discordRPC', OTHER, CHECKBOX);
		discordRPC.onChange = discordRPCChange;
		addOption(discordRPC);
		#end

		#if FUNKIN_MOD_SUPPORT
		var safeMode:Option = new Option('Safe Mode', 'Prevents mods from doing harmful stuff to your computer.', 'safeMode', OTHER, CHECKBOX);
		addOption(safeMode);
		#end

		var devMode:Option = new Option('Developer Mode', 'Let\'s you access developer tools like Charting Menu.', 'devMode', OTHER, CHECKBOX);
		addOption(devMode);

		super.create();
	}

	#if FUNKIN_DISCORD_RPC
	function discordRPCChange()
	{
		if (ChillSettings.get('discordRPC', OTHER))
			DiscordRPC.initialize();
		else
			DiscordRPC.shutdown();
	}
	#end
}

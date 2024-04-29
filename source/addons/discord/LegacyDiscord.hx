package addons.discord;

#if DISCORD
import discord_rpc.DiscordRpc;

import Sys.sleep;
#end

class LegacyDiscord
{
	public function new()
	{
        #if DISCORD
		trace("Discord RPC starting...");
		DiscordRpc.start({
			clientID: "1209233449928360036",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord RPC started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(0);
		}

		DiscordRpc.shutdown();
        #end
	}

    #if DISCORD
	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord RPC initialized");
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
	{
		if (!ChillSettings.get('discordRPC', OTHER))
			return;

		var startTimestamp:Float = if (hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: "Friday Night Funkin'; Chillin' Engine",
			smallImageKey: smallImageKey,
			startTimestamp: Std.int(startTimestamp / 1000),
			endTimestamp: Std.int(endTimestamp / 1000)
		});
	}

	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}

	private static function onReady()
	{
		DiscordRpc.presence({
			details: "In the Menus",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "Friday Night Funkin'; Chillin' Engine"
		});
	}

	private static function onError(_code:Int, _message:String)
	{
		trace('Discord RPC Error! $_code : $_message');
	}

	private static function onDisconnected(_code:Int, _message:String)
	{
		trace('Discord RPC Disconnected! $_code : $_message');
	}
    #end
}
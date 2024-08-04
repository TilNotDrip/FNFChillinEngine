#if FUNKIN_DISCORD_RPC
package api;

import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

class DiscordRPC
{
	private static final clientID:String = '1209233449928360036';
	private static var presence:DiscordRichPresence = DiscordRichPresence.create();

	// Activity
	public static var state(default, set):String;
	public static var details(default, set):String;

	// Time
	public static var startTimestamp(default, set):Float;
	public static var endTimestamp(default, set):Float;

	// Images
	public static var largeImageKey(default, set):String;
	public static var largeImageText(default, set):String;

	public static var smallImageKey(default, set):String;
	public static var smallImageText(default, set):String;

	// Parties
	public static var partyId(default, set):String;
	public static var partySize(default, set):Int;
	public static var partyMax(default, set):Int;
	public static var partyPrivacy(default, set):Int;

	public static var matchSecret(default, set):String;
	public static var joinSecret(default, set):String;
	public static var spectateSecret(default, set):String;

	public static function initialize()
	{
		if (!ChillSettings.get('discordRPC'))
			return;

		var handlers:DiscordEventHandlers = DiscordEventHandlers.create();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize(clientID, cpp.RawPointer.addressOf(handlers), 1, null);

		sys.thread.Thread.create(function():Void
		{
			while (true)
			{
				#if DISCORD_DISABLE_IO_THREAD
				Discord.UpdateConnection();
				#end
				Discord.RunCallbacks();

				Sys.sleep(2);
			}
		});
	}

	public static function shutdown()
	{
		Discord.Shutdown();
	}

	public static function clearValues()
	{
		if (!ChillSettings.get('discordRPC'))
			return;

		state = null;
		details = null;

		startTimestamp = 0;
		endTimestamp = 0;

		largeImageKey = null;
		largeImageText = null;

		smallImageKey = null;
		smallImageText = null;

		/*partyId = null;
			partySize = 0;
			partyMax = 0;
			partyPrivacy = 0; */

		matchSecret = null;
		joinSecret = null;
		spectateSecret = null;
	}

	public static function updatePresence()
	{
		if (ChillSettings.get('discordRPC'))
			Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence));
	}

	// Handlers
	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var userName:String = cast(request[0].username, String);
		var userDiscrim:String = '';

		if (Std.parseInt(cast(request[0].discriminator, String)) != 0)
			userDiscrim += '#${cast (request[0].discriminator, String)}';

		updatePresence();

		trace('Discord RPC Successfully connected! ($userName$userDiscrim)');
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		trace('Discord RPC Disconnected! ($errorCode: ${cast (message, String)})');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		trace('Discord RPC Error! ($errorCode: ${cast (message, String)})');
	}

	// Setting Discord RPC Variables
	private static function set_state(value:String):String
	{
		presence.state = value;
		updatePresence();
		return value;
	}

	private static function set_details(value:String):String
	{
		presence.details = value;
		updatePresence();
		return value;
	}

	private static function set_startTimestamp(value:Float):Float
	{
		presence.startTimestamp = Std.int(value / 1000);
		updatePresence();
		return value;
	}

	private static function set_endTimestamp(value:Float):Float
	{
		presence.endTimestamp = Std.int(value / 1000);
		updatePresence();
		return value;
	}

	private static function set_largeImageKey(value:String):String
	{
		presence.largeImageKey = value;
		updatePresence();
		return value;
	}

	private static function set_largeImageText(value:String):String
	{
		presence.largeImageText = value;
		updatePresence();
		return value;
	}

	private static function set_smallImageKey(value:String):String
	{
		presence.smallImageKey = value;
		updatePresence();
		return value;
	}

	private static function set_smallImageText(value:String):String
	{
		presence.smallImageText = value;
		updatePresence();
		return value;
	}

	private static function set_partyId(value:String):String
	{
		presence.partyId = value;
		updatePresence();
		return value;
	}

	private static function set_partySize(value:Int):Int
	{
		presence.partySize = value;
		updatePresence();
		return value;
	}

	private static function set_partyMax(value:Int):Int
	{
		presence.partyMax = value;
		updatePresence();
		return value;
	}

	private static function set_partyPrivacy(value:Int):Int
	{
		presence.partyPrivacy = value;
		updatePresence();
		return value;
	}

	private static function set_matchSecret(value:String):String
	{
		presence.matchSecret = value;
		updatePresence();
		return value;
	}

	private static function set_joinSecret(value:String):String
	{
		presence.joinSecret = value;
		updatePresence();
		return value;
	}

	private static function set_spectateSecret(value:String):String
	{
		presence.spectateSecret = value;
		updatePresence();
		return value;
	}
}
#end

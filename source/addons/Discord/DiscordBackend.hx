package addons.discord;

import discordSdk.Discord;

import Sys.sleep;

class DiscordBackend
{
	public static function initialize()
	{
		Discord.initialize(Std.int(1209233449928360036));
		Discord.details = 'In the Menus';
		Discord.largeImage = 'icon';
		Discord.largeText = "Friday Night Funkin'; Chillin' Engine";

		while (true)
		{
			Discord.process();
			sleep(0.05);
		}
	}

	public static function changePresence(daDetails:String, daState:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
	{
		var startTimestamp:Float = if (hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		Discord.details = daDetails;
		Discord.state = daState;
		Discord.smallImage = smallImageKey;
		Discord.smallText = smallImageKey;
		Discord.timestampStart = Std.int(startTimestamp / 1000);
		Discord.timestampEnd = Std.int(endTimestamp / 1000);
	}
}
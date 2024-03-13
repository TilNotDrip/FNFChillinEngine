package addons.discord;

class Discord
{
	public static var details(default, set):String;
	public static var state(default, set):String;
	public static var smallImage(default, set):String;
	public static var smallText(default, set):String;
	public static var largeImage(default, set):String;
	public static var largeText(default, set):String;
	public static var activity(default, set):ActivityType;

	public static var timestampStart(default, set):Int;
	public static var timestampEnd(default, set):Int;

	public static var lobby:DiscordLobby;

	
	@:functionCode("
		DiscordState state{};
		discord::Core* core{};
		auto response = discord::Core::Create(id, DiscordCreateFlags_Default, &core);
		state.core.reset(core);
		if (!state.core) {
			return FALSE;
		}
		else {
			return TRUE;
		}
	")
	static public function initialize(id:Int, res:Bool = false)
	{
		return res;
	}

	@:functionCode("
		discord::Actvity activity{};
		activity.GetAssets().SetDetails(text.c_str());
	")
	static function set_details(text:String) 
	{
		return text;
	}

	@:functionCode("
		discord::Actvity activity{};
		activity.GetAssets().SetState(text.c_str());
	")
	static function set_state(text:String) 
	{
		return text;
	}


	@:functionCode("
		discord::Actvity activity{};
		activity.GetAssets().SetSmallImage(text.c_str());
	")
	static function set_smallImage(text:String) 
	{
		return text;
	}

	@:functionCode("
		discord::Actvity activity{};
		activity.GetAssets().SetSmallText(text.c_str());
	")
	static function set_smallText(text:String) 
	{
		return text;
	}

	@:functionCode("
		discord::Actvity activity{};
		activity.GetAssets().SetLargeImage(text.c_str());
	")
	static function set_largeImage(text:String) 
	{
		return text;
	}

	@:functionCode("
		discord::Actvity activity{};
		activity.GetAssets().SetLargeText(text.c_str());
	")
	static function set_largeText(text:String) 
	{
		return text;
	}

	@:functionCode('
		discord::Actvity activity{};

		if(type.c_str() == "playing") { 
			activity.SetType(discord::ActivityType::Playing);
		}

		if(type.c_str() == "streaming") { 
			activity.SetType(discord::ActivityType::Streaming);
		}

		if(type.c_str() == "listening") { 
			activity.SetType(discord::ActivityType::Listening);
		}

		if(type.c_str() == "watching") { 
			activity.SetType(discord::ActivityType::Watching);
		}
	') // idk how to do it any other way :sob: im sorry

	static function set_activity(type:ActivityType) 
	{
		return type;
	}

	@:functionCode("
		discord::Actvity activity{};
		activity.GetTimestamps().SetStart(stamp);
	")
	static function set_timestampStart(stamp:Int)
	{
		return stamp;
	}

	@:functionCode("
		discord::Actvity activity{};
		activity.GetTimestamps().SetEnd(stamp);
	")
	static function set_timestampEnd(stamp:Int)
	{
		return stamp;
	}

	/**
	 * please never fucking use this 
	 * lol (yea 𝓕𝓻𝓮𝓪𝓴𝔂GPT)
	 * @param speed How fast you wanna *go*?
	 * @return feel good, or not.
	 */
	public static function jerkingOff(speed:Float) //i made this with crusher for no fucking reason lol 🤑🤑🤑🤑🤑🤑🤑🤑🤑🤑(❁´◡`❁)☆*: .｡. o(≧▽≦)o .｡.:*☆(*/ω＼*)(●'◡'●)╰(*°▽°*)╯(^///^)
	{ // stop jerking off crusher 
		new FlxTimer().start(64 / speed, function(tmr:FlxTimer) { // I DONT WANT TO
			cocksexbuttasscock('kum'); // go wild 😏😼
		});
	}
	
	/**
	 * im boutta KUHJJOnjfrjhkldsahjkfhgjkldsahjkngfdjkl;gjkl;fdaslkhjgfdsjkl,'gmf'j klsd;gh'l;jkmfsdlmkj';gfk;l'sdmk'glm;fsd'kml;b'kl;vcs'k;mlhgsd'kl;mgh'klf;mds'kl;m bvfd'kml;ng'bdfklm;h'mkl;tf'km;lh'gdf
	 * @param what you are about to do
	 * @return Application is not responding.
	 */
	static function cocksexbuttasscock(what:String)
	{
		var holdon:String = '';
		for(i in 0...FlxMath.MAX_VALUE_INT) {
			holdon += what.charAt(what.length-1).toUpperCase();
		}
		trace('im bouta ' + what.toUpperCase() + holdon);
	}

}

class DiscordLobby
{
	public var capacity(default, set):Int = 4;
	public var isPrivate(default, set):Bool = false;

	function set_capacity(capacity:Int) 
	{
		return capacity;
	}

	function set_isPrivate(pprivate:Bool) 
	{
		return pprivate;
	}

	@:functionCode("
		discord::LobbyTransaction lobby{};
		state.core->LobbyManager().GetLobbyCreateTransaction(&lobby);
	")
	public function create()
	{
		trace("lobby created i guess");
	}

	
}

/**
 * Can be Playing, Streaming, Listening, or Watching
 */
enum abstract ActivityType(String)
{
	var PLAYING    = 'playing';
	var STREAMING    = 'streaming';
	var LISTENING    = 'listening';
	var WATCHING    = 'watching';
}
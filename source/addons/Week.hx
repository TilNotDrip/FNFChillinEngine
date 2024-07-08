package addons;

import openfl.utils.Assets;
import haxe.Json;
import addons.Song;
import flixel.util.FlxSave;

class Week
{
	public static var weeks(get, never):Array<Week>;

	@:noCompletion
	private static function get_weeks():Array<Week>
	{
		var daWeekThing:Array<Week> = [];

		for (weekFile in CoolUtil.coolTextFile(Paths.file('weeks/weekList.txt', TEXT)))
			daWeekThing.push(new Week(Paths.file('weeks/$weekFile.json', TEXT)));

		// Test
		if (ChillSettings.get('devMode', OTHER))
		{
			var idk:Week = new Week();
			idk.name = 'Test';
			idk.songs = [
				{
					song: 'Test',
					icon: 'bf',
					difficulties: ['Normal'],
					explicit: true,
					head: idk
				}
			];
			idk.characters = ['bf', 'bf', 'gf'];
			idk.motto = '[PLACEHOLDER]';
			idk.color = 0xffffffff;
			daWeekThing.push(idk);
		}

		return daWeekThing;
	}

	/**
	 * @param name Name of the week.
	 */
	public var name:String = '';

	/**
	 * @param nameData Name of the week that will be used for saving.
	 * (Gets set as the file name of the json, or, uses formatted name)
	 */
	public var nameData(get, null):String;

	private function get_nameData():String
	{
		return if (weekJson != null) weekJson.file else name.formatToPath().replace('-', '');
	}

	/**
	 * @param characters Characters to show up on Story Menu (Leave `null` for it not to show up.)
	 */
	public var characters:Array<String>;

	/**
	 * @param color The background color for story mode. `A = Alpha | R = Red | G = Green | B = Blue` Goes by 0xAARRGGBB
	 */
	public var color:FlxColor = 0xFFF9CF51;

	/**
	 * @param motto The text that shows up on the top right in Story Menu.
	 */
	public var motto:String;

	/**
	 * @param songs Song Data for the Week. (Check `SongData` for more info)
	 */
	public var songs:Array<SongData> = [];

	/**
	 * Determines whether you have to beat the week before to be able to play this one. (Check `LockMetadata` for more info)
	 */
	public var lockMetadata:LockMetadata = null;

	private var weekJson:{file:String, json:WeekJSON} = null;

	/**
	 * Makes a new week for the game!
	 * Please make a Week using jsons instead.
	 * Example Week:
	 * ```haxe
	 * var myWeek = new Week('myWeek', ['Swear Song', 'Clean Song'], ['Difficulty 1', 'Difficulty 2']);
	 * myWeek.explicitSongs = ['Swear Song'];
	 * myWeek.characters = ['opponent', 'player', 'gf'];
	 * myWeek.color = 0xAARRGGBB;
	 * myWeek.motto = 'My Motto Here';
	 * daWeekThing.push(myWeek);
	 * ```
	 *
	 * @param name Name of the week.
	 * @param songs Songs inside the week and if its Explicit or not (e.g. [['The Cuss Song', true], ['No Swearing']
	 * @param difficulties Difficulties avaliable for the week.
	 */
	public function new(?path:String = null)
	{
		if (path != null)
		{
			var json:WeekJSON = cast Json.parse(Assets.getText(path).trim());

			weekJson = {file: path.split('/').getLastInArray().replace('.json', ''), json: json};

			name = json.name;
			motto = json.motto;
			characters = json.characters;
			color = FlxColor.fromString('#' + json.color);

			songs = [];
			for (song in json.songs)
			{
				song.head = this;
				songs.push(song);
			}

			lockMetadata = new LockMetadata(this, json.lockMetadata);
		}
		else
		{
			lockMetadata = new LockMetadata(this, {onDefault: false, unlockAfterWeek: 'week1'});
		}
	}
}

/**
 * Song Data for a Week!
 *
 * Example Song:
 * ```haxe
 * {
 *     song: 'Clean Song',
 *     icon: 'opponent',
 *     difficulties: ['Difficulty 1', 'Difficulty 2'],
 *     explicit: false,
 *     head: myWeek
 * }
 * ```
 *
 * @param song Name of the Song.
 * @param icon Name of the Icon to be used in Freeplay.
 * @param difficulties Difficulties avaliable for the song.
 * @param explicit If its Explicit or not.
 * @param head The week this song comes from, used for
 */
typedef SongData =
{
	var song:String;
	var icon:String;
	var difficulties:Array<String>;
	var explicit:Bool;
	@:optional var head:Week; // for freeplay
}

typedef WeekJSON =
{
	var name:String;
	var dataName:String;
	var motto:String;
	var characters:Array<String>;
	var color:String;
	var songs:Array<SongData>;
	var lockMetadata:{onDefault:Bool, unlockAfterWeek:String};
}

class LockMetadata
{
	var header:Week;

	public var locked(get, set):Bool;

	public var defaultt:Bool; // real
	public var unlockAfter:String;

	var lockedSave:FlxSave = new FlxSave();

	public function new(header:Week, json:Dynamic)
	{
		lockedSave.bind('locks', CoolUtil.getSavePath());

		defaultt = json.onDefault;
		unlockAfter = json.unlockAfterWeek;
		this.header = header;
	}

	private function get_locked():Bool
	{
		return /*lockedSave.data.lockedWeeks.get(header.nameData) ?? */ defaultt;
	}

	private function set_locked(value:Bool)
	{
		/*lockedSave.data.lockedWeeks.set(header.nameData, value);
			lockedSave.flush(); */

		return value;
	}
}

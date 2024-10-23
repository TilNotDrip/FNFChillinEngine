package funkin.util;

class Constants
{
	/**
	 * GAMEPLAY
	 */
	// ==============================

	/**
	 * The lowest amount of health a player can have.
	 */
	public static final HEALTH_MIN:Float = 0;

	/**
	 * The highest amount of health a player can have.
	 */
	public static final HEALTH_MAX:Float = 2;

	/**
	 * The amount of health a player starts with.
	 */
	public static final HEALTH_STARTING:Float = 1;

	/**
	 * FILE EXTENSIONS
	 */
	// ==============================

	/**
	 * The file extension used when exporting chart files.
	 *
	 * - "I made a new file format"
	 * - "Actually new or just a renamed ZIP?"
	 */
	public static final EXT_CHART:String = "fnfc";

	/**
	 * The file extension used when loading data files.
	 */
	public static final EXT_DATA:String = "json";

	/**
	 * The file extension used when loading image files.
	 */
	public static final EXT_IMAGE:String = "png";

	public static final EXT_SCRIPT:String = "hx";

	/**
	 * The file extension used when loading audio files.
	 */
	public static final EXT_SOUND:String = #if web "mp3" #else "ogg" #end;

	/**
	 * The file extension used when loading video files.
	 */
	public static final EXT_VIDEO:String = "mp4";

	#if FUNKIN_MOD_SUPPORT
	/**
	 * MODDING
	 */
	// ==============================

	/**
	 * The folder that mods get loaded from.
	 */
	public static final MODS_FOLDER:String = 'mods';
	#end

	/**
	 * VERSIONS
	 */
	// ==============================

	/**
	 * The current character version that Chillin' Engine is on right now.
	 */
	public static final VERSION_CHARACTER:String = "0.1.0";

	/**
	 * The version rule of characters that Chillin' Engine support right now.
	 */
	public static final VERSION_CHARACTER_RULE:String = "0.1.x";

	/**
	 * The current chart version that Chillin' Engine is on right now.
	 */
	public static final VERSION_CHART:String = "0.1.0";

	/**
	 * The version rule of charts that Chillin' Engine support right now.
	 */
	public static final VERSION_CHART_RULE:String = "0.1.x";

	/**
	 * The current song metadata version that Chillin' Engine is on right now.
	 */
	public static final VERSION_SONG_METADATA:String = "0.1.0";

	/**
	 * The version rule of song metadatas that Chillin' Engine support right now.
	 */
	public static final VERSION_SONG_METADATA_RULE:String = "0.1.x";

	/**
	 * The current song events version that Chillin' Engine is on right now.
	 */
	public static final VERSION_SONG_EVENTS:String = "0.1.0";

	/**
	 * The version rule of song events that Chillin' Engine support right now.
	 */
	public static final VERSION_SONG_EVENTS_RULE:String = "0.1.x";

	#if FUNKIN_MOD_SUPPORT
	/**
	 * The current mod version that Chillin' Engine is on right now.
	 */
	public static final VERSION_MOD:String = "0.1.0";

	/**
	 * The version rule of mods that Chillin' Engine support right now.
	 */
	public static final VERSION_MOD_RULE:String = "0.1.x";
	#end

	/**
	 * The current stage version that Chillin' Engine is on right now.
	 */
	public static final VERSION_STAGE:String = "0.1.0";

	/**
	 * The version rule of stages that Chillin' Engine support right now.
	 */
	public static final VERSION_STAGE_RULE:String = "0.1.x";

	/**
	 * GAME DEFAULTS
	 */
	// ==============================

	/**
	 * Default difficulty for charts.
	 */
	public static final DEFAULT_DIFFICULTY:String = 'normal';

	/**
	 * Default list of difficulties for charts.
	 */
	public static final DEFAULT_DIFFICULTY_LIST:Array<String> = ['easy', 'normal', 'hard'];

	/**
	 * List of all difficulties used by the base game.
	 * Includes Erect and Nightmare.
	 */
	public static final DEFAULT_DIFFICULTY_LIST_FULL:Array<String> = ['easy', 'normal', 'hard', 'erect', 'nightmare'];

	/**
	 * Default player character for charts.
	 */
	public static final DEFAULT_CHARACTER:String = 'bf';

	/**
	 * Default player character for health icons.
	 */
	public static final DEFAULT_HEALTH_ICON:String = 'face';

	/**
	 * Default stage for charts.
	 */
	public static final DEFAULT_STAGE:String = 'mainStage';

	/**
	 * Default song for if the PlayState messes up.
	 */
	public static final DEFAULT_SONG:String = 'test';

	/**
	 * Default variation for charts.
	 */
	public static final DEFAULT_VARIATION:String = 'default';
}

package utils;

class Constants
{
	/**
	 * MODDING DATA
	 */
	// ==============================

	/**
	 * The current version of the Chillin Engine API.
	 */
	public static final API_VERSION:String = '0.1.0';

	/**
	 * LOCATION DATA
	 */
	// ==============================

	/**
	 * The folder where mods should be loaded from.
	 */
	public static final MODS_FOLDER:String = 'mods';

	/**
	 * The folder where game assets should be loaded from.
	 */
	public static final ASSETS_FOLDER:String = 'assets';

	/**
	 * URL DATA
	 */
	// ==============================

	/**
	 * The owner of the engine / mod GitHub. (For the URL)
	 */
	public static final GITHUB_REPO_AUTHOR:String = 'TilNotDrip';

	/**
	 * The engine / mod GitHub name. (For the URL)
	 */
	public static final GITHUB_REPO_NAME:String = 'FNFChillinEngine';

	/**
	 * Link to buy merch for the game.
	 */
	public static final URL_MERCH:String = 'https://needlejuicerecords.com/pages/friday-night-funkin';

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
	public static final EXT_CHART = "fnfc";

	/**
	 * The file extension used when loading data files.
	 */
	public static final EXT_DATA = "json";

	/**
	 * The file extension used when loading image files.
	 */
	public static final EXT_IMAGE = "png";

	/**
	 * The file extension used when loading scripts.
	 */
	public static final EXT_SCRIPT = "hx";

	/**
	 * The file extension used when loading audio files.
	 */
	public static final EXT_SOUND = #if web "mp3" #else "ogg" #end;

	/**
	 * The file extension used when loading video files.
	 */
	public static final EXT_VIDEO = "mp4";
}

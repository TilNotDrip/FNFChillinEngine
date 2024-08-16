package funkin.util.paths;

import openfl.utils.Assets;
import openfl.utils.AssetType;

/**
 * A Path class for returning strings of locations.
 */
class PathLocation
{
	public var currentLevel:String = null;

	public function new() {}

	/**
	 * Returns the string of a atlas location.
	 * @param key Atlas Folder name.
	 * @param library Library the atlas is in.
	 * @return library:assets/library/images/key
	 */
	public function atlas(key:String, ?library):String
	{
		return get('images/$key', library, null);
	}

	/**
	 * Returns the string of a font location. (MUST BE LOCATED IN PRELOAD PATH!)
	 * @param key Font File name. (INCLUDE THE EXT TOO!)
	 * @return default:assets/fonts/key
	 */
	public function font(key:String):String
	{
		return get('fonts/$key', 'preload', FONT);
	}

	/**
	 * Returns the string of a image location.
	 * @param key Image File name.
	 * @param library Library the image is in.
	 * @return library:assets/library/images/key.png
	 */
	public function image(key:String, ?library):String
	{
		return get('images/$key.${Constants.EXT_IMAGE}', library, IMAGE);
	}

	/**
	 * Returns the string of a instrumental location.
	 * @param songKey The song that the instrumental file is in.
	 * @return songs:assets/songs/songKey/Inst.ogg|.mp3
	 */
	public function inst(songKey:String):String
	{
		return get('${songKey.formatToPath()}/Inst.${Constants.EXT_SOUND}', 'songs', MUSIC);
	}

	/**
	 * Returns the string of a JSON location.
	 * @param key Json File name.
	 * @param library Library the json is in.
	 * @return library:assets/library/key.json
	 */
	public function json(key:String, ?library):String
	{
		return get('$key.json', library, TEXT);
	}

	/**
	 * Returns the string of a music location.
	 * @param key Music File name.
	 * @param library Library the music is in.
	 * @return library:assets/library/music/key.ogg|.mp3
	 */
	public function music(key:String, ?library):String
	{
		return get('music/$key.${Constants.EXT_SOUND}', library, MUSIC);
	}

	/**
	 * Returns the string of a sound location.
	 * @param key Sound File name.
	 * @param library Library the sound is in.
	 * @return library:assets/library/sounds/key.ogg|.mp3
	 */
	public function sound(key:String, ?library):String
	{
		return get('sounds/$key.${Constants.EXT_SOUND}', library, SOUND);
	}

	/**
	 * Returns the string of a TXT location.
	 * @param key Txt File name.
	 * @param library Library the txt is in.
	 * @return library:assets/library/key.txt
	 */
	public function txt(key:String, ?library):String
	{
		return get('$key.txt', library, TEXT);
	}

	/**
	 * Returns the string of a video location. (MUST BE LOCATED IN VIDEOS PATH!)
	 * @param key Video File name.
	 * @param library Library the video is in.
	 * @return library:assets/library/videos/key.mp4
	 */
	public function video(key:String):String
	{
		return get('$key.${Constants.EXT_VIDEO}', 'videos', BINARY);
	}

	/**
	 * Returns the string of a voices location.
	 * @param songKey The song that the voices file is in.
	 * @param suffix The voices file suffix (like -Opponent or -dad)
	 * @return songs:assets/songs/songKey/Voices?-suffix.ogg|.mp3
	 */
	public function voices(songKey:String, ?suffix:String = ''):String
	{
		return get('${songKey.formatToPath()}/Voices${(suffix != '') ? '-$suffix' : ''}.${Constants.EXT_SOUND}', 'songs', MUSIC);
	}

	/**
	 * Returns the string of a xml location.
	 * @param key Xml File name.
	 * @param library Library the xml is in.
	 * @return library:assets/library/key.xml
	 */
	public function xml(key:String, ?library):String
	{
		return get('$key.xml', library, TEXT);
	}

	/**
	 * Returns a string of a location.
	 * @param key File to get.
	 * @param library Library the file is in.
	 * @param type The OpenFL asset type.
	 * @return library:assets/library/key
	 */
	public function get(key:String, ?library:String, ?type:AssetType = null):String
	{
		if (library != null) // Forced library return.
			return getLibraryPath(key, library);

		if (currentLevel != null)
		{
			var levelPath:String = getLibraryPath(key, currentLevel);
			if (exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPath(key, 'shared');
			if (exists(levelPath, type))
				return levelPath;
		}

		return getLibraryPath(key, 'preload');
	}

	/**
	 * Returns whether the file exists.
	 * @param key File to check.
	 * @param library Library the file is in.
	 * @param type The OpenFL asset type.
	 * @return File existence.
	 */
	public function exists(key:String, ?type:AssetType = null):Bool
	{
		// I hate my life
		if (Assets.exists(key, type))
			return true;

		return false;
	}

	function getLibraryPath(key:String, ?library:String):String
	{
		if (library == 'preload' || library == 'default')
			return '${returnLibrary(library)}:assets/$key';

		return '${returnLibrary(library)}:assets/$library/$key';
	}

	function returnLibrary(library:String):String
	{
		if (library == 'preload')
			return 'default';

		return library;
	}
}

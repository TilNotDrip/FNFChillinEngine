package funkin.util.paths;

import funkin.modding.FunkinModLoader;
import openfl.utils.Assets;
import openfl.utils.AssetType;
#if FUNKIN_MOD_SUPPORT
import sys.FileSystem;
#end

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
	 * @param checkMods Allow mod atlases to be returned?
	 * @return library:assets/library/images/key
	 */
	public function atlas(key:String, ?library, ?checkMods:Bool = true):String
	{
		return get('images/$key', library, null, checkMods);
	}

	/**
	 * Returns the string of a font location. (MUST BE LOCATED IN PRELOAD PATH!)
	 * @param key Font File name. (INCLUDE THE EXT TOO!)
	 * @param checkMods Allow mod fonts to be returned?
	 * @return default:assets/fonts/key
	 */
	public function font(key:String, ?checkMods:Bool = true):String
	{
		return get('fonts/$key', 'preload', FONT, checkMods);
	}

	/**
	 * Returns the string of a image location.
	 * @param key Image File name.
	 * @param library Library the image is in.
	 * @param checkMods Allow mod images to be returned?
	 * @return library:assets/library/images/key.png
	 */
	public function image(key:String, ?library, ?checkMods:Bool = true):String
	{
		return get('images/$key.${Constants.EXT_IMAGE}', library, IMAGE, checkMods);
	}

	/**
	 * Returns the string of a instrumental location.
	 * @param songKey The song that the instrumental file is in.
	 * @param checkMods Allow mod instrumentals to be returned?
	 * @return songs:assets/songs/songKey/Inst.ogg|.mp3
	 */
	public function inst(songKey:String, ?checkMods:Bool = true):String
	{
		return get('${songKey.formatToPath()}/Inst.${Constants.EXT_SOUND}', 'songs', MUSIC, checkMods);
	}

	/**
	 * Returns the string of a JSON location.
	 * @param key Json File name.
	 * @param library Library the json is in.
	 * @param checkMods Allow mod jsons to be returned?
	 * @return library:assets/library/key.json
	 */
	public function json(key:String, ?library, ?checkMods:Bool = true):String
	{
		return get('$key.json', library, TEXT, checkMods);
	}

	/**
	 * Returns the string of a music location.
	 * @param key Music File name.
	 * @param library Library the music is in.
	 * @param checkMods Allow mod music to be returned?
	 * @return library:assets/library/music/key.ogg|.mp3
	 */
	public function music(key:String, ?library, ?checkMods:Bool = true):String
	{
		return get('music/$key.${Constants.EXT_SOUND}', library, MUSIC, checkMods);
	}

	/**
	 * Returns the string of a sound location.
	 * @param key Sound File name.
	 * @param library Library the sound is in.
	 * @param checkMods Allow mod sounds to be returned?
	 * @return library:assets/library/sounds/key.ogg|.mp3
	 */
	public function sound(key:String, ?library, ?checkMods:Bool = true):String
	{
		return get('sounds/$key.${Constants.EXT_SOUND}', library, SOUND, checkMods);
	}

	/**
	 * Returns the string of a TXT location.
	 * @param key Txt File name.
	 * @param library Library the txt is in.
	 * @param checkMods Allow mod txts to be returned?
	 * @return library:assets/library/key.txt
	 */
	public function txt(key:String, ?library, ?checkMods:Bool = true):String
	{
		return get('$key.txt', library, TEXT, checkMods);
	}

	/**
	 * Returns the string of a video location. (MUST BE LOCATED IN VIDEOS PATH!)
	 * @param key Video File name.
	 * @param library Library the video is in.
	 * @param checkMods Allow mod videos to be returned?
	 * @return library:assets/library/videos/key.mp4
	 */
	public function video(key:String, ?checkMods:Bool = true):String
	{
		return get('$key.${Constants.EXT_VIDEO}', 'videos', BINARY, checkMods);
	}

	/**
	 * Returns the string of a voices location.
	 * @param songKey The song that the voices file is in.
	 * @param suffix The voices file suffix (like -Opponent or -dad)
	 * @param checkMods Allow mod voices to be returned?
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
	 * @param checkMods Allow mod xmls to be returned?
	 * @return library:assets/library/key.xml
	 */
	public function xml(key:String, ?library, ?checkMods:Bool = true):String
	{
		return get('$key.xml', library, TEXT, checkMods);
	}

	/**
	 * Returns a string of a location.
	 * @param key File to get.
	 * @param library Library the file is in.
	 * @param type The OpenFL asset type.
	 * @param checkMods Allow mod files to be returned?
	 * @return library:assets/library/key
	 */
	public function get(key:String, ?library:String, ?type:AssetType = null, ?checkMods:Bool = true):String
	{
		if (library != null) // Forced library return.
			return getLibraryPath(key, library, checkMods);

		if (currentLevel != null)
		{
			var levelPath:String = getLibraryPath(key, currentLevel, checkMods);
			if (exists(levelPath, type, checkMods))
				return levelPath;

			levelPath = getLibraryPath(key, 'shared', checkMods);
			if (exists(levelPath, type, checkMods))
				return levelPath;
		}

		return getLibraryPath(key, 'preload', checkMods);
	}

	/**
	 * Returns whether the file exists.
	 * @param key File to check.
	 * @param library Library the file is in.
	 * @param type The OpenFL asset type.
	 * @param checkMods Checks to see if a mod file exists too.
	 * @return File existence.
	 */
	public function exists(key:String, ?type:AssetType = null, ?checkMods:Bool = true):Bool
	{
		#if FUNKIN_MOD_SUPPORT
		if (checkMods && key.startsWith(Constants.MODS_FOLDER + '/'))
		{
			if (FileSystem.exists(key))
				return true;
		}
		#end

		// I hate my life
		// this hurts to look at
		// it doesn't work when i put it in the return i swear ...
		if (Assets.exists(key, type))
			return true;

		return false;
	}

	/**
	 * Returns a list of files from a directory (and directories from that directory).
	 * @param key Directory to check.
	 * @param library Library the directory is in.
	 * @param checkMods Allow mods to be included in the scan?
	 * @return An array of found files in the directory.
	 */
	public function list(key:String = null, ?library:String, checkMods:Bool = true):Array<String>
	{
		var path:String = get(key, library, null, false);
		var pathMods:String = get(key, library, null, true);
		trace(path);
		var files:Array<String> = [];

		for (pathFound in Assets.list())
		{
			if (pathFound.startsWith(path))
			{
				trace(pathFound);
				files.push(pathFound);
			}
		}

		#if FUNKIN_MOD_SUPPORT
		if (checkMods && pathMods.startsWith(Constants.MODS_FOLDER + '/'))
		{
			var curDirectories:Array<String> = [pathMods];

			while (curDirectories.length > 0)
			{
				var curDirectory:String = curDirectories.shift();

				for (pathFound in FileSystem.readDirectory(curDirectory))
				{
					var fullPath:String = curDirectory + '/' + pathFound;

					if (FileSystem.isDirectory(fullPath))
					{
						trace(pathFound);
						curDirectories.push(fullPath);
					}
					else
					{
						trace(pathFound);
						files.push(fullPath);
					}
				}
			}
		}
		#end

		return files;
	}

	function getLibraryPath(key:String, ?library:String, ?checkMods:Bool = true):String
	{
		if (returnLibrary(library) == 'default')
		{
			#if FUNKIN_MOD_SUPPORT
			if (checkMods)
			{
				for (mod in FunkinModLoader.enabledMods)
				{
					if (FileSystem.exists('${Constants.MODS_FOLDER}/${mod.folder}/$key'))
						return '${Constants.MODS_FOLDER}/${mod.folder}/$key';
				}
			}
			#end

			return '${returnLibrary(library)}:assets/$key';
		}

		#if FUNKIN_MOD_SUPPORT
		if (checkMods)
		{
			for (mod in FunkinModLoader.enabledMods)
			{
				if (FileSystem.exists('${Constants.MODS_FOLDER}/${mod.folder}/$library/$key'))
					return '${Constants.MODS_FOLDER}/${mod.folder}/$library/$key';
			}
		}
		#end

		return '${returnLibrary(library)}:assets/$library/$key';
	}

	function returnLibrary(library:String):String
	{
		if (library == 'preload' || library == null)
			return 'default';

		return library;
	}
}

package utils.paths;

import openfl.Assets;
import openfl.utils.AssetType;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

class PathLocation
{
	public function new() {}

	public function atlas(key:String, ?library:String = 'preload', includeModdedFiles:Bool = true):String
	{
		return getLibraryPath('images/$key', library);
	}

	public function font(key:String, includeModdedFiles:Bool = true):String
	{
		return get('fonts/$key', 'preload', FONT, includeModdedFiles);
	}

	public function image(key:String, ?library:String, includeModdedFiles:Bool = true):String
	{
		return get('images/$key.${Constants.EXT_IMAGE}', library, IMAGE, includeModdedFiles);
	}

	public function inst(key:String, includeModdedFiles:Bool = true):String
	{
		return get('${key.formatToPath()}/Inst.${Constants.EXT_SOUND}', 'songs', MUSIC, includeModdedFiles);
	}

	public function json(key:String, ?library:String, includeModdedFiles:Bool = true):String
	{
		return get('$key.${Constants.EXT_DATA}', library, TEXT, includeModdedFiles);
	}

	public function music(key:String, ?library:String, includeModdedFiles:Bool = true):String
	{
		return get('music/$key.${Constants.EXT_SOUND}', library, MUSIC, includeModdedFiles);
	}

	public function sound(key:String, ?library:String, includeModdedFiles:Bool = true):String
	{
		return get('sounds/$key.${Constants.EXT_SOUND}', library, SOUND, includeModdedFiles);
	}

	public function txt(key:String, ?library:String, includeModdedFiles:Bool = true):String
	{
		return get('$key.txt', library, TEXT, includeModdedFiles);
	}

	public function video(key:String, includeModdedFiles:Bool = true):String
	{
		return get('$key.${Constants.EXT_VIDEO}', 'videos', BINARY, includeModdedFiles);
	}

	public function voices(key:String, suffix:String = '', includeModdedFiles:Bool = true):String
	{
		var fix:String = '';
		if (suffix != '')
			fix = '-' + suffix;

		return get('${key.formatToPath()}/Voices$fix.${Constants.EXT_SOUND}', 'songs', MUSIC, includeModdedFiles);
	}

	public function xml(key:String, ?library:String, includeModdedFiles:Bool = true):String
	{
		return get('images/$key.xml', library, TEXT, includeModdedFiles);
	}

	/**
	 * Checks to see if a file exists.
	 * @param key File name.
	 * @param library The library its located in.
	 * @param type The file type.
	 * @param includeModdedFiles Check mod files too?
	 * @return File exists.
	 */
	public function exists(key:String, ?library:Null<String>, ?type:AssetType, includeModdedFiles:Bool = true):Bool
	{
		#if FUNKIN_MOD_SUPPORT
		if (includeModdedFiles)
		{
			for (mod in ModHandler.loadedMods)
			{
				if (modExists(key, library, mod))
					return true;
			}
		}
		#end

		// Im going beserk what the fuck dude
		if (Assets.exists(get(key, library, type), type))
			return true;

		return false;
	}

	/**
	 * Returns a path.
	 * @param key Path Name.
	 * @param library The library to check.
	 * @param type Asset Type. (if required)
	 * @param includeModPaths Check mod paths as well?
	 * @return Path
	 */
	public function get(key:String, ?library:Null<String>, ?type:AssetType, includeModPaths:Bool = true):String
	{
		#if FUNKIN_MOD_SUPPORT
		if (includeModPaths)
		{
			for (mod in ModHandler.loadedMods)
			{
				if (modExists(key, library, mod))
					return getModPath(key, library, mod);
			}
		}
		#end

		if (library != null)
		{
			var levelPath = getLibraryPath(key, library);
			if (Assets.exists(levelPath, type))
				return levelPath;
		}

		var levelPath = getLibraryPathForce(key, "shared");
		if (Assets.exists(levelPath, type))
			return levelPath;

		if (Paths.currentLevel != null)
		{
			var levelPath = getLibraryPathForce(key, Paths.currentLevel);
			if (Assets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(key);
	}

	public function getLibraryPath(key:String, library = "preload"):String
	{
		return if (library == "preload" || library == "default") getPreloadPath(key); else getLibraryPathForce(key, library);
	}

	inline function getLibraryPathForce(key:String, library:String):String
	{
		return '$library:assets/$library/$key';
	}

	inline function getPreloadPath(key:String):String
	{
		return 'assets/$key';
	}

	#if FUNKIN_MOD_SUPPORT
	public function modExists(key:String, ?library:Null<String>, mod:Mod):Bool
	{
		return FileSystem.exists(getModPath(key, library, mod));
	}

	public function getModPath(key:String, library:Null<String>, mod:Mod):String
	{
		if (library != null)
		{
			var levelPath = getModLibraryPath(key, library, mod);
			if (FileSystem.exists(levelPath))
				return levelPath;
		}

		var levelPath = getModLibraryPathForce(key, "shared", mod);
		if (FileSystem.exists(levelPath))
			return levelPath;

		if (Paths.currentLevel != null)
		{
			var levelPath = getModLibraryPathForce(key, Paths.currentLevel, mod);
			if (FileSystem.exists(levelPath))
				return levelPath;
		}

		return getModPreloadPath(key, mod);
	}

	public function getModLibraryPath(key:String, library = "preload", mod:Mod):String
	{
		return (library == "preload" || library == "default") ? getModPreloadPath(key, mod) : getModLibraryPathForce(key, library, mod);
	}

	inline function getModLibraryPathForce(key:String, library:String, mod:Mod):String
	{
		return '${Constants.MODS_FOLDER}/${mod.folder}/$library/$key';
	}

	inline function getModPreloadPath(key:String, mod:Mod):String
	{
		return '${Constants.MODS_FOLDER}/${mod.folder}/$key';
	}
	#end
}

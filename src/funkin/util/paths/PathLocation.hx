package funkin.util.paths;

import openfl.utils.Assets;
import openfl.utils.AssetType;
#if FUNKIN_MOD_SUPPORT
import funkin.modding.FunkinModLoader;
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
	 * Returns the string of a audio location.
	 * @param key Audio File name.
	 * @param library Library the music is in.
	 * @param checkMods Allow mod music to be returned?
	 * @return library:assets/library/music/key.ogg|.mp3
	 */
	public function audio(key:String, ?checkMods:Bool = true):String
	{
		return get('$key.${Constants.EXT_SOUND}', checkMods);
	}

	/**
	 * Returns the string of a image location.
	 * @param key Image File name.
	 * @param library Library the image is in.
	 * @param checkMods Allow mod images to be returned?
	 * @return library:assets/library/images/key.png
	 */
	public function image(key:String, ?checkMods:Bool = true):String
	{
		return get('$key.${Constants.EXT_IMAGE}', checkMods);
	}

	public function inst(key:String, ?checkMods:Bool = true):String
	{
		return audio('gameplay/songs/${key.formatToPath()}/Inst');
	}

	/**
	 * Returns the string of a JSON location.
	 * @param key Json File name.
	 * @param library Library the json is in.
	 * @param checkMods Allow mod jsons to be returned?
	 * @return library:assets/library/key.json
	 */
	public function json(key:String, ?checkMods:Bool = true):String
	{
		return get('$key.json', checkMods);
	}

	/**
	 * Returns the string of a TXT location.
	 * @param key Txt File name.
	 * @param library Library the txt is in.
	 * @param checkMods Allow mod txts to be returned?
	 * @return library:assets/library/key.txt
	 */
	public function txt(key:String, ?checkMods:Bool = true):String
	{
		return get('$key.txt', checkMods);
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
		return get('$key.${Constants.EXT_VIDEO}', checkMods);
	}

	public function voices(key:String, suffix:String = '', ?checkMods:Bool = true):String
	{
		return audio('gameplay/songs/${key.formatToPath()}/Voices$suffix');
	}

	/**
	 * Returns the string of a xml location.
	 * @param key Xml File name.
	 * @param library Library the xml is in.
	 * @param checkMods Allow mod xmls to be returned?
	 * @return library:assets/library/key.xml
	 */
	public function xml(key:String, ?checkMods:Bool = true):String
	{
		return get('$key.xml', checkMods);
	}

	/**
	 * Returns a string of a location.
	 * @param key File to get.
	 * @param library Library the file is in.
	 * @param type The OpenFL asset type.
	 * @param checkMods Allow mod files to be returned?
	 * @return library:assets/library/key
	 */
	public function get(key:String, ?checkMods:Bool = true):String
	{
		#if FUNKIN_MOD_SUPPORT
		if (checkMods)
		{
			for (mod in FunkinModLoader.currentMods)
			{
				var modPath:String = '${Constants.MODS_FOLDER}/${mod.folder}/$key';

				if (FileSystem.exists(modPath))
					return modPath;
			}
		}
		#end

		return 'assets/$key';
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
		var assetKey:String = get(key);

		#if FUNKIN_MOD_SUPPORT
		if (checkMods && assetKey.startsWith(Constants.MODS_FOLDER + '/'))
		{
			if (FileSystem.exists(assetKey))
				return true;
		}
		#end

		// I hate my life
		// this hurts to look at
		// it doesn't work when i put it in the return i swear ...
		if (Assets.exists(assetKey, type))
			return true;

		return false;
	}

	/**
	 * Returns a path list of files in a folder, this will NOT return the assets/ and mods/ part of the asset.
	 * @param key The folder to check.
	 * @param includeSubFolders Whether to include the subfolders of that folder.
	 * @param checkMods Check the mods folder?
	 * @return An string array filled with paths in a folder.
	 */
	public function list(key:String, ?includeSubFolders:Bool = false, ?checkMods:Bool = true):Array<String>
	{
		var assetList:Array<String> = listRaw(key, checkMods);
		var returnList:Array<String> = [];

		for (asset in assetList)
		{
			returnList.push(asset.cutRawPath(false));
		}

		return returnList;
	}

	/**
	 * Returns a raw path list of files in a folder, Raw meaning it returns the assets/ and mods/ part of the asset.
	 * @param key The folder to check.
	 * @param includeSubFolders Whether to include the subfolders of that folder.
	 * @param checkMods Check the mods folder?
	 * @return An string array filled with paths in a folder.
	 */
	public function listRaw(key:String, ?includeSubFolders:Bool = false, ?checkMods:Bool = true):Array<String>
	{
		if (!key.endsWith('/'))
			key += '/';

		var assetList:Array<String> = listAll(false);
		var returnList:Array<String> = [];

		for (asset in assetList)
		{
			final path:String = 'assets/' + key;
			var returnFolder:String = null;

			if (asset.startsWith(path))
				returnFolder = path;

			if (returnFolder != null)
			{
				if (!includeSubFolders)
					returnFolder = returnFolder.split(path)[0];

				// TODO: This returns ui/ui/ui/ui/ui/ui/ because i forgot to add the actual file to the returnFolder. fix it.

				returnList.push(returnFolder);
			}
		}

		#if FUNKIN_MOD_SUPPORT
		if (checkMods)
		{
			for (mod in FunkinModLoader.currentMods)
			{
				final modPath:String = '${Constants.MODS_FOLDER}/${mod.folder}/$key';
				var curDirectories:Array<String> = [];

				for (path in FileSystem.readDirectory(modPath))
				{
					final fullPath:String = modPath + path;

					if (!FileSystem.isDirectory(fullPath))
						returnList.push(fullPath);
					else if (includeSubFolders)
						curDirectories.push(fullPath);

					if (!includeSubFolders)
						break;

					while (curDirectories.length > 0)
					{
						final directory:String = curDirectories.shift();

						for (paths2 in FileSystem.readDirectory(directory))
						{
							final fullPath2:String = directory + '/' + paths2;

							if (!FileSystem.isDirectory(fullPath2))
								returnList.push(fullPath2);
							else
								curDirectories.push(fullPath2);
						}
					}
				}
			}
		}
		#end

		return returnList;
	}

	/**
	 * Lists all files found inside of the game.
	 * @param checkMods Check the mods folder as well?
	 * @return Files found in the game.
	 */
	public function listAll(?checkMods:Bool = true):Array<String>
	{
		var returnList:Array<String> = [];

		for (asset in openfl.Assets.list())
		{
			returnList.push(asset);
		}

		#if FUNKIN_MOD_SUPPORT
		if (checkMods)
		{
			for (mod in FunkinModLoader.currentMods)
			{
				final modPath:String = '${Constants.MODS_FOLDER}/${mod.folder}';
				var curDirectories:Array<String> = [];

				for (path in FileSystem.readDirectory(modPath))
				{
					final fullPath:String = modPath + '/' + path;

					if (!FileSystem.isDirectory(fullPath))
						returnList.push(fullPath);
					else
						curDirectories.push(fullPath);

					while (curDirectories.length > 0)
					{
						final directory:String = curDirectories.shift();

						for (paths2 in FileSystem.readDirectory(directory))
						{
							final fullPath2:String = directory + '/' + paths2;

							if (!FileSystem.isDirectory(fullPath2))
								returnList.push(fullPath2);
							else
								curDirectories.push(fullPath2);
						}
					}
				}
			}
		}
		#end

		return returnList;
	}
}

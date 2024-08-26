package funkin.modding;

#if FUNKIN_MOD_SUPPORT
import funkin.structures.ModStructures;
import funkin.util.VersionUtil;
import haxe.Http;
import haxe.Json;
import json2object.JsonParser;
import sys.io.File;
import sys.FileSystem;

class FunkinModLoader
{
	/**
	 * A list of mods that the game won't load.
	 */
	public static var blockedMods:Array<String> = [];

	/**
	 * The mods that are currently loaded.
	 */
	public static var loadedMods:Array<Mod> = [];

	/**
	 * The mods that are currently used. Story Mode and Freeplay change this array.
	 */
	public static var currentMods:Array<Mod> = [];

	/**
	 * The mods that the user is currently using.
	 */
	public static var enabledMods(get, never):Array<Mod>;

	/**
	 * Loads and initializes all mods in the mods folder.
	 * @param selectFolders If defined then these are the folders that are only allowed to be added.
	 */
	public static function initializeMods(?selectFolders:Array<String>):Void
	{
		SystemUtil.makeFolder(Constants.MODS_FOLDER);
		buildBlockList();

		var loadList:Array<String> = !(selectFolders == [] || selectFolders == null) ? selectFolders : FileSystem.readDirectory(Constants.MODS_FOLDER);

		for (folder in loadList)
		{
			var modFolder:String = Constants.MODS_FOLDER + '/' + folder;

			var mod:Mod = {
				folder: folder,
				enabled: true,
				metadata: cast new JsonParser<ModMetadata>().fromJson(File.getContent(modFolder + '/metadata.' + Constants.EXT_DATA))
			};

			var canLoadMod:Bool = canLoadMod(mod);

			if (canLoadMod)
			{
				loadedMods.push(mod);
				trace('Loaded Mod!\n$mod');
			}
		}
	}

	static function buildBlockList():Void
	{
		var blockedModsHttp:Http = new Http('https://raw.githubusercontent.com/TilNotDrip/ChillinEngine-BlockedMods/main/list.txt');

		blockedModsHttp.onData = function(data:String)
		{
			var blockListSplit:Array<String> = data.trim().split(',');

			for (blockMod in blockListSplit)
			{
				blockedMods.push(blockMod);
			}
		}

		blockedModsHttp.onError = function(msg:String)
		{
			trace('[ERROR]: Unable to load the block list! I guess i\'ll trust you enough to have these loaded...');
		}

		blockedModsHttp.request();
	}

	static function canLoadMod(mod:Mod):Bool
	{
		if (blockedMods.contains(mod.folder.toLowerCase())
			|| blockedMods.contains(mod.metadata.id.toLowerCase())
			|| blockedMods.contains(mod.metadata.name.toLowerCase()))
		{
			trace('[ERROR]: Mod is blocked! Will not be loading this!\nMod information:\n$mod');
			return false;
		}

		if (!VersionUtil.validateVersion(mod.metadata.versions.api, Constants.VERSION_MOD_RULE))
		{
			trace('[ERROR]: Mod api version doesn\'t match current api version rule! Will not be loading this!\nMod information:\n$mod');
			return false;
		}

		return true;
	}

	static function get_enabledMods():Array<Mod>
	{
		return loadedMods.filter(function(mod:Mod)
		{
			return mod.enabled;
		});
	}
}
#end

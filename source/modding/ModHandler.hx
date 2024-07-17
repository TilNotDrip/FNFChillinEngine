#if FUNKIN_MOD_SUPPORT
package modding;

import haxe.Json;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class ModHandler
{
	/**
	 * A list of mods that the game won't load.
	 */
	public static var blockedMods(get, never):Array<String>;

	public static var ignorePath:Array<String> = ['data', 'images', 'fonts', 'music', 'sounds', 'videos'];

	/**
	 * A list of mods that are loaded.
	 */
	public static var loadedMods:Array<Mod> = [];

	/**
	 * Loads mods from a folder.
	 * @param selectFolders The folders to scan mods from. If this remains null then every mod in the mods folder is loaded.
	 */
	public static function initializeMods(?selectFolders:Array<String>):Void
	{
		var loadList:Array<String> = selectFolders;

		if (!FileSystem.exists(Constants.MODS_FOLDER))
			createModsFolder();

		if (loadList == null)
			loadList = FileSystem.readDirectory(Constants.MODS_FOLDER);

		for (modFolder in loadList)
		{
			var folder:String = '${Constants.MODS_FOLDER}/$modFolder';

			if (!FileSystem.exists('$folder/metadata.json'))
			{
				trace('Mod (Folder Name: $modFolder) doesn\'t have a metadata. Skipping this mod...');
				return;
			}

			var mod:Mod = {
				folder: modFolder,
				enabled: true,
				metadata: cast Json.parse(File.getContent('$folder/metadata.json'))
			}

			var blockMod:Bool = blockedMods.contains(mod.folder)
				|| blockedMods.contains(mod.metadata.id)
				|| blockedMods.contains(mod.metadata.name);

			if (blockMod)
			{
				var traceBrackets:String = '';

				if (blockedMods.contains(mod.folder))
					traceBrackets = '(Folder Name: ${mod.folder})';
				else if (blockedMods.contains(mod.metadata.id))
					traceBrackets = '(ID Name: ${mod.metadata.id})';
				else if (blockedMods.contains(mod.metadata.name))
					traceBrackets = '(Display Name: ${mod.metadata.name})';

				trace('Mod $traceBrackets is blocked! Skipping this mod...');
				return;
			}

			loadedMods.push(mod);

			trace('\n---\nLoaded Mod!\nFolder: ${loadedMods[loadedMods.length - 1].folder}\nID: ' + loadedMods[loadedMods.length - 1].metadata.id);
		}
	}

	public static function createModsFolder():Void
	{
		FileSystem.createDirectory(Constants.MODS_FOLDER);
	}

	inline static function get_blockedMods():Array<String>
	{
		return ['SNC', 'SundayNightChillin', 'Sunday Night Chillin'];
	}
}
#end

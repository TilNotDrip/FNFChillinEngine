package funkin.util;

#if FUNKIN_MOD_SUPPORT
import funkin.modding.FunkinModLoader;
#end
import lime.utils.Assets;

class CoolTools
{
	/**
	 * A formatter for putting strings into a format like path string.
	 * @param original The string to put through this formatter.
	 * @return Path varient of original.
	 */
	public static function formatToPath(original:String):String
	{
		var toDash:String = '~&\\;:<>#/ ';
		var toHide:String = '.,\'"%?![]';

		var converted:String = '';

		for (i in 0...original.length)
		{
			var letter:String = original.charAt(i).toLowerCase();

			if (toDash.indexOf(letter) != -1)
				converted += '-';
			else if (toHide.indexOf(letter) == -1)
				converted += letter;
		}

		return converted;
	}

	/**
	 * Removes the assets/ and mods/modFolder part of a string. Really useful for making some paths work together.
	 * @param path The raw path string.
	 * @return `path` without default:assets/ and mods/
	 */
	public static function cutRawPath(path:String, removeExt:Bool = true):String
	{
		var cutWords:Array<String> = ['assets/'];

		#if FUNKIN_MOD_SUPPORT
		for (mod in FunkinModLoader.currentMods)
		{
			cutWords.push('${Constants.MODS_FOLDER}/${mod.folder}/');
		}
		#end

		for (assetPath in cutWords)
		{
			if (path.startsWith(assetPath))
			{
				path = path.split(assetPath)[1];

				if (removeExt)
					path = path.split('.')[0];

				return path;
			}
		}

		return null;
	}

	/**
	 * Return a list of keys from the map (as an array, rather than an iterator).
	 * @param map The map.
	 */
	public static function keyValues<K, T>(map:Map<K, T>):Array<K>
	{
		if (map == null)
			return [];

		return [for (i in map.keys()) i];
	}
}

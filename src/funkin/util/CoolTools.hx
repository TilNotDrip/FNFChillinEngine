package funkin.util;

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

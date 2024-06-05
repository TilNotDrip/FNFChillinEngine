package addons;

import lime.utils.Assets;

class CoolTools
{
	public static function formatToPath(original:String):String
	{
		var toDash:String = '~&\\;:<>#/ ';
		var toHide:String = '.,\'"%?![]';

		var converted:String = '';

		for(i in 0...original.length)
		{
			var letter:String = original.charAt(i).toLowerCase();
			if(toDash.indexOf(letter) != -1) 
				converted += '-';
			else if(toHide.indexOf(letter) == -1)
				converted += letter;
		}

		return converted;
	}

	public static function isEqualUnordered<T>(a:Array<T>, b:Array<T>):Bool
	{
		if (a.length != b.length) 
			return false;


		for (element in a)
		{
			if (!b.contains(element)) 
				return false;
		}

		for (element in b)
		{
			if (!a.contains(element)) 
				return false;
		}

		return true;
	}

	public static function keyValues<K, T>(map:Map<K, T>):Array<K>
	{
		var daArray:Array<K> = [];

		for(value in map.keys())
			daArray.push(value);

		return daArray;
	}

	public static function getLastInArray<T>(array:Array<T>):T
	{
		return array[array.length-1];
	}

	public static function find<T>(input:Array<T>, predicate:T->Bool):Null<T>
	{
	  	for (element in input)
	  	{
			if (predicate(element)) return element;
	  	}
		return null;
	}
}
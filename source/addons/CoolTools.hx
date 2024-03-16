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
}
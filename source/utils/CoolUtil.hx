package utils;

#if sys
import sys.io.File;
#end
import lime.utils.Assets;

class CoolUtil
{
	public static function coolTextFile(path:String):Null<Array<String>>
	{
		var text:Array<String> = [];
		try
		{
			text = Assets.getText(path).trim().split('\n');
		}
		catch (e)
		{
			return null;
		}

		for (i in 0...text.length)
			text[i] = text[i].trim();

		return text;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];

		for (i in min...max)
			dumbArray.push(i);

		return dumbArray;
	}

	public static function camLerpShit(lerp:Float):Float
	{
		return lerp * (FlxG.elapsed / (1 / 60));
	}

	public static function coolLerp(a:Float, b:Float, ratio:Float):Float
	{
		return FlxMath.lerp(a, b, camLerpShit(ratio));
	}

	public static function openURL(link:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [link, "&"]);
		#else
		FlxG.openURL(link);
		#end
	}

	public static function getSavePath():String
	{
		var packageName:Array<String> = Application.current.meta.get('packageName').split('.');
		return packageName[1];
	}
}

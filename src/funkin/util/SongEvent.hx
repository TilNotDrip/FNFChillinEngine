package funkin.util;

import haxe.Json;
import lime.utils.Assets;

typedef SwagEvent =
{
	var name:String;
	var value:String;
	var strumTime:Float;
}

class SongEvent
{
	function new() {}

	public static function loadFromJson(folder:String):Array<SwagEvent>
	{
		var rawJson = null;

		try
		{
			rawJson = Assets.getText(Paths.json(folder.formatToPath() + '/events')).trim();
		}
		catch (e)
		{
			return null;
		}

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):Array<SwagEvent>
	{
		var swagShit:Array<SwagEvent> = cast Json.parse(rawJson).events;
		return swagShit;
	}

	public static var events:Array<Array<String>> = [
		[' ', 'Null object reference.'],
		['Camera Zoom', 'Zoom in the camera.'],
		['Hey!', 'Play Hey! Animation on \'Characters\''],
		['Pico Animation', 'Play Pico Shooting animations.'],
		['Lyrics', 'Sets Lyric Text'],
		['Change Character', 'Changes the character.']
	];
}

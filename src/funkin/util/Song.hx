package funkin.util;

import funkin.structures.ChartStructures.LegacyChartStructure;
import funkin.structures.ChartStructures.LegacySectionStructure;
import haxe.Json;
import lime.utils.Assets;

class Song
{
	public static function loadFromJson(jsonInput:String, ?folder:String):LegacyChartStructure
	{
		var rawJson:String = null;

		try
		{
			rawJson = Paths.content.jsonText('data/charts/' + folder.formatToPath() + '/' + jsonInput.formatToPath()).trim();
		}
		catch (e)
		{
			FlxG.log.error('Error loading Song!\nDetails: ' + e);
			return null;
		}

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):LegacyChartStructure
	{
		var swagShit:LegacyChartStructure = cast Json.parse(rawJson).song;
		return swagShit;
	}
}

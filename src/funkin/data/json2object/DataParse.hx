package funkin.data.json2object;

import funkin.util.LegacyObjects;

class DataParse
{
	/**
	 * Array of JSON elements `[Json, Json, Json]` to a Dynamic array `[String, Object, Int, Array]`
	 * @param jsons
	 * @return Array<Dynamic>
	 */
	static function jsonArrayToDynamicArray(jsons:Array<Json>):Array<Null<Dynamic>>
	{
		return [for (json in jsons) Tools.getValue(json)];
	}

	static function jsonArrayToLegacyNotes(jsons:Array<Json>):Array<LegacyNotes>
	{
		return jsonArrayToDynamicArray(jsons);
	}
}

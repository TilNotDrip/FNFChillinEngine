package funkin.data.json2object;

import hxjsonast.Tools;

class DataParse
{
	/**
	 * Parser which outputs a Any value, which is any basic type. (Bool, String, etc.)
	 * @param json
	 * @param name
	 * @return The value of the property.
	 */
	public static function anyValue(json:Json, name:String):Any
	{
		switch (json.value)
		{
			case JObject(_):
				throw 'Expected ${name} to not be an object, but it was an object.';
			default:
				return Tools.getValue(json);
		}
	}

	/**
	 * Parser which outputs a Dynamic value, either a object or something else.
	 * @param json
	 * @param name
	 * @return The value of the property.
	 */
	public static function dynamicValue(json:Json, name:String):Dynamic
	{
		return Tools.getValue(json);
	}

	public static function jsonArrayToLegacyNotes(json:Json, name:String):Array<Dynamic>
	{
		var results:Array<Dynamic> = [];

		switch (json.value)
		{
			case JArray(values):
				switch (jsonArray.value)
				{
					case JArray(values):
						results.push([for (value in values) anyValue(value, name + ' index value')]);
					default:
						throw 'Expected ${name} index to be an array, but it was ${json.value}.';
				}
			default:
				throw 'Expected ${name} to be an array, but it was ${json.value}.';
		}

		return results;
	}

	/**
	 * Parser which outputs a Map value, with String key, and a Any value.
	 * @param json 
	 * @param name 
	 * @return The value of the property.
	 */
	static function jsonStringAnyMap(json:Json, name:String):Map<String, Any>
	{
		switch (json.value)
		{
			case JObject(fields):
				var generatedMap:Map<String, Any> = new Map<String, Any>();

				for (field in fields)
					generatedMap.set(field.name, anyValue(field.value, field.name));

				return generatedMap;
			default:
				throw 'Expected ${name} to be an array, but it was ${json.value}.';
		}
	}
}

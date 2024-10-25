package funkin.data.json2object;

class DataWrite
{
	/**
	 * `@:jcustomwrite(funkin.data.json2object.DataWrite.dynamicValue)`
	 * @param value
	 * @return String
	 */
	public static function dynamicValue(value:Dynamic):String
	{
		// Is this cheating? Yes. Do I care? No.
		return haxe.Json.stringify(value, null, "\t");
	}

	/**
	 * `@:jcustomwrite(funkin.data.json2object.DataWrite.jsonStringAnyMap)`
	 * @param value
	 * @return String
	 */
	public static function jsonStringAnyMap(value:Map<String, Any>):String
	{
		return dynamicValue(value);
	}
}

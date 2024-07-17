package utils;

import flixel.system.macros.FlxMacroUtil;

enum abstract Direction(Int) from Int to Int
{
	var LEFT = 0;
	var DOWN = 1;
	var UP = 2;
	var RIGHT = 3;

	private static var fromStringMap(default, null):Map<String, Direction> = FlxMacroUtil.buildMap("utils.Direction");
	private static var toStringMap(default, null):Map<Direction, String> = FlxMacroUtil.buildMap("utils.Direction", true);

	public function toString():String
	{
		return toStringMap.get(this);
	}

	public function toColor():String
	{
		var colorArray:Array<String> = ['purple', 'blue', 'green', 'red'];

		return colorArray[this];
	}
}

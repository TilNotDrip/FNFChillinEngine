package funkin.data;

import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxSave;

class FunkinControls
{
	static var controlsSave:FlxSave;
	public static var numPlayers(default, null) = 0;
	public static var players(default, null):Array<FunkinControls> = [];

	public var id(default, null):Int;

	public var controls(default, null):Controls;

	public static var controlSettings:Array<Map<String, Array<Array<Int>>>> = [];

	function new(id:Int, gamepad:FlxGamepad)
	{
		this.id = id;
		this.controls = new Controls(id, gamepad);
	}

	public static function init():Void
	{
		controlsSave = new FlxSave();
		controlsSave.bind('controls', CoolUtil.getSavePath());

		/*if (controlsSave.data.controls != null)
				controlSettings = controlsSave.data.controls;
			else */
		controlSettings.push(getDefaultControls());

		players.push(new FunkinControls(numPlayers, FlxG.gamepads.getByID(numPlayers)));
		++numPlayers;
	}

	public static function getControls(id:Int):Map<String, Array<Array<Int>>>
	{
		return controlSettings[id];
	}

	public static function saveControls():Void
	{
		controlsSave.data.controls = controlSettings;
		controlsSave.flush();
	}

	static function getDefaultControls():Map<String, Array<Array<Int>>>
	{
		return [
			'UI_UP' => [[87, 38], [11, 34]],
			'UI_DOWN' => [[83, 40], [12, 36]],
			'UI_LEFT' => [[65, 37], [13, 37]],
			'UI_RIGHT' => [[68, 39], [14, 35]],
			'NOTE_UP' => [[87, 38], [11, 3]],
			'NOTE_DOWN' => [[83, 40], [12, 0]],
			'NOTE_LEFT' => [[65, 37], [13, 2]],
			'NOTE_RIGHT' => [[68, 39], [14, 1]],
			'ACCEPT' => [[32, 13], [0]],
			'BACK' => [[8, 27], [1]],
			'PAUSE' => [[13, 27], [7]],
			'RESET' => [[82], []]
		];
	}
}

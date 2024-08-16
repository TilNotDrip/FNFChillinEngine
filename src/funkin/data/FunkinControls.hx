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

	public static var controlSettings:Array<Map<String, Array<Array<String>>>> = [];

	function new(id:Int, gamepad:FlxGamepad)
	{
		this.id = id;
		this.controls = new Controls(id, gamepad);
	}

	public static function init():Void
	{
		controlsSave = new FlxSave();
		controlsSave.bind('controls', CoolUtil.getSavePath());

		if (controlsSave.data.controls != null)
			controlSettings = controlsSave.data.controls;
		else
			controlSettings.push(getDefaultControls());

		players.push(new FunkinControls(numPlayers, FlxG.gamepads.getByID(numPlayers)));
		++numPlayers;
	}

	public static function getControls(id:Int):Map<String, Array<Array<String>>>
	{
		return controlSettings[id];
	}

	public static function saveControls():Void
	{
		controlsSave.data.controls = controlSettings;
		controlsSave.flush();
	}

	static function getDefaultControls()
	{
		return [
			'UI_UP' => [['W', 'UP'], ['DPAD_UP', 'LEFT_STICK_DIGITAL_UP']],
			'UI_DOWN' => [['S', 'DOWN'], ['DPAD_DOWN', 'LEFT_STICK_DIGITAL_DOWN']],
			'UI_LEFT' => [['A', 'LEFT'], ['DPAD_LEFT', 'LEFT_STICK_DIGITAL_LEFT']],
			'UI_RIGHT' => [['D', 'RIGHT'], ['DPAD_RIGHT', 'LEFT_STICK_DIGITAL_RIGHT']],
			'NOTE_UP' => [['W', 'UP'], ['DPAD_UP', 'Y']],
			'NOTE_DOWN' => [['S', 'DOWN'], ['DPAD_DOWN', 'A']],
			'NOTE_LEFT' => [['A', 'LEFT'], ['DPAD_LEFT', 'X']],
			'NOTE_RIGHT' => [['D', 'RIGHT'], ['DPAD_RIGHT', 'B']],
			'ACCEPT' => [['SPACE', 'ENTER'], ['A']],
			'BACK' => [['BACKSPACE', 'ESCAPE'], ['B']],
			'PAUSE' => [['ENTER', 'ESCAPE'], ['START']],
			'RESET' => [['R'], []]
		];
	}
}

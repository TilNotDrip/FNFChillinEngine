package addons;

import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxSave;

class PlayerSettings
{
	private static var controlsSave:FlxSave;
	public static var numPlayers(default, null) = 0;
	public static var players(default, null):Array<PlayerSettings> = [];

	public var id(default, null):Int;

	public var controls(default, null):Controls;

	public static var controlSettings:Array<Map<String, Array<Array<String>>>> = [];

	private function new(id:Int, gamepad:FlxGamepad)
	{
		this.id = id;
		this.controls = new Controls(id, gamepad);
	}

	public static function init():Void
	{
		controlsSave = new FlxSave();
		controlsSave.bind('controls', CoolTools.getSavePath());

		if(controlsSave.data.controls != null)
			controlSettings = controlsSave.data.controls;
		else
			controlSettings.push(getDefaultControls());

		players.push(new PlayerSettings(numPlayers, FlxG.gamepads.getByID(numPlayers)));
		++numPlayers;
	}

	public static function getControls(id:Int):Map<String, Array<Array<String>>>
	{
		new FlxTimer().start(0.001, function(tmr:FlxTimer) {
			controlsSave.data.controls = controlSettings;
		});
		return controlSettings[id];
	}

	private static function getDefaultControls()
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

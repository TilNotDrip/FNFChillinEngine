package addons;

import flixel.input.gamepad.FlxGamepad;

class PlayerSettings
{
	static public var numPlayers(default, null) = 0;
	static public var players(default, null):Array<PlayerSettings> = [];

	public var id(default, null):Int;

	public var controls(default, null):Controls;

	public static var controlSettings:Array<Map<String, Array<Array<String>>>> = [];

	function new(id:Int, gamepad:FlxGamepad)
	{
		this.id = id;
		this.controls = new Controls(controlSettings[id], gamepad);
	}

	static public function init():Void
	{
		FlxG.save.data.controls = null;
		
		if(FlxG.save.data.controls != null)
			controlSettings = FlxG.save.data.controls;
		else
			controlSettings.push(getDefaultControls());

		players.push(new PlayerSettings(numPlayers, FlxG.gamepads.getByID(numPlayers)));
		++numPlayers;
	}
	

	public static function getControls(id:Int):Map<String, Array<Array<String>>>
	{
		new FlxTimer().start(0.001, function(tmr:FlxTimer) {
			FlxG.save.data.controls = controlSettings;
		});
		return controlSettings[id];
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

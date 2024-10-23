package funkin.util;

import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

class Controls
{
	// UI
	public var UI_UP(get, never):Bool;

	inline function get_UI_UP()
		return checkKey('UI_UP');

	public var UI_LEFT(get, never):Bool;

	inline function get_UI_LEFT()
		return checkKey('UI_LEFT');

	public var UI_RIGHT(get, never):Bool;

	inline function get_UI_RIGHT()
		return checkKey('UI_RIGHT');

	public var UI_DOWN(get, never):Bool;

	inline function get_UI_DOWN()
		return checkKey('UI_DOWN');

	public var UI_UP_P(get, never):Bool;

	inline function get_UI_UP_P()
		return checkKey('UI_UP', JUST_PRESSED);

	public var UI_LEFT_P(get, never):Bool;

	inline function get_UI_LEFT_P()
		return checkKey('UI_LEFT', JUST_PRESSED);

	public var UI_RIGHT_P(get, never):Bool;

	inline function get_UI_RIGHT_P()
		return checkKey('UI_RIGHT', JUST_PRESSED);

	public var UI_DOWN_P(get, never):Bool;

	inline function get_UI_DOWN_P()
		return checkKey('UI_DOWN', JUST_PRESSED);

	public var UI_UP_R(get, never):Bool;

	inline function get_UI_UP_R()
		return checkKey('UI_UP', RELEASED);

	public var UI_LEFT_R(get, never):Bool;

	inline function get_UI_LEFT_R()
		return checkKey('UI_LEFT', RELEASED);

	public var UI_RIGHT_R(get, never):Bool;

	inline function get_UI_RIGHT_R()
		return checkKey('UI_RIGHT', RELEASED);

	public var UI_DOWN_R(get, never):Bool;

	inline function get_UI_DOWN_R()
		return checkKey('UI_DOWN', RELEASED);

	// NOTES
	public var NOTE_UP(get, never):Bool;

	inline function get_NOTE_UP()
		return checkKey('NOTE_UP');

	public var NOTE_LEFT(get, never):Bool;

	inline function get_NOTE_LEFT()
		return checkKey('NOTE_LEFT');

	public var NOTE_RIGHT(get, never):Bool;

	inline function get_NOTE_RIGHT()
		return checkKey('NOTE_RIGHT');

	public var NOTE_DOWN(get, never):Bool;

	inline function get_NOTE_DOWN()
		return checkKey('NOTE_DOWN');

	public var NOTE_UP_P(get, never):Bool;

	inline function get_NOTE_UP_P()
		return checkKey('NOTE_UP', JUST_PRESSED);

	public var NOTE_LEFT_P(get, never):Bool;

	inline function get_NOTE_LEFT_P()
		return checkKey('NOTE_LEFT', JUST_PRESSED);

	public var NOTE_RIGHT_P(get, never):Bool;

	inline function get_NOTE_RIGHT_P()
		return checkKey('NOTE_RIGHT', JUST_PRESSED);

	public var NOTE_DOWN_P(get, never):Bool;

	inline function get_NOTE_DOWN_P()
		return checkKey('NOTE_DOWN', JUST_PRESSED);

	public var NOTE_UP_R(get, never):Bool;

	inline function get_NOTE_UP_R()
		return checkKey('NOTE_UP', RELEASED);

	public var NOTE_LEFT_R(get, never):Bool;

	inline function get_NOTE_LEFT_R()
		return checkKey('NOTE_LEFT', RELEASED);

	public var NOTE_RIGHT_R(get, never):Bool;

	inline function get_NOTE_RIGHT_R()
		return checkKey('NOTE_RIGHT', RELEASED);

	public var NOTE_DOWN_R(get, never):Bool;

	inline function get_NOTE_DOWN_R()
		return checkKey('NOTE_DOWN', RELEASED);

	// GAME/UI
	public var ACCEPT(get, never):Bool;

	inline function get_ACCEPT()
		return checkKey('ACCEPT', JUST_PRESSED);

	public var BACK(get, never):Bool;

	inline function get_BACK()
		return checkKey('BACK', JUST_PRESSED);

	public var PAUSE(get, never):Bool;

	inline function get_PAUSE()
		return checkKey('PAUSE', JUST_PRESSED);

	public var RESET(get, never):Bool;

	inline function get_RESET()
		return checkKey('RESET', JUST_PRESSED);

	#if CAN_CHEAT
	public var CHEAT(get, never):Bool;

	inline function get_CHEAT()
		return checkKey('CHEAT');
	#end

	public function new(id:Int, ?controller:FlxGamepad = null)
	{
		this.controller = controller;
		this.id = id;
	}

	var id:Int;
	var controller:FlxGamepad = null;

	public function checkKey(key:String, type:TypePressed = PRESSED):Bool
	{
		var checked:Bool = false;

		var keyArray:Array<FlxKey> = [];

		for (key in FunkinControls.getControls(id).get(key)[0])
			keyArray.push(key);

		switch (type)
		{
			case JUST_PRESSED:
				checked = FlxG.keys.anyJustPressed(keyArray);

			case RELEASED:
				checked = FlxG.keys.anyJustReleased(keyArray);

			case PRESSED:
				checked = FlxG.keys.anyPressed(keyArray);
		}

		if (checked)
			return checked;

		if (controller != null)
		{
			var buttonArray:Array<FlxGamepadInputID> = [];

			for (key in FunkinControls.getControls(id).get(key)[1])
				buttonArray.push(key);

			try
			{
				checked = switch (type)
				{
					case JUST_PRESSED:
						controller.anyJustPressed(buttonArray);

					case RELEASED:
						controller.anyJustReleased(buttonArray);

					case PRESSED:
						controller.anyPressed(buttonArray);
				}
			}
			catch (e)
			{
				FlxG.log.error('Controller Checking failed! Did it disconnect?');
			}
		}

		return checked;
	}
}

enum TypePressed
{
	PRESSED;
	JUST_PRESSED;
	RELEASED;
}

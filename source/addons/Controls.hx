package addons;

import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;

class Controls
{
	// UI
	public var UI_UP   (get, never):Bool; inline function get_UI_UP   () return checkKey('UI_UP');
	public var UI_LEFT (get, never):Bool; inline function get_UI_LEFT () return checkKey('UI_LEFT');
	public var UI_RIGHT(get, never):Bool; inline function get_UI_RIGHT() return checkKey('UI_RIGHT');
	public var UI_DOWN (get, never):Bool; inline function get_UI_DOWN () return checkKey('UI_DOWN');

	public var UI_UP_P   (get, never):Bool; inline function get_UI_UP_P   () return checkKey('UI_UP', 'just');
	public var UI_LEFT_P (get, never):Bool; inline function get_UI_LEFT_P () return checkKey('UI_LEFT', 'just');
	public var UI_RIGHT_P(get, never):Bool; inline function get_UI_RIGHT_P() return checkKey('UI_RIGHT', 'just');
	public var UI_DOWN_P (get, never):Bool; inline function get_UI_DOWN_P () return checkKey('UI_DOWN', 'just');

	public var UI_UP_R   (get, never):Bool; inline function get_UI_UP_R   () return checkKey('UI_UP', 'released');
	public var UI_LEFT_R (get, never):Bool; inline function get_UI_LEFT_R () return checkKey('UI_LEFT', 'released');
	public var UI_RIGHT_R(get, never):Bool; inline function get_UI_RIGHT_R() return checkKey('UI_RIGHT', 'released');
	public var UI_DOWN_R (get, never):Bool; inline function get_UI_DOWN_R () return checkKey('UI_DOWN', 'released');

	// NOTES
	public var NOTE_UP   (get, never):Bool; inline function get_NOTE_UP   () return checkKey('NOTE_UP');
	public var NOTE_LEFT (get, never):Bool; inline function get_NOTE_LEFT () return checkKey('NOTE_LEFT');
	public var NOTE_RIGHT(get, never):Bool; inline function get_NOTE_RIGHT() return checkKey('NOTE_RIGHT');
	public var NOTE_DOWN (get, never):Bool; inline function get_NOTE_DOWN () return checkKey('NOTE_DOWN');

	public var NOTE_UP_P   (get, never):Bool; inline function get_NOTE_UP_P   () return checkKey('NOTE_UP', 'just');
	public var NOTE_LEFT_P (get, never):Bool; inline function get_NOTE_LEFT_P () return checkKey('NOTE_LEFT', 'just');
	public var NOTE_RIGHT_P(get, never):Bool; inline function get_NOTE_RIGHT_P() return checkKey('NOTE_RIGHT', 'just');
	public var NOTE_DOWN_P (get, never):Bool; inline function get_NOTE_DOWN_P () return checkKey('NOTE_DOWN', 'just');

	public var NOTE_UP_R   (get, never):Bool; inline function get_NOTE_UP_R   () return checkKey('NOTE_UP', 'released');
	public var NOTE_LEFT_R (get, never):Bool; inline function get_NOTE_LEFT_R () return checkKey('NOTE_LEFT', 'released');
	public var NOTE_RIGHT_R(get, never):Bool; inline function get_NOTE_RIGHT_R() return checkKey('NOTE_RIGHT', 'released');
	public var NOTE_DOWN_R (get, never):Bool; inline function get_NOTE_DOWN_R () return checkKey('NOTE_DOWN', 'released');

	// GAME/UI
	public var ACCEPT(get, never):Bool; inline function get_ACCEPT() return checkKey('ACCEPT', 'just');
	public var BACK  (get, never):Bool; inline function get_BACK  () return checkKey('BACK', 'just');
	public var PAUSE (get, never):Bool; inline function get_PAUSE () return checkKey('PAUSE', 'just');
	public var RESET (get, never):Bool; inline function get_RESET () return checkKey('RESET', 'just');
	#if CAN_CHEAT
	public var CHEAT (get, never):Bool; inline function get_CHEAT () return checkKey('CHEAT');
	#end

	public function new(id:Int, ?controller:FlxGamepad = null) 
	{
		this.controller = controller;
		this.id = id;
	}

	var id:Int;
	var controller:FlxGamepad = null;
	public function checkKey(key:String, type:String = 'pressed'):Bool
	{
		var checked:Bool = false;

		var keyArray:Array<FlxKey> = [];

		for(key in PlayerSettings.getControls(id).get(key)[0])
			keyArray.push(FlxKey.fromString(key));

		switch(type)
		{
			case 'just':
				checked = FlxG.keys.anyJustPressed(keyArray);
			case 'released':
				checked = FlxG.keys.anyJustReleased(keyArray);
			default:
				checked = FlxG.keys.anyPressed(keyArray);
		}

		if(controller != null)
		{
			var buttonArray:Array<FlxGamepadInputID> = [];

			for(key in PlayerSettings.getControls(id).get(key)[1])
				buttonArray.push(FlxGamepadInputID.fromString(key));

			switch(type)
			{
				case 'just':
					if(!checked) checked = controller.anyJustPressed(buttonArray);
				case 'released':
					if(!checked) checked = controller.anyJustPressed(buttonArray);
				default:
					if(!checked) checked = controller.anyPressed(buttonArray);
			}
		}

		return checked;
	}
}
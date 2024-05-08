package display;

import flixel.util.FlxStringUtil;

import openfl.text.TextField;
import openfl.text.TextFormat;

import openfl.system.System;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Float;
    public var currentMEM(default, null):String;
	public var currentState(default, null):String;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		currentMEM = "0";
		currentState = "";

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "FPS: " + currentFPS
            + "\nMEM: " + currentMEM
            + "\nState: " + currentState
            + "\nVersion: " + Application.current.meta.get('version');
		multiline = true;
		width += 100;

		cacheCount = 0;
		currentTime = 0;
		times = [];
	}

	override private function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
			times.shift();

		var currentCount = times.length;

		currentFPS = Math.round((currentCount + cacheCount) / 2);
		currentMEM = FlxStringUtil.formatBytes(System.totalMemory, 2);
		currentState = Type.getClassName(Type.getClass(FlxG.state));

		if (currentCount != cacheCount)
		{
			text = "FPS: " + currentFPS
            + "\nMEM: " + currentMEM
            + "\nSTATE: " + currentState
            + "\nVERSION: " + Application.current.meta.get('version');
		}

		cacheCount = currentCount;
	}
}
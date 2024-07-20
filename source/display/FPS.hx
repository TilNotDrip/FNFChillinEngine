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

	public var currentMEM(get, null):String;

	public var currentMEMPeak(get, null):String;

	public var currentState(get, null):String;

	public var memPeak(default, null):Float;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		memPeak = 0;

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = '';
		multiline = true;
		width += 300;

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

		if (System.totalMemory >= memPeak)
			memPeak = System.totalMemory;

		if (currentCount != cacheCount)
		{
			text = 'FPS: ${currentFPS}'
				+ '\nMEM: ${currentMEM} / ${currentMEMPeak}'
				+ ((ChillSettings.get('devMode')) ? '\nSTATE: ${currentState}' : '')
				+ '\nVERSION: ${Application.current.meta.get('version')}';
		}

		cacheCount = currentCount;
	}

	function get_currentMEM():String
	{
		return FlxStringUtil.formatBytes(System.totalMemory, 2);
	}

	function get_currentMEMPeak():String
	{
		return FlxStringUtil.formatBytes(memPeak, 2);
	}

	function get_currentState():String
	{
		return Type.getClassName(Type.getClass(FlxG.state));
	}
}

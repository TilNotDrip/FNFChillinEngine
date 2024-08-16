package funkin.display;

import flixel.util.FlxStringUtil;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPS extends TextField
{
	/**
	 * The current frame rate, expressed using frames-per-second
	 */
	public var currentFPS(default, null):Float;

	#if cpp
	public var currentMEM(default, null):String;
	#end

	#if debug
	public var currentState(default, null):String;
	#end

	@:noCompletion var cacheCount:Int;
	@:noCompletion var currentTime:Float;
	@:noCompletion var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;

		#if cpp
		currentMEM = "0";
		#end

		#if debug
		currentState = "";
		#end

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "";
		multiline = true;
		width += #if debug 350 #else 100 #end;

		cacheCount = 0;
		currentTime = 0;
		times = [];
	}

	override function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
			times.shift();

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		#if cpp
		currentMEM = FlxStringUtil.formatBytes(cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE), 2);
		#end

		currentState = Type.getClassName(Type.getClass(FlxG.state));

		if (currentCount != cacheCount)
		{
			text = 'FPS: $currentFPS' #if cpp + '\nMEM: $currentMEM' #end
			#if debug + '\nSTATE: $currentState' + '\nVERSION: ${Application.current.meta.get('version')}' #end;
		}
		cacheCount = currentCount;
	}
}

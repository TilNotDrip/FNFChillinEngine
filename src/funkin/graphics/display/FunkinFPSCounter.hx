package funkin.graphics.display;

import haxe.Timer;
#if cpp
import cpp.vm.Gc;
#end
import flixel.util.FlxStringUtil;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FunkinFPSCounter extends TextField
{
	/**
	 * The current frame rate, expressed using frames-per-second
	 */
	public var currentFPS:Float = 0;

	#if cpp
	public var currentMEM:String = '';
	#end

	#if debug
	public var currentState:String = '';
	#end

	var framesThisSecond:Float = 0.0;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "";
		multiline = true;
		width += #if debug 350 #else 100 #end;

		var timer:Timer = new Timer(1000);
		timer.run = () ->
		{
			currentFPS = framesThisSecond;
			framesThisSecond = 0;
		}
	}

	override public function __enterFrame(deltaTime:Float):Void
	{
		framesThisSecond++;
		text = getFPSText() + getMEMText() + getStateText() + getVersionText();
	}

	function getFPSText():String
	{
		return '[FPS]: ∞\n';
	}

	function getMEMText():String
	{
		#if cpp
		return '[MEM]: ${FlxStringUtil.formatBytes(Gc.memInfo64(Gc.MEM_INFO_USAGE), 2)}\n';
		#else
		return '';
		#end
	}

	function getStateText():String
	{
		#if debug
		return '[STATE]: ${Type.getClassName(Type.getClass(FlxG.state))}\n';
		#else
		return '';
		#end
	}

	function getVersionText():String
	{
		#if debug
		return '[VERSION]: ${Application.current.meta.get('version')}\n';
		#else
		return '';
		#end
	}
}

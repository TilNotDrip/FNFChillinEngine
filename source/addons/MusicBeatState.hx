package addons;

import addons.Conductor.BPMChangeEvent;

import flixel.addons.ui.FlxUIState;

#if MOD_SUPPORT
import hscript.InterpEx;
import hscript.AbstractScriptClass;
#end

import openfl.Assets;

class MusicBeatState extends FlxUIState
{
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curSection:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	#if MOD_SUPPORT
	public var stateScript:AbstractScriptClass;
	private var _interp:InterpEx = new InterpEx(); // stole all interp code from examples cuz THERE IS NO FUCKING DOCUMENTATION 

	override public function new()
	{
		var classArray:Array<String> = Type.getClassName(Type.getClass(FlxG.state)).split('.');
		var className:String = classArray[classArray.length-1];
		var contents:String = Assets.getText(Paths.file('states/$className.hx', TEXT, null));
		_interp.addModule(contents);
		stateScript = _interp.createScriptClassInstance(className);

		super();
	}
	#end

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
		runFunction('create');
	}

	override function update(elapsed:Float)
	{
		var oldStep:Int = curStep;

		updateStep();
		updateBeat();
		updateSection();

		if (oldStep != curStep && curStep >= 0) {
			stepHit();

			if (curStep % 4 == 0)
				beatHit();

			if (curStep % 16 == 0)
				sectionHit();
		}

		super.update(elapsed);
		runFunction('update', [elapsed]);
	}

	private function updateSection():Void
	{
		curSection = Math.floor(curStep / 16);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
		runFunction('stepHit');

	public function beatHit():Void
		runFunction('beatHit');

	public function sectionHit():Void
		runFunction('sectionHit');

	public function runFunction(name:String, ?args:Null<Array<Dynamic>> = null):Void
	{
		#if MOD_SUPPORT
		if(stateScript.hasField(name)) stateScript.callFunction(name, args);
		#else
		//FlxG.log.add("Ran the major function " + name + ((args == null) ? 'with no args.' : 'with args: ' + Std.string(args))); // this was a fucking dumb idea
		#end
	}

	public function changeWindowName(windowName:String = '') 
		Application.current.window.title = Application.current.meta.get('name') + (windowName == '' ? '' : ' - ') + windowName;
}

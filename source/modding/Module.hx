package modding;

import objects.game.Note;

class Module
{
	private static var normalModules:Array<Module> = [];
	private static var scriptedModules:Array<hscript.AbstractScriptClass> = [];

	public static function reloadModules()
	{
		scriptedModules = HScript.listScriptsClasses(Module);

		// put normal module code here
	}

	private static var initialized:Bool = false;

	public static function init()
	{
		if (initialized)
			return;

		reloadModules();

		FlxG.signals.postStateSwitch.add(function()
		{
			callFunction('create');
		});

		FlxG.signals.postUpdate.add(function()
		{
			callFunction('update', [FlxG.elapsed]);
		});

		Conductor.stepSignal.add(function()
		{
			callFunction('stepHit');
		});

		Conductor.beatSignal.add(function()
		{
			callFunction('beatHit');
		});

		Conductor.beatSignal.add(function()
		{
			callFunction('sectionHit');
		});

		initialized = true;
	}

	public static function callFunction(name:String, ?args:Array<Dynamic>):Array<Dynamic>
	{
		if (args == null)
			args = [];

		var returnArray:Array<Dynamic> = [];

		for (i in normalModules)
			returnArray.push(Reflect.callMethod(i, Reflect.field(i, name), args));

		for (i in scriptedModules)
			returnArray.push(i.callFunction(name, args));

		return returnArray;
	}

	public var id:String;

	public function new(id:String)
	{
		this.id = id;
	}

	public function create() {}

	public function update(elapsed:Float) {}

	public function stepHit() {}

	public function beatHit() {}

	public function sectionHit() {}

	public function pauseGame() {}

	public function resumeGame() {}

	public function startCountdown() {}

	public function startSong() {}

	public function endSong() {}

	public function gameOver() {}

	public function goodNoteHit(note:Note) {}

	public function opponentNoteHit(note:Note) {}

	public function noteMiss(note:Note) {}
}

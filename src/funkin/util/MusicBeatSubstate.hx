package funkin.util;

import funkin.util.Conductor.BPMChangeEvent;

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	var curStep:Int = 0;
	var curBeat:Int = 0;
	var curSection:Int = 0;
	var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.players[0].controls;

	override public function update(elapsed:Float)
	{
		var oldStep:Int = curStep;

		updateStep();
		curSection = Math.floor(curStep / 16);
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep >= 0)
			stepHit();

		super.update(elapsed);
	}

	function updateStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		if (curStep % 16 == 0)
			sectionHit();
	}

	public function sectionHit():Void {}

	public function changeWindowName(windowName:String = '')
		Application.current.window.title = Application.current.meta.get('name') + (windowName == '' ? '' : ' - ') + windowName;
}

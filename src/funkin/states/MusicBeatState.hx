package funkin.states;

import funkin.util.Conductor.BPMChangeEvent;
import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
	var curStep:Int = 0;
	var curBeat:Int = 0;
	var curSection:Int = 0;
	var controls(get, never):Controls;

	inline function get_controls():Controls
		return FunkinControls.players[0].controls;

	public function new()
	{
		#if FUNKIN_DISCORD_RPC
		DiscordRPC.clearValues();
		DiscordRPC.largeImageKey = 'logo';
		DiscordRPC.largeImageText = 'Friday Night Funkin\'; Chillin Engine: V' + Application.current.meta.get('version');
		#end

		super();
	}

	override public function update(elapsed:Float):Void
	{
		var oldStep:Int = curStep;

		updateStep();
		updateBeat();
		updateSection();

		if (oldStep != curStep && curStep >= 0)
		{
			stepHit();

			if (curStep % 4 == 0)
				beatHit();

			if (curStep % 16 == 0)
				sectionHit();
		}

		super.update(elapsed);
	}

	function updateSection():Void
	{
		curSection = Math.floor(curStep / 16);
	}

	function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
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
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void {}

	public function beatHit():Void {}

	public function sectionHit():Void {}

	public function changeWindowName(windowName:String = '')
		Application.current.window.title = Application.current.meta.get('name') + (windowName == '' ? '' : ' - ') + windowName;
}

package addons;

import addons.Conductor.BPMChangeEvent;

import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curSection:Int = 0;
	private var controls(get, never):Controls;

	inline private function get_controls():Controls
		return PlayerSettings.players[0].controls;

	public function new()
	{
		#if DISCORD
		DiscordRPC.clearValues();
		DiscordRPC.largeImageKey = 'logo';
		DiscordRPC.largeImageText = 'Friday Night Funkin\'; Chillin Engine: V' + Application.current.meta.get('version');
		#end

		super();
	}

	override public function update(elapsed:Float)
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

	public function stepHit():Void {}

	public function beatHit():Void {}

	public function sectionHit():Void {}

	public function changeWindowName(windowName:String = '') 
		Application.current.window.title = Application.current.meta.get('name') + (windowName == '' ? '' : ' - ') + windowName;
}

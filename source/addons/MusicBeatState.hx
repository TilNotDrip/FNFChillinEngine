package addons;

import addons.Conductor.BPMChangeEvent;

import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
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

		FlxG.fixedTimestep = false;

		super();
	}

	override public function create()
	{
		Conductor.stepSignal.add(stepHit);
		Conductor.beatSignal.add(beatHit);
		Conductor.sectionSignal.add(sectionHit);

		super.create();
	}

	public function stepHit():Void {}

	public function beatHit():Void {}

	public function sectionHit():Void {}

	public function changeWindowName(windowName:String = '') 
		Application.current.window.title = Application.current.meta.get('name') + (windowName == '' ? '' : ' - ') + windowName;

	override public function destroy()
	{
		Conductor.stepSignal.remove(stepHit);
		Conductor.beatSignal.remove(beatHit);
		Conductor.sectionSignal.remove(sectionHit);
	}
}

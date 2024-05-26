package addons;

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curSection:Int = 0;
	private var controls(get, never):Controls;

	inline private function get_controls():Controls
		return PlayerSettings.players[0].controls;

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

		super.destroy();
	}
}

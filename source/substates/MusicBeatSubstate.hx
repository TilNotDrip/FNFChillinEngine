package substates;

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

	override public function create():Void
	{
		Conductor.stepSignal.add(stepHit);
		Conductor.beatSignal.add(beatHit);
		Conductor.sectionSignal.add(sectionHit);

		super.create();
	}

	public function stepHit():Void {}

	public function beatHit():Void {}

	public function sectionHit():Void {}

	public function changeWindowName(windowName:String = ''):Void
		Application.current.window.title = Application.current.meta.get('name') + (windowName == '' ? '' : ' - ') + windowName;

	override public function destroy():Void
	{
		Conductor.stepSignal.remove(stepHit);
		Conductor.beatSignal.remove(beatHit);
		Conductor.sectionSignal.remove(sectionHit);

		super.destroy();
	}
}

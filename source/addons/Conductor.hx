package addons;

import flixel.util.FlxSort;
import addons.Song.SwagBPMChange;
import flixel.util.FlxSignal;
import openfl.events.Event;
import addons.Song.SwagSong;

class Conductor
{
	public static var bpm(default, set):Float = 100;
	public static var crochet:Float = ((60 / bpm) * 1000);
	public static var stepCrochet:Float = crochet / 4;
	public static var songPosition(default, set):Float;
	public static var offset:Float = 0;
	public static var sectionSteps:Int = 16;

	public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

	public static var curStep:Int = 0;
	public static var curBeat:Int = 0;
	public static var curSection:Int = 0;

	static var bpmChangeCopy:Array<SwagBPMChange> = [];
	public static var bpmChangeMap:Array<SwagBPMChange> = [];

	public static var stepSignal:FlxSignal = new FlxSignal();
	public static var beatSignal:FlxSignal = new FlxSignal();
	public static var sectionSignal:FlxSignal = new FlxSignal();

	private function new() {}

	private static function set_songPosition(value:Float)
	{
		songPosition = value + offset;

		var oldStep:Int = curStep;
		var oldBeat:Int = curBeat;
		var oldSection:Int = curSection;

		if (bpmChangeMap[0] != null && bpmChangeMap[0].time >= songPosition)
		{
			bpm = bpmChangeMap[0].bpm;
			sectionSteps = bpmChangeMap[0].sectionSteps;
			bpmChangeMap.remove(bpmChangeMap[0]);
		}

		curStep = Math.floor(songPosition / stepCrochet);
		curBeat = Math.floor(songPosition / crochet);
		curSection = Math.floor(curStep / 16);

		if (oldStep != curStep && curStep >= 0)
			stepSignal.dispatch();

		if (oldBeat != curBeat && curBeat >= 0)
			beatSignal.dispatch();

		if (oldSection != curSection && curSection >= 0)
			sectionSignal.dispatch();

		return songPosition;
	}

	public static function mapBPMChanges(changes:Array<SwagBPMChange>)
	{
		bpmChangeMap = changes.copy();
		bpmChangeCopy = changes.copy();

		bpm = bpmChangeMap[0].bpm;
		sectionSteps = bpmChangeMap[0].sectionSteps;

		bpmChangeMap.sort(sortByTime);

		trace('BPM Map Changed!\n$bpmChangeMap');
	}

	public static function resetBPMChanges()
	{
		bpmChangeMap = bpmChangeCopy.copy();

		bpm = bpmChangeMap[0].bpm;
		sectionSteps = bpmChangeMap[0].sectionSteps;

		bpmChangeMap.sort(sortByTime);

		trace('BPM Map Reset!');
	}

	public static function destroy()
	{
		stepSignal.removeAll();
		beatSignal.removeAll();
		sectionSignal.removeAll();

		bpmChangeMap = [];
		bpmChangeCopy = [];
	}

	private static function set_bpm(newBpm:Float)
	{
		bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;

		return bpm;
	}

	static function sortByTime(Obj1:SwagBPMChange, Obj2:SwagBPMChange)
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.time, Obj2.time);
	}
}

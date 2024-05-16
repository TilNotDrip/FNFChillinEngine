package addons;

import flixel.util.FlxSignal;
import openfl.events.Event;
import addons.Song.SwagSong;

typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
}

class Conductor
{
	public static var bpm(default, set):Float = 100;
	public static var crochet:Float = ((60 / bpm) * 1000);
	public static var stepCrochet:Float = crochet / 4;
	public static var songPosition(default, set):Float;
	public static var lastSongPos:Float;
	public static var offset:Float = 0;

	public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

	public static var curStep:Int = 0;
	public static var curBeat:Int = 0;
	public static var curSection:Int = 0;

	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	public static var stepSignal:FlxSignal = new FlxSignal();
	public static var beatSignal:FlxSignal = new FlxSignal();
	public static var sectionSignal:FlxSignal = new FlxSignal();

	public function new() {}

	private static function set_songPosition(value:Float)
	{
		songPosition = value + offset;

		var oldStep:Int = curStep;
		var oldBeat:Int = curBeat;
		var oldSection:Int = curSection;

		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}

		for (i in 0...bpmChangeMap.length)
		{
			if (songPosition >= bpmChangeMap[i].songTime)
				lastChange = bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((songPosition - lastChange.songTime) / stepCrochet);
		curBeat = Math.floor(curStep / 4);
		curSection = Math.floor(curStep / 16);

		if (oldStep != curStep && curStep >= 0)
			stepSignal.dispatch();

		if (oldBeat != curBeat && curBeat >= 0)
			beatSignal.dispatch();

		if (oldSection != curSection && curSection >= 0)
			sectionSignal.dispatch();

		//trace('updated shizz');


		return songPosition;
	}

	public static function mapBPMChanges(song:SwagSong)
	{
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;

		for (i in 0...song.notes.length)
		{
			if(song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		trace('BPM Map Changed!\n$bpmChangeMap');
	}

	private static function set_bpm(newBpm:Float)
	{
		bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;

		return bpm;
	}
}

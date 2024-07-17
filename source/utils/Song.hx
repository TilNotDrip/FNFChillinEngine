package utils;

import utils.SongEvent;
import utils.Section.SwagSection;
import haxe.Json;
import lime.utils.Assets;

typedef SwagSong =
{
	var notes:Array<SwagNote>;
	var events:Array<SwagEvent>;
	var metadata:SwagMetadata;
}

typedef SwagNote =
{
	var type:String;
	var time:Float;
	var strum:String;
	var direction:Int;
	var length:Null<Float>;
}

typedef SwagMetadata =
{
	var bpmArray:Array<SwagBPMChange>;

	var player:String;
	var opponent:String;
	var gf:String;
	var stage:String;

	var song:String;
	var speed:Float;
}

typedef SwagBPMChange =
{
	var time:Float;
	var bpm:Float;
	var sectionSteps:Int;
}

typedef LegacySwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var player3:String;

	var stage:String;
}

class Song
{
	public static function autoSelectJson(song:String, difficulty:String):SwagSong
	{
		var daSong:SwagSong = null;

		if (getSongFile('$song/$song-chart') != null)
			daSong = convertFromVSlice(song, difficulty);

		trace('${daSong != null}fully passed vslice check!');

		var daSongString:String = getSongFile('$song/$difficulty');

		if (daSongString == null)
			daSongString = getSongFile('$song/$song-$difficulty');

		if (daSongString == null && daSong == null)
			return null; // dont even bother, it wont work

		if (daSong == null && daSongString.contains('"sectionNotes":')) // shitty, but it works
			daSong = upgradeJson(song, difficulty);

		trace('${daSong != null}fully passed old chart check!');

		if (daSong == null)
			daSong = loadFromJson(song, difficulty);

		trace('${daSong != null}fully passed new chart check!');

		return daSong;
	}

	public static function loadFromJson(song:String, difficulty:String):SwagSong
	{
		var rawJson:Null<String> = getSongFile('$song/$difficulty');

		if (rawJson == null)
			return null;

		return cast Json.parse(rawJson);
	}

	public static function upgradeJson(song:String, difficulty:String):SwagSong
	{
		var daSong:SwagSong = {
			notes: [],
			events: [],
			metadata: null
		};

		var rawJson:String = getSongFile('$song/$difficulty');

		if (rawJson == null)
			rawJson = getSongFile('$song/$song-$difficulty');

		if (rawJson == null)
			return null;

		var convertedJson:LegacySwagSong = cast Json.parse(rawJson).song;

		var daBPMArray:Array<SwagBPMChange> = [];
		var curBPMChange:SwagBPMChange = {time: 0, bpm: convertedJson.bpm, sectionSteps: 16};
		daBPMArray.push(curBPMChange);

		for (i in 0...convertedJson.notes.length)
		{
			var section:SwagSection = convertedJson.notes[i];

			if (section == null)
				continue; // for blazin, or other bad song converters

			daSong.events.push({
				name: 'Focus Camera',
				value: (section.mustHitSection) ? 'bf' : 'dad',
				strumTime: (((60 / curBPMChange.bpm) * 1000) * (curBPMChange.sectionSteps / 4)) * i
			});

			if (section.changeBPM)
				daBPMArray.push({
					time: (((60 / curBPMChange.bpm) * 1000) * (curBPMChange.sectionSteps / 4)) * i,
					sectionSteps: section.lengthInSteps,
					bpm: section.bpm
				});

			for (note in section.sectionNotes)
			{
				var daNote:String = 'Default';
				var daStrum:String = ((section.mustHitSection && note[1] >= 4)
					|| (!section.mustHitSection && note[1] <= 3)) ? 'Opponent' : 'Player';

				if (note[3] || (section.altAnim && daStrum == 'Opponent'))
					daNote = 'Alt';
				else if (note[3] != null && note[3] is String) // i feel like being nice, so im making it psych compatible
					daNote = note[3].replace('Note', '').trim();

				daSong.notes.push({
					type: daNote,
					time: note[0],
					length: note[2],
					direction: Std.int(note[1] % 4),
					strum: daStrum
				});
			}
		}

		daSong.metadata = {
			bpmArray: daBPMArray,
			player: convertedJson.player1,
			opponent: convertedJson.player2,
			gf: convertedJson.player3,
			stage: convertedJson.stage,
			song: convertedJson.song,
			speed: convertedJson.speed
		};

		return daSong;
	}

	public static function convertFromVSlice(song:String, difficulty:String):SwagSong
	{
		var daSong:SwagSong = {
			notes: [],
			events: [],
			metadata: null
		};

		var convertedMetadata:
			{
				var version:String;
				var songName:String;
				var artist:String;
				var timeFormat:String;
				var timeChanges:Array<
					{
						var t:Int;
						var bpm:Float;
						var n:Int;
						var d:Int;
						var bt:Array<Int>;
					}>;
				var playData:
					{
						var album:Float;
						var songVariations:Array<String>;
						var difficulties:Array<String>;
						var characters:
							{
								var player:String;
								var girlfriend:String;
								var opponent:String;
							};
						var stage:String;
						var noteStyle:String;
					};
			} = Json.parse(getSongFile('$song/$song-metadata'));

		var convertedParsed = Json.parse(getSongFile('$song/$song-chart'));

		var convertedNotes:Array<{
			var t:Int;
			var d:Int;
			var l:Int;
			var k:String;
		}> = Reflect.getProperty(convertedParsed.notes, difficulty); // im not doin all that

		if (convertedNotes == null)
			return null;

		var convertedEvents:Array<
			{
				var t:Int;
				var e:String;
				var v:Dynamic;
			}> = convertedParsed.events;

		var scrollSpeed:Null<Float> = 1;

		scrollSpeed = Reflect.getProperty(convertedParsed.scrollSpeed, difficulty);

		if (scrollSpeed == null)
			scrollSpeed = Reflect.getProperty(convertedParsed.scrollSpeed, 'default');

		if (scrollSpeed == null)
			scrollSpeed = 1;

		for (note in convertedNotes)
		{
			daSong.notes.push({
				type: note.k ?? 'Default',
				direction: Std.int(note.d % 4),
				time: note.t,
				strum: (note.d <= 3) ? 'Player' : 'Opponent',
				length: note.l ?? 0
			});
		}

		var daBPMArray:Array<SwagBPMChange> = [];

		for (change in convertedMetadata.timeChanges)
		{
			daBPMArray.push({time: change.t, bpm: change.bpm, sectionSteps: Std.int(change.n * change.d)});
		}

		for (event in convertedEvents)
		{
			var daEventName:String = '';
			var daEventValue:String = '';
			var curBPMChange:SwagBPMChange = null;

			for (bpmChange in daBPMArray)
			{
				if (bpmChange.time <= event.t)
					curBPMChange = bpmChange;
			}

			switch (event.e)
			{
				case "ZoomCamera":
					daEventName = 'Zoom Camera';
					daEventValue = Std.string(event.v.zoom ?? event.v);

				case "FocusCamera":
					daEventName = 'Focus Camera';
					switch (event.v.char ?? event.v)
					{
						case -1:
							daEventValue = '';

						case 1:
							daEventValue = 'dad';

						case 0:
							daEventValue = 'bf';

						case 2:
							daEventValue = 'gf';
					}

					if (event.v.ease != null)
					{
						var daEase:String = event.v.ease;

						switch (event.v.ease.toLowerCase())
						{
							case 'classic':
								daEase = 'lerp';

							case 'instant':
								daEase = 'lerp, 0';
						}
						daEventValue += ((daEventValue != '') ? ', ' : '') + daEase;
					}

					if (event.v.duration != null)
						daEventValue += ((daEventValue != '') ? ', ' : '') + FlxMath.roundDecimal(event.v.duration * ((60 / curBPMChange.bpm) / 4), 2);

					if (event.v.x != null && event.v.y != null)
						daEventValue = daEventValue + ((daEventValue != '') ? ', ' : '') + '[${event.v.x}, ${event.v.y}]';

				case "PlayAnimation":
					if (event.v.anim == 'hey')
					{
						daEventName = 'Hey!';
						daEventValue = 'bf gf';
					}

				default:
					continue;
			}

			daSong.events.push({name: daEventName, value: daEventValue, strumTime: event.t});
		}

		daSong.metadata = {
			bpmArray: daBPMArray,
			player: convertedMetadata.playData.characters.player,
			opponent: convertedMetadata.playData.characters.opponent,
			gf: convertedMetadata.playData.characters.girlfriend,
			stage: convertedMetadata.playData.stage,
			song: convertedMetadata.songName,
			speed: scrollSpeed
		};

		return daSong;
	}

	private static function getSongFile(path:String):Null<String>
	{
		var rawJson:Null<String> = null;
		try
		{
			rawJson = Assets.getText(Paths.location.json('data/charts/' + path)).trim();

			while (!rawJson.endsWith("}"))
				rawJson = rawJson.substr(0, rawJson.length - 1);
		}
		catch (e)
		{
			trace('Error loading Song!\nDetails: ' + e);
			FlxG.log.error('Error loading Song!\nDetails: ' + e);
			rawJson = null;
		}

		return rawJson;
	}
}

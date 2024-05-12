package addons;

import addons.Section.SwagSection;

import haxe.Json;

import lime.utils.Assets;

typedef SwagSong =
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
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var player3:String = 'gf';

	public var stage:String = '';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = null;
        try {
			rawJson = Assets.getText(Paths.json(folder.formatToPath() + '/' + jsonInput.formatToPath())).trim();
        } catch(e) {
			FlxG.log.error('Error loading Song!\nDetails: ' + e);
            return null;
        }

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		return swagShit;
	}

	public static function downgradeChart(rawJson:String, rawMetadata:String, diff:String):SwagSong
	{
		var song:Array<SwagSection> = [];

		var convertedMetadata:{
			var version:String;
			var songName:String;
			var artist:String;
			var timeFormat:String;
			var timeChanges:Array<{
				var t:Int;
				var bpm:Float;
				var n:Int;
				var d:Int;
				var bt:Array<Int>;
			}>;
			var playData:{
				var album:Float;
				var songVariations:Array<String>; 
				var difficulties:Array<String>;
				var characters:{
					var player:String;
					var girlfriend:String;
					var opponent:String;
				};
				var stage:String;
				var noteStyle:String;
			};
		} = Json.parse(rawMetadata);

		var convertedParsed = Json.parse(rawJson);

		var convertedJson:Array<{
			var t:Int;
			var d:Int;
			@:optional var l:Int;
		}> = Reflect.getProperty(convertedParsed.notes, diff); // im not doin all that

		if(convertedJson == null)
			return null;

		var convertedEvents:Array<{
			var t:Int;
			var e:String;
			var v:Dynamic;
		}> = convertedParsed.events;

		var scrollSpeed:Null<Float> = 1;

		scrollSpeed = Reflect.getProperty(convertedParsed.scrollSpeed, diff);
		
		if(scrollSpeed == null)
			scrollSpeed = Reflect.getProperty(convertedParsed.scrollSpeed, 'default');

		if(scrollSpeed == null)
			scrollSpeed = 1;

		var actualSong:SwagSong = {
			song: convertedMetadata.songName,
			notes: song,
			bpm: convertedMetadata.timeChanges[0].bpm,
			needsVoices: true,
			player1: convertedMetadata.playData.characters.player,
			player2: convertedMetadata.playData.characters.opponent,
			player3: convertedMetadata.playData.characters.girlfriend,
			stage: convertedMetadata.playData.stage,
			speed: scrollSpeed
		};

		var crochet:Float = (((60 / actualSong.bpm) * 1000) / 4) * 16;
		var crochetLimit:Float = crochet;

		var curSection:Int = 0;
		var camOnBF:Bool = true;
		for(note in convertedJson)
		{
			while (note.t >= crochetLimit)
			{
				for(event in convertedEvents)
				{
					if((event.t >= crochetLimit - crochet && event.t <= crochetLimit) && event.e == 'FocusCamera')
						camOnBF = (event.v.char == 0);
				}

				crochetLimit += crochet;
				curSection++;
			}

			if(song[curSection] == null)
			{
				song[curSection] = {
					lengthInSteps: 16,
					bpm: actualSong.bpm,
					changeBPM: false,
					mustHitSection: camOnBF,
					sectionNotes: [],
					typeOfSection: 0,
					altAnim: false
				};
			}

			var daArray:Array<Dynamic> = [note.t];

			if(camOnBF)
				daArray.push(note.d);
			else
			{
				var direction:Int = (note.d + 4) % 8;

				daArray.push(direction);
			}

			if(note.l != null) 
				daArray.push(note.l);
			else
				daArray.push(0);

			song[curSection].sectionNotes.push(daArray);
		}

		return actualSong;
	}
}

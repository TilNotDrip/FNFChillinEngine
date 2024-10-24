package funkin.structures;

/**
 * LEGACY
 */
// ==============================

/**
 * The... song...
 */
typedef LegacySong =
{
	var song:LegacyChartStructure;
}

/**
 * Legacy Chart Structure, too lazy to add documentation to these, figure it out yourself lmao
 */
typedef LegacyChartStructure =
{
	/**
	 * idk burppppppppppppppp
	 */
	var song:String;

	/**
	 * idk burppppppppppppppp
	 */
	@:default([])
	var notes:Array<LegacySectionStructure>;

	/**
	 * idk burppppppppppppppp
	 */
	@:default(150)
	var bpm:Float;

	/**
	 * idk burppppppppppppppp
	 */
	@:default(true)
	var needsVoices:Bool;

	/**
	 * idk burppppppppppppppp
	 */
	@:default(1)
	var speed:Float;

	/**
	 * idk burppppppppppppppp
	 */
	@:default('bf')
	var player1:String;

	/**
	 * idk burppppppppppppppp
	 */
	@:default('dad')
	var player2:String;

	/**
	 * idk burppppppppppppppp
	 */
	@:default('gf')
	var player3:String;

	/**
	 * idk burppppppppppppppp
	 */
	@:default('stage') // accomodate older chart that had stages based on the song.
	var stage:String;

	// GOTTA MAKE SURE. (variables we have in other mods, or stuff people have in other engines)
	@:optional
	var credits:SongCredits; // snc credits
}

/**
 * Legacy Section Structure, too lazy to add documentation to these.
 */
typedef LegacySectionStructure =
{
	@:jcustomparse(funkin.data.json2object.DataParse.jsonArrayToLegacyNotes)
	var sectionNotes:Array<Dynamic>;
	var lengthInSteps:Int;
	var typeOfSection:Int;
	var mustHitSection:Bool;
	var bpm:Float;
	var changeBPM:Bool;
	var altAnim:Bool;

	@:optional
	@:default(false)
	var gfSection:Bool;
}

/**
 * V-SLICE
 */
// ==============================
typedef VSliceNoteStructure =
{
	/**
	 * The timestamp of the note. The timestamp is in the format of the song's time format.
	 */
	@:alias("t")
	public var time:Float;

	/**
	 * Data for the note. Represents the index on the strumline.
	 * 0 = left, 1 = down, 2 = up, 3 = right
	 * `floor(direction / strumlineSize)` specifies which strumline the note is on.
	 * 0 = player, 1 = opponent, etc.
	 */
	@:alias("d")
	public var data:Int;

	/**
	 * Length of the note, if applicable.
	 * Defaults to 0 for single notes.
	 */
	@:alias("l")
	@:default(0)
	@:optional
	public var length:Float;

	/**
	 * The kind of the note.
	 * This can allow the note to include information used for custom behavior.
	 * Defaults to `null` for no kind.
	 */
	@:alias("k")
	@:optional
	@:isVar
	public var kind:Null<String>;
}

typedef VSliceEventStructure =
{
	/**
	 * The timestamp of the event. The timestamp is in the format of the song's time format.
	 */
	@:alias("t")
	public var time:Float;

	/**
	 * The kind of the event.
	 * Examples include "FocusCamera" and "PlayAnimation"
	 * Custom events can be added by scripts with the `ScriptedSongEvent` class.
	 */
	@:alias("e")
	public var eventKind:String;

	/**
	 * The data for the event.
	 * This can allow the event to include information used for custom behavior.
	 * Data type depends on the event kind. It can be anything that's JSON serializable.
	 */
	@:alias("v")
	@:optional
	public var value:Dynamic;
}

typedef VSliceMetadataStructure =
{
	@:default("Unknown")
	var songName:String;
	@:default("Unknown")
	var artist:String;
	@:optional
	var charter:Null<String>;
	@:optional
	@:default(96)
	var divisions:Null<Int>; // Optional field
	@:optional
	@:default(false)
	var looped:Bool;

	/**
	 * Data relating to the song's gameplay.
	 */
	var playData:
		{
			/**
			 * The variations this song has. The associated metadata files should exist.
			 */
			@:default([])
			@:optional
			public var songVariations:Array<String>;
			/**
			 * The difficulties contained in this song's chart file.
			 */
			public var difficulties:Array<String>;
			/**
			 * The characters used by this song.
			 */
			public var characters:
				{
					@:optional
					@:default('')
					public var player:String;
					@:optional
					@:default('')
					public var girlfriend:String;
					@:optional
					@:default('')
					public var opponent:String;
					@:optional
					@:default('')
					public var instrumental:String;
					@:optional
					@:default([])
					public var altInstrumentals:Array<String>;
				};
			/**
			 * The stage used by this song.
			 */
			public var stage:String;
			/**
			 * The note style used by this song.
			 */
			public var noteStyle:String;
			/**
			 * The difficulty ratings for this song as displayed in Freeplay.
			 * Key is a difficulty ID.
			 */
			@:optional
			@:default(['normal' => 0])
			public var ratings:Map<String, Int>;
			/**
			 * The album ID for the album to display in Freeplay.
			 * If `null`, display no album.
			 */
			@:optional
			public var album:Null<String>;
			/**
			 * The start time for the audio preview in Freeplay.
			 * Defaults to 0 seconds in.
			 * @since `2.2.2`
			 */
			@:optional
			@:default(0)
			public var previewStart:Int;
			/**
			 * The end time for the audio preview in Freeplay.
			 * Defaults to 15 seconds in.
			 * @since `2.2.2`
			 */
			@:optional
			@:default(15000)
			public var previewEnd:Int;
		};

	/**
	 * Data relating to the song's gameplay.
	 */
	var timeChanges:Array<
		{
			/**
			 * Timestamp in specified `timeFormat`.
			 */
			@:alias("t")
			public var timeStamp:Float;
			/**
			 * Time in beats (int). The game will calculate further beat values based on this one,
			 * so it can do it in a simple linear fashion.
			 */
			@:optional
			@:alias("b")
			public var beatTime:Float;
			/**
			 * Quarter notes per minute (float). Cannot be empty in the first element of the list,
			 * but otherwise it's optional, and defaults to the value of the previous element.
			 */
			@:alias("bpm")
			public var bpm:Float;
			/**
			 * Time signature numerator (int). Optional, defaults to 4.
			 */
			@:default(4)
			@:optional
			@:alias("n")
			public var timeSignatureNum:Int;
			/**
			 * Time signature denominator (int). Optional, defaults to 4. Should only ever be a power of two.
			 */
			@:default(4)
			@:optional
			@:alias("d")
			public var timeSignatureDen:Int;
			/**
			 * Beat tuplets (Array<int> or int). This defines how many steps each beat is divided into.
			 * It can either be an array of length `n` (see above) or a single integer number.
			 * Optional, defaults to `[4]`.
			 */
			@:optional
			@:alias("bt")
			public var beatTuplets:Array<Int>;
		}>;
}

// i am so sorry for the comments, it is 1:39 for Til and 3:39 for crusher.

typedef ChillinChartJson =
{
	var charts:Array<ChillinChartArrayElement>;

	@:default(funkin.util.Constants.VERSION_CHART)
	var version:String;
}

typedef ChillinEventsJson =
{
	var events:Array<ChillinEvent>;

	@:default(funkin.util.Constants.VERSION_SONG_EVENTS)
	var version:String;
}

/**
 * That FUCKING oughhhhh~~~~~~~ BIRD THAT I HATE
 */
typedef ChillinChartArrayElement =
{
	/**
	 * The Difficulty of the chart.
	 */
	var difficulty:String;

	/**
	 * The Scroll Speed of the song.
	 */
	@:default(1)
	var speed:Float;

	/**
	 * The Rating of the song, this shows up in freeplay.
	 */
	@:default(0)
	var rating:Int;

	/**
	 * The actual chart.
	 */
	@:default([]) // fuck you smart guy
	var chart:Array<ChillinNote>;
}

typedef ChillinMetadata =
{
	/**
	 * The Characters in this song.
	 * This goes by Character Type to Character ID.
	 */
	@:default(['player' => 'bf', 'opponent' => 'dad', 'spectator' => 'gf'])
	var characters:Map<String, String>;

	/**
	 * The setting (stay in school kids) you are in. Are you in a street where two maniacs want to kill you? Sure bud, youre not pico fnf.
	 */
	@:default('mainStage')
	var stage:String;

	/**
	 * The audio preview. This plays if you hover over the song in freeplay.
	 */
	@:default({start: 0, end: 150000})
	var preview:
		{
			var start:Float;
			var end:Float;
		};

	@:default([{bpm: 100, time: 0, sectionSteps: 16}])
	var bpmChanges:Array<ChillinBPMChange>;

	var credits:SongCredits;
}

typedef ChillinEvent =
{
	/**
	 * The time that this event gets played on.
	 */
	var time:Float;

	/**
	 * The name of the event to play.
	 */
	var name:String;

	/**
	 * The arguments for the event. (If it requires it)
	 *
	 * An example of a Hey! argument
	 * ```json
	 * "args": [{"heyTimer": 1}]
	 * ```
	 */
	@:default([])
	@:jcustomparse(funkin.data.json2object.DataParse.jsonStringAnyMap)
	// TODO: add jcustomwrite for this
	var args:Map<String, Any>;
}

typedef ChillinBPMChange =
{
	/**
	 * The new bpm when this change is hit.
	 */
	var bpm:Float;

	/**
	 * The time that this bpm change gets played on.
	 */
	var time:Float;

	/**
	 * The amount of sections it changes to when this bpm change gets played on.
	 */
	var sectionSteps:Float; // making it float cuz some person is gonna complain. I WILL BLOW YOUR HOSUE UP BITHC FUCK YOU

	/**
	 * The time in beats. This is used internally to calculate beats after the change.
	 */
	@:optional
	@:default(0)
	var beatTime:Float;
}

typedef ChillinNote =
{
	/**
	 * The time the note will be hit.
	 */
	var time:Float;

	/**
	 * The direction that the note is facing.
	 */
	var direction:Int;

	/**
	 * The Type of the Note.
	 */
	@:default('')
	var type:String;

	/**
	 * The strum that the note shows up on.
	 */
	var strum:String;

	/**
	 * The *sus*tain length of the note.
	 * @see https://www.innersloth.com/games/among-us/
	 */
	@:optional
	var length:Float;
}

typedef SongCredits =
{
	/**
	 * The person that composed this song.
	 */
	@:default('Unknown')
	var composer:String;

	/**
	 * The person that charted this song.
	 */
	@:default('Unknown')
	var charter:String;
}

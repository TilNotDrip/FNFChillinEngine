package funkin.states.tools;

import funkin.structures.ChartStructures;

@:deprecated('This will soon be removed to be used in FunkinConverter. Also, just don\'t use it in general.')
class ConvertingSongs extends MusicBeatState
{
	#if sys
	static final STRUMLINE_SIZE:Int = 4;

	static var options:Array<String> = ["Legacy", "V-Slice"];

	public var curSelected:Int = 0;

	public var songs:Array<String>;
	public var curSong:Int = 0;
	public var songDetails:FlxText;

	override public function create():Void
	{
		songDetails = new FlxText(0, 0, FlxG.width);
		songDetails.setFormat(Paths.location.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER);
		songDetails.screenCenter();
		add(songDetails);

		super.create();

		songs = getSongs();

		changeSelection();
	}

	override public function update(elapsed:Float):Void
	{
		if (controls.UI_LEFT_P)
			changeSelection(-1);
		else if (controls.UI_RIGHT_P)
			changeSelection(1);

		if (controls.ACCEPT)
		{
			switch (options[curSelected])
			{
				case 'Legacy':
					convertLegacySong();
			}
		}

		super.update();
	}

	public function changeSelection(?huh:Int = 0):Void
	{
		curSelected += huh;

		if (curSelected < 0)
			curSelected = options.length - 1;

		if (curSelected >= options.length)
			curSelected = 0;

		songDetails.text = '${songs[curSong]}\n<${options[curSelected]}>\nACCEPT to convert!';
	}

	public function getSongs():Array<String>
	{
		var queryPath:String = 'data/charts/';
		var results:Array<String> = [];
		for (path in Paths.location.list())
		{
			if (!queryPath.startsWith(path))
				continue;

			var pathNoPrefix:String = path.substring(queryPath.length);
			var pathNoSuffix:String = pathNoPrefix.substring(0, pathNoPrefix.indexOf('/'));

			if (!results.contains(pathNoSuffix))
				results.push(pathNoSuffix);
		}
	}

	public function convertLegacySong():Void
	{
		var queryPath:String = 'data/charts/${songs[curSong]}/';
		var difficulties:Array<String> = [];
		for (path in Paths.location.list())
		{
			if (!queryPath.startsWith(path))
				continue;

			var pathNoPrefix:String = path.substring(queryPath.length);
			var pathNoSuffix:String = pathNoPrefix.substring(0, pathNoPrefix.indexOf('.json'));

			if (pathNoSuffix.startsWith('${songs[curSong]}-'))
				pathNoSuffix = pathNoPrefix.substring(pathNoPrefix.indexOf('${songs[curSong]}-'));

			if (pathNoSuffix == 'events') // must be my old crappy events!
			{
				hasEvents = true;
				continue;
			}

			if (!results.contains(pathNoSuffix))
				results.push(pathNoSuffix);
		}

		var events:Array<ChillinEvent> = [];
		var defaultDifficulty:Bool = 'normal';

		for (difficulty in results)
		{
			var chart:ChillinChartArrayElement;
			var metadata:ChillinMetadata;
			var events:Array<ChillinEvent> = [];

			var legacyChartTxt:String = '';
			if (Paths.location.exists(queryPath + difficulty + '.json', null, TEXT))
				legacyChartTxt = Paths.content.json(queryPath + difficulty);
			else
				legacyChartTxt = Paths.content.json(queryPath + songs[curSong] + '-' + difficulty);

			var legacyChart:LegacyChartStructure = (cast new JsonParser<LegacySong>().fromJson(legacyChartTxt)).song;

			var notes:Array<ChillinNote> = [];

			var bpmArray:Array<ChillinBPMChange> = [{time: 0, bpm: legacyChart.bpm, sectionSteps: 16}];
			var curBpmChange:ChillinBPMChange = bpmArray[0];
			var lastCamera:String = 'opponent';

			for (i => section in legacyChart.notes)
			{
				if (section == null || section.sectionNotes.length < 0)
					continue; // in case its a bad converter or smth

				var firstNote:Array<Dynamic> = section.sectionNotes[0];

				if (section.changeBPM)
				{
					curBpmChange = {
						time: firstNote[0],
						bpm: section.bpm,
						sectionSteps: section.lengthInSteps
					};
				}

				var curCamera:String = 'opponent';

				if (section.gfSection)
					curCamera = 'spectator';
				else if (section.mustHitSection)
					curCamera = 'player';

				if (curCamera != lastCamera)
				{
					events.push({
						name: 'camera-focus',
						args: ['focus' => curCamera, 'tween' => 'lerp', 'time' => 0],
						time: firstNote[0]
					});
				}

				for (note in section.sectionNotes)
				{
					var direction:Int = note[1];
					var strum:String = '';
					var type:String = '';

					if (direction < 0)
					{
						var value1:String = note[3];
						var value2:String = note[4];
						switch (note[2]) // TODO: add more of these (snc ones maybe wink wink)
						{
							default:
								events.push({
									name: note[2].formatToPath(),
									args: ['value1' => value1, 'value2' => value2],
									time: note[0]
								});
						}

						continue;
					}

					if (direction > (STRUMLINE_SIZE * 2))
						direction = direction % (2 * STRUMLINE_SIZE); // if someone decides to play smart

					if (!section.mustHitSection)
					{
						if (direction >= STRUMLINE_SIZE)
							direction -= STRUMLINE_SIZE;
						else
							direction += STRUMLINE_SIZE;
					}

					if (direction >= STRUMLINE_SIZE)
						strum = 'player';
					else
						strum = 'opponent';

					if (section.gfSection)
						strum = 'spectator';

					if (note[3] is String) // hi psych engine
					{
						type = note[3];

						// cool string manipulation
						var splitType:Array<String> = type.formatToPath().split('-');
						while (splitType.contains('note'))
							splitType.remove(splitType.indexOf('note'));

						type = splitType.join('-');
					}
					else if (note[3] is Bool)
						type = note[3] ? 'alt' : '';

					notes.push({
						time: note[0],
						direction: direction % STRUMLINE_SIZE,
						type: type,
						strum: strum,
						length: note[2]
					});
				}
			}
		}
	}
	#end
}

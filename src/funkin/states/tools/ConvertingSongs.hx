package funkin.states.tools;

import funkin.structures.ChartStructures;

@:deprecated('This will soon be removed to be used in FunkinConverter')
class ConvertingSongs extends MusicBeatState
{
	#if sys
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

		for (difficulty in results)
		{
			var chart:ChillinChartArrayElement;
			var metadata:ChillinMetadata;

			var legacyChartTxt:String = '';
			if (Paths.location.exists(queryPath + difficulty + '.json', null, TEXT))
				legacyChartTxt = Paths.content.json(queryPath + difficulty);
			else
				legacyChartTxt = Paths.content.json(queryPath + '${songs[curSong]}-' + difficulty);

			var legacyChart:LegacyChartStructure = (cast new JsonParser<LegacySong>().fromJson(legacyChartTxt)).song;

			var bpmArray:Array<SwagBPMChange> = [{time: 0, bpm: convertedJson.bpm, sectionSteps: 16}];
			var curBPMChange:SwagBPMChange = bpmArray[0];
			daBPMArray.push(curBPMChange);
		}
	}
	#end
}

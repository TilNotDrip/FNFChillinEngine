package funkin.util;

import funkin.data.IRegistryEntry;
import funkin.structures.ChartStructures;
import funkin.data.registry.SongRegistry;

class NewSong implements IRegistryEntry<ChillinMetadata>
{
	public final id:String;

	public final _data:ChillinMetadata;

	/**
	 * Every Metadata for this Song, excluding default.
	 * 
	 * `variationID` -> `ChillinMetadata`
	 */
	final _extraMetadata:Map<String, ChillinMetadata>;

	/**
	 * Every Chart for this Song.
	 * 
	 * `variationID-difficultyID` -> `ChillinChartArrayElement`
	 */
	final _chartData:Map<String, ChillinChartArrayElement>;

	/**
	 * Every Event Array for this Song.
	 * 
	 * `variationID` -> `Array<ChillinEvent>`
	 */
	final _eventData:Map<String, Array<ChillinEvent>>;

	public function new(id:String)
	{
		this.id = id;

		_extraMetadata = new Map<String, ChillinMetadata>();
		_chartData = new Map<String, ChillinChartArrayElement>();
		_eventData = new Map<String, Array<ChillinEvent>>();

		for (variation in getVariations())
		{
			var metadataVersion = SongRegistry.instance.fetchMetadataVersion(id, variation);
			var loadedMetadata:ChillinMetadata = SongRegistry.instance.parseMetadataWithMigration(id, variation, metadataVersion);

			if (variation == Constants.DEFAULT_VARIATION)
				_data = loadedMetadata;
			else
				_extraMetadata.set(variation, loadedMetadata);

			var chartVersion = SongRegistry.instance.fetchSongChartVersion(id, variation);
			var loadedCharts:Array<ChillinChartArrayElement> = SongRegistry.instance.parseSongChartWithMigration(id, variation, chartVersion).charts;

			for (chart in loadedCharts)
				_chartData.set('${variation}-${chart.difficulty}', chart);

			var eventsVersion = SongRegistry.instance.fetchSongEventsVersion(id, variation);
			var loadedEvents:Array<ChillinEvent> = SongRegistry.instance.parseSongEventsWithMigration(id, variation, eventsVersion).events;

			_eventData.set(variation, loadedEvents);
		}
	}

	public function destroy():Void
	{
		_extraMetadata.clear();
		_chartData.clear();
		_eventData.clear();
	}

	public function toString():String
	{
		return 'Song($id, ${getVariations()})';
	}

	var _variations:Array<String>;

	/**
	 * Get all of the variations for this Song.
	 * @return The variations.
	 */
	public function getVariations():Array<String>
	{
		if (_variations != null)
			return _variations;

		_variations = [Constants.DEFAULT_VARIATION];

		@:privateAccess var queryPath = 'gameplay/' + SongRegistry.instance.dataFilePath + '/' + id;
		var textAssets:Array<String> = Paths.location.list(queryPath);
		var fileSuffix:String = 'metadata.json';

		for (file in textAssets)
		{
			if (!file.endsWith(fileSuffix))
				continue;

			var fileWithoutSuffix:String = file.substring((queryPath + '/').length, file.lastIndexOf(fileSuffix));

			if (fileWithoutSuffix == '') // default
				continue;

			var variation:String = fileWithoutSuffix.substring(0, file.indexOf('-'));
			_variations.push(variation);
		}

		return _variations;
	}
}

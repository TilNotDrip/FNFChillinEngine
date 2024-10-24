package funkin.util;

import funkin.data.IRegistryEntry;
import funkin.structures.ChartStructures;

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

		for (variation in getVariations())
		{
			if (variation == Constants.DEFAULT_VARIATION)
				_data = SongRegistry.instance.parseMetadataWithMigration(id, variation);
		}
	}

	public function destroy():Void
	{
		// TODO: make stuff happen here
	}

	public function toString():String
	{
		return 'Song($id)';
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

		var textAssets:Array<String> = Paths.location.list();
		@:privateAccess var queryPath = 'data/' + SongRegistry.instance.dataFilePath + '/' + id + '/';
		var fileSuffix:String = 'metadata.json';

		for (file in textAssets)
		{
			if (!file.startsWith(queryPath) || !file.endsWith(fileSuffix))
				continue;

			var fileWithoutSuffix:String = file.substring(queryPath.length, file.lastIndexOf(fileSuffix));

			if (fileWithoutSuffix == '') // default
				continue;

			var variation:String = fileWithoutSuffix.substring(0, file.indexOf('-'));
			_variations.push(variation);
		}

		return _variations;
	}
}

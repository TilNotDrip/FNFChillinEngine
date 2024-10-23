package funkin.data.registry;

import funkin.structures.ChartStructures;

class SongRegistry extends BaseRegistry<NewSong, ChillinMetadata>
{
	public static var instance(get, never):SongRegistry;
	static var _instance:Null<SongRegistry> = null;

	static function get_instance():SongRegistry
	{
		if (_instance == null)
			_instance = new SongRegistry();
		return _instance;
	}

	public function new()
	{
		super('SONG', 'charts'); // No version rule here, because there are 3 different ones!
	}

	override public function loadEntryStructures():Void {} // we dont need this, because songs load it themselves!

	public function parseMetadataWithMigration(id:String, variation:String, version:Null<thx.semver.Version>):ChillinMetadata
	{
		if (version == null)
		{
			throw '[${registryID}] Metadata ${id} (${variation}) could not be JSON-parsed or does not have a parseable version.';
		}

		var versionRule = Constants.VERSION_SONG_METADATA_RULE;

		if (VersionUtil.validateVersion(version, versionRule))
		{
			return parseMetadata(id, variation);
		}
		else
		{
			throw '[${registryID}] Metadata ${id} (${variation}) does not support migration to version ${versionRule}.';
		}
	}

	public function parseMetadata(id:String, variation:String):Null<ChillinMetadata>
	{
		var parser = new json2object.JsonParser<ChillinMetadata>();

		parser.fromJson(loadSongMetadataFile(id, variation));

		if (parser.errors.length > 0)
		{
			// TODO: Add printErrors
			// printErrors(parser.errors, id);
			return null;
		}
		return parser.value;
	}

	public function fetchMetadataVersion(id:String, variation:String):Null<thx.semver.Version>
	{
		var entryStr:String = loadSongMetadataFile(id, variation);
		var entryVersion:thx.semver.Version = VersionUtil.getVersionFromJSON(entryStr);
		return entryVersion;
	}

	function loadSongMetadataFile(id:String, variation:String):String
	{
		var rawJson:String = Paths.content.json('data/${dataFilePath}/${id}/${variation == Constants.DEFAULT_VARIATION ? '' : '$variation-'}metadata').trim();
		return rawJson;
	}

	public function parseSongChartWithMigration(id:String, variation:String, version:Null<thx.semver.Version>):ChillinMetadata
	{
		if (version == null)
		{
			throw '[${registryID}] Chart ${id} (${variation}) could not be JSON-parsed or does not have a parseable version.';
		}

		var versionRule = Constants.VERSION_CHART_RULE;

		if (VersionUtil.validateVersion(version, versionRule))
		{
			return parseSongChart(id, variation);
		}
		else
		{
			throw '[${registryID}] Chart ${id} (${variation}) does not support migration to version ${versionRule}.';
		}
	}

	public function parseSongChart(id:String, variation:String):Null<ChillinChartJson>
	{
		var parser = new json2object.JsonParser<ChillinChartJson>();

		parser.fromJson(loadSongChartFile(id, variation));

		if (parser.errors.length > 0)
		{
			// TODO: Add printErrors
			// printErrors(parser.errors, id);
			return null;
		}
		return parser.value;
	}

	public function fetchSongChartVersion(id:String, variation:String):Null<thx.semver.Version>
	{
		var entryStr:String = loadSongChartFile(id, variation);
		var entryVersion:thx.semver.Version = VersionUtil.getVersionFromJSON(entryStr);
		return entryVersion;
	}

	function loadSongChartFile(id:String, variation:String):String
	{
		var rawJson:String = Paths.content.json('data/${dataFilePath}/${id}/${variation == Constants.DEFAULT_VARIATION ? '' : '$variation-'}chart').trim();
		return rawJson;
	}

	public function parseSongEventsWithMigration(id:String, variation:String, version:Null<thx.semver.Version>):ChillinMetadata
	{
		if (version == null)
		{
			throw '[${registryID}] Events ${id} (${variation}) could not be JSON-parsed or does not have a parseable version.';
		}

		var versionRule = Constants.VERSION_SONG_EVENTS_RULE;

		if (VersionUtil.validateVersion(version, versionRule))
		{
			return parseSongEvents(id, variation);
		}
		else
		{
			throw '[${registryID}] Events ${id} (${variation}) does not support migration to version ${versionRule}.';
		}
	}

	public function parseSongEvents(id:String, variation:String):Null<ChillinEventsJson>
	{
		var parser = new json2object.JsonParser<ChillinEventsJson>();

		parser.fromJson(loadSongEventsFile(id, variation));

		if (parser.errors.length > 0)
		{
			// TODO: Add printErrors
			// printErrors(parser.errors, id);
			return null;
		}
		return parser.value;
	}

	public function fetchSongEventsVersion(id:String, variation:String):Null<thx.semver.Version>
	{
		var entryStr:String = loadSongEventsFile(id, variation);
		var entryVersion:thx.semver.Version = VersionUtil.getVersionFromJSON(entryStr);
		return entryVersion;
	}

	function loadSongEventsFile(id:String, variation:String):String
	{
		var rawJson:String = Paths.content.json('data/${dataFilePath}/${id}/${variation == Constants.DEFAULT_VARIATION ? '' : '$variation-'}events').trim();
		return rawJson;
	}

	public function getJsonParser():Dynamic
	{
		return null; // we dont need it
	}
}

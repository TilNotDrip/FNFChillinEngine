package funkin.data;

import funkin.util.VersionUtil;

/**
 * Backend of BaseRegistry, which loads entry data. Can also be used as it's own.
 * @param J The type of the JSON data used when constructing.
 */
abstract class BaseDataRegistry<J>
{
	/**
	 * The ID of the registry. Used when logging.
	 */
	public final registryID:String;

	/**
	 * Where to search for JSON files in `assets/data/`. These will be converted to entries.
	 */
	var dataFilePath:String;

	/**
	 * A map of entry IDs to entry data.
	 */
	var entryData:Map<String, J>;

	/**
	 * The version rule to use when loading entries.
	 * If the entry's version does not match this rule, migration is needed.
	 */
	final versionRule:thx.semver.VersionRule;

	/**
	 * @param registryId A readable ID for this registry, used when logging.
	 * @param dataFilePath The path to search for JSON files.
	 */
	public function new(registryID:String, dataFilePath:String, ?versionRule:thx.semver.VersionRule)
	{
		this.registryID = registryID;
		this.dataFilePath = dataFilePath;
		this.versionRule = versionRule == null ? '1.0.x' : versionRule;

		this.entryData = new Map<String, J>();

		// Lazy initialization of singletons should let this get called,
		// but we have this check just in case.
		if (FlxG.game != null)
		{
			FlxG.console.registerObject('registry$registryID', this);
		}
	}

	public function loadEntries():Void
	{
		loadEntryStructures(); // Redirect, just to make life easier when switching between the two types.
	}

	function loadEntryStructures():Void
	{
		clearEntryStructures();

		var entryIdList:Array<String> = listIDs();
		log('Parsing ${entryIdList.length} entries...');
		for (entryId in entryIdList)
		{
			var data:J = parseEntryDataWithMigration(entryId, fetchEntryVersion(entryId));
			if (data != null)
			{
				log('Loaded entry data: $entryId');
				entryData.set(entryId, data);
			}
		}
	}

	function clearEntryStructures():Void
	{
		entryData.clear();
	}

	/**
	 * Fetch an entry data by its ID.
	 * @param id The ID of the entry to fetch.
	 * @return The entry data, or `null` if it does not exist.
	 */
	public function fetchEntryData(id:String):Null<J>
	{
		return entryData.get(id);
	}

	/**
	 * Lists all of the IDs that should be loaded into the registry.
	 * Override this to add your own IDs to load.
	 * @return List of IDs.
	 */
	public function listIDs():Array<String>
	{
		var textAssets = Paths.location.list();

		var queryPath = 'data/' + dataFilePath + '/';

		var results:Array<String> = [];
		for (textPath in textAssets)
		{
			if (textPath.startsWith(queryPath) && textPath.endsWith('.json'))
			{
				var pathNoSuffix = textPath.substring(0, textPath.length - '.json'.length);
				var pathNoPrefix = pathNoSuffix.substring(queryPath.length);

				results.push(pathNoPrefix);
			}
		}

		return results;
	}

	/**
	 * Get the json parser to use for entries.
	 * This needs to exist because JsonParser doesn't take type parameters.
	 * @return The json parser.
	 */
	public abstract function getJsonParser():Dynamic;

	/**
	 * Retrieve the data for an entry and parse its Semantic Version.
	 * @param id The ID of the entry.
	 * @return The entry's version, or `null` if it does not exist or is invalid.
	 */
	public function fetchEntryVersion(id:String):Null<thx.semver.Version>
	{
		var entryStr:String = loadEntryFile(id);
		var entryVersion:thx.semver.Version = VersionUtil.getVersionFromJSON(entryStr);
		return entryVersion;
	}

	function loadEntryFile(id:String):String
	{
		var rawJson:String = Paths.content.json('data/${dataFilePath}/${id}').trim();
		return rawJson;
	}

	/**
	 * Read, parse, and validate the JSON data and produce the corresponding data object.
	 *
	 * NOTE: Must be implemented on the implementation class.
	 * @param id The ID of the entry.
	 * @return The created entry.
	 */
	public function parseEntryData(id:String):Null<J>
	{
		// JsonParser does not take type parameters,
		// otherwise this function wouldn't exist.
		var parser = getJsonParser();

		parser.fromJson(loadEntryFile(id));

		if (parser.errors.length > 0)
		{
			// TODO: Add printErrors
			// printErrors(parser.errors, id);
			return null;
		}
		return parser.value;
	}

	/**
	 * Parse and validate the JSON data and produce the corresponding data object.
	 *
	 * NOTE: Must be implemented on the implementation class.
	 * @param contents The JSON as a string.
	 * @param fileName An optional file name for error reporting.
	 * @return The created entry.
	 */
	public function parseEntryDataRaw(contents:String, ?fileName:String):Null<J>
	{
		// JsonParser does not take type parameters,
		// otherwise this function wouldn't exist.
		var parser = getJsonParser();

		parser.fromJson(contents, fileName);

		if (parser.errors.length > 0)
		{
			// TODO: Add printErrors
			// printErrors(parser.errors, id);
			return null;
		}
		return parser.value;
	}

	/**
	 * Read, parse, and validate the JSON data and produce the corresponding data object,
	 * accounting for old versions of the data.
	 *
	 * NOTE: Extend this function to handle migration.
	 * @param id The ID of the entry.
	 * @param version The entry's version (use `fetchEntryVersion(id)`).
	 * @return The created entry.
	 */
	public function parseEntryDataWithMigration(id:String, version:Null<thx.semver.Version>):Null<J>
	{
		if (version == null)
		{
			throw '[${registryID}] Entry ${id} could not be JSON-parsed or does not have a parseable version.';
		}

		// If a version rule is not specified, do not check against it.
		if (versionRule == null || VersionUtil.validateVersion(version, versionRule))
		{
			return parseEntryData(id);
		}
		else
		{
			throw '[${registryID}] Entry ${id} does not support migration to version ${versionRule}.';
		}

		/*
		 * An example of what you should override this with:
		 *
		 * ```haxe
		 * if (VersionUtil.validateVersion(version, "0.1.x")) {
		 *   return parseEntryData_v0_1_x(id);
		 * } else {
		 *   super.parseEntryDataWithMigration(id, version);
		 * }
		 * ```
		 */

		return null;
	}

	inline function log(message:String):Void
	{
		trace('[' + registryID + '] ' + message);
	}
}

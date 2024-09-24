package funkin.data;

import haxe.Constraints.Constructible;
import funkin.util.VersionUtil;

/**
 * The entry's constructor function must take a single argument, the entry's ID.
 */
typedef EntryConstructorFunction = String->Void;

/**
 * A base type for a Registry, which is an object which handles loading scriptable objects.
 *
 * @param T The type to construct. Must implement `IRegistryEntry`.
 * @param J The type of the JSON data used when constructing.
 */
@:generic
abstract class BaseRegistry<T:(IRegistryEntry<J> & Constructible<EntryConstructorFunction>), J>
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
	 * A map of entry IDs to entries.
	 */
	var entries:Map<String, T>;

	/**
	 * A map of entry IDs to scripted class names.
	 */
	final scriptedEntryIds:Map<String, String>;

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

		this.entries = new Map<String, T>();
		this.scriptedEntryIds = [];

		// Lazy initialization of singletons should let this get called,
		// but we have this check just in case.
		if (FlxG.game != null)
		{
			FlxG.console.registerObject('registry$registryID', this);
		}
	}

	public function loadEntries():Void
	{
		clearEntries();

		//
		// SCRIPTED ENTRIES
		//
		// TODO: Implement scripted entry ids.
		/*
			var scriptedEntryClassNames:Array<String> = getScriptedClassNames();
			log('Parsing ${scriptedEntryClassNames.length} scripted entries...');

			for (entryCls in scriptedEntryClassNames)
			{
				var entry:Null<T> = null;
				try
				{
					entry = createScriptedEntry(entryCls);
				}
				catch (e)
				{
					log('Failed to create scripted entry (${entryCls})');
					continue;
				}

				if (entry != null)
				{
					log('Successfully created scripted entry (${entryCls} = ${entry.id})');
					entries.set(entry.id, entry);
					scriptedEntryIds.set(entry.id, entryCls);
				}
				else
				{
					log('Failed to create scripted entry (${entryCls})');
				}
			}
		 */

		//
		// UNSCRIPTED ENTRIES
		//
		var entryIdList:Array<String> = listIDs();
		var unscriptedEntryIds:Array<String> = entryIdList.filter(function(entryId:String):Bool
		{
			return !entries.exists(entryId);
		});
		log('Parsing ${unscriptedEntryIds.length} unscripted entries...');
		for (entryId in unscriptedEntryIds)
		{
			try
			{
				var entry:T = createEntry(entryId);
				if (entry != null)
				{
					log('Loaded entry data: ${entry}');
					entries.set(entry.id, entry);
				}
			}
			catch (e)
			{
				// Print the error.
				log('Failed to load entry data: ${entryId}');
				log(e.toString());
				continue;
			}
		}
	}

	function clearEntries():Void
	{
		for (entry in entries)
		{
			entry.destroy();
		}

		entries.clear();
	}

	/**
	 * Retrieve a list of all entry IDs in this registry.
	 * @return The list of entry IDs.
	 */
	public function listEntryIds():Array<String>
	{
		return entries.keyValues();
	}

	/**
	 * Count the number of entries in this registry.
	 * @return The number of entries.
	 */
	public function countEntries():Int
	{
		return listEntryIds().length;
	}

	/**
	 * Return whether the entry ID is known to have an attached script.
	 * @param id The ID of the entry.
	 * @return `true` if the entry has an attached script, `false` otherwise.
	 */
	public function isScriptedEntry(id:String):Bool
	{
		return scriptedEntryIds.exists(id);
	}

	/**
	 * Return the class name of the scripted entry with the given ID, if it exists.
	 * @param id The ID of the entry.
	 * @return The class name, or `null` if it does not exist.
	 */
	public function getScriptedEntryClassName(id:String):String
	{
		return scriptedEntryIds.get(id);
	}

	/**
	 * Return whether the registry has successfully parsed an entry with the given ID.
	 * @param id The ID of the entry.
	 * @return `true` if the entry exists, `false` otherwise.
	 */
	public function hasEntry(id:String):Bool
	{
		return entries.exists(id);
	}

	/**
	 * Fetch an entry by its ID.
	 * @param id The ID of the entry to fetch.
	 * @return The entry, or `null` if it does not exist.
	 */
	public function fetchEntry(id:String):Null<T>
	{
		return entries.get(id);
	}

	public function toString():String
	{
		return 'Registry(' + registryID + ', ${countEntries()} entries)';
	}

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

	//
	// FUNCTIONS TO IMPLEMENT
	//

	/**
	 * Get the json parser to use for entries.
	 * This needs to exist because JsonParser doesn't take type parameters.
	 * @return The json parser.
	 */
	public abstract function getJsonParser():Dynamic;

	/**
	 * Retrieve the list of scripted class names to load.
	 * @return An array of scripted class names.
	 */
	abstract function getScriptedClassNames():Array<String>;

	/**
	 * Create a entry, attached to a scripted class, from the given class name.
	 * @param clsName
	 */
	abstract function createScriptedEntry(clsName:String):Null<T>;

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

	function createEntry(id:String):Null<T>
	{
		// We enforce that T is Constructible to ensure this is valid.
		return new T(id);
	}

	inline function log(message:String):Void
	{
		trace('[' + registryID + '] ' + message);
	}
}

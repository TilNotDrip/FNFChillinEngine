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
abstract class BaseRegistry<T:(IRegistryEntry<J> & Constructible<EntryConstructorFunction>), J> extends BaseDataRegistry<J>
{
	/**
	 * A map of entry IDs to entries.
	 */
	var entries:Map<String, T>;

	/**
	 * A map of entry IDs to scripted class names.
	 */
	final scriptedEntryIds:Map<String, String>;

	/**
	 * @param registryId A readable ID for this registry, used when logging.
	 * @param dataFilePath The path to search for JSON files.
	 */
	public function new(registryID:String, dataFilePath:String, ?versionRule:thx.semver.VersionRule)
	{
		this.entries = new Map<String, T>();
		this.scriptedEntryIds = [];

		super();
	}

	override public function loadEntries():Void
	{
		clearEntries();
		super.loadEntries();

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
		var entryIdList:Array<String> = entryData.keyValues();
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

	//
	// FUNCTIONS TO IMPLEMENT
	//

	/**
	 * Get the json parser to use for entries.
	 * This needs to exist because JsonParser doesn't take type parameters.
	 * @return The json parser.
	 */
	override public abstract function getJsonParser():Dynamic;

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
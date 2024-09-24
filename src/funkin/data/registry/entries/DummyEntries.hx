package funkin.data.registry.entries;

import funkin.structures.CharacterStructure;

// DUMMY ENTRIES

/**
 * Dummy class for CharacterRegistry, because it handles entries differently.
 */
class DummyCharacterEntry implements IRegistryEntry<CharacterStructure>
{
	public final id:String;
	public final _data:CharacterStructure;

	public function destroy():Void {};

	public function toString():String
	{
		return id;
	};

	public function new(id:String)
	{
		this.id = id;
		_data = _fetchData(id);
	}

	/**
	 * Retrieve and parse the JSON data for a character by ID.
	 * @param id The ID of the character
	 * @return The parsed character data, or null if not found or invalid
	 */
	static function _fetchData(id:String):Null<CharacterStructure>
	{
		return CharacterRegistry.instance.parseEntryDataWithMigration(id, CharacterRegistry.instance.fetchEntryVersion(id));
	}
}

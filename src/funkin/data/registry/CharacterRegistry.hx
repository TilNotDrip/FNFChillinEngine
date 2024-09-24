package funkin.data.registry;

import funkin.objects.game.Character;
import funkin.data.registry.entries.DummyEntries.DummyCharacterEntry;
import funkin.structures.CharacterStructure;

class CharacterRegistry extends BaseRegistry<DummyCharacterEntry, CharacterStructure>
{
	public static var instance(get, never):CharacterRegistry;
	static var _instance:Null<CharacterRegistry> = null;

	static function get_instance():CharacterRegistry
	{
		if (_instance == null)
			_instance = new CharacterRegistry();
		return _instance;
	}

	public function new()
	{
		super('CHARACTER', 'characters', funkin.util.Constants.VERSION_CHARACTER_RULE);
	}

	public function fetchCharacter(id:String, ?isPlayer:Bool = false):Character
	{
		var character:Character = new Character(isPlayer);

		var data:CharacterStructure = fetchEntry(id)?._data ?? null;
		if (data == null && id != 'bf')
			return fetchCharacter('bf', isPlayer);
		else if (data == null)
			throw "Couldn't find a character to fall back to.";

		character.loadJson(id, data);
		return character;
	}

	public function getJsonParser():Dynamic
	{
		return new json2object.JsonParser<CharacterStructure>();
	}

	// FOR NOW.
	function getScriptedClassNames():Array<String>
	{
		return [];
	}

	function createScriptedEntry(clsName:String):DummyCharacterEntry
	{
		return new DummyCharacterEntry('');
	}
}

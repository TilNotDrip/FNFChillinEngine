package funkin.data.registry;

import funkin.objects.game.Character;
import funkin.structures.CharacterStructure;

class CharacterRegistry extends BaseDataRegistry<CharacterStructure>
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
		character.loadJson(fetchEntryData(id), data);
		return character;
	}

	override public function fetchEntryData(id):CharacterStructure
	{
		var data:CharacterStructure = super.fetchEntryData(id);

		if (data == null && id != 'bf')
			return fetchEntryData('bf');
		else if (data == null)
			throw "Character doesn't exist, and couldn't find a character to fall back to.";

		return data;
	}

	public function getJsonParser():Dynamic
	{
		return new json2object.JsonParser<CharacterStructure>();
	}
}

package funkin.objects.game;

import flixel.math.FlxPoint;
import haxe.Exception;
import funkin.data.registry.CharacterRegistry;
import funkin.objects.game.Character;
import funkin.structures.StageStructure;
import flixel.group.FlxSpriteGroup;
import json2object.JsonParser;

class Stage extends FlxSpriteGroup
{
	/**
	 * This stage's id.
	 *
	 * Used for loading and identifying stages.
	 */
	public var id:String = null;

	/**
	 * This stage's data.
	 */
	public var data:StageStructure = null;

	var characters:Map<String, Character> = new Map<String, Character>();
	var props:Map<String, FlxSprite> = new Map<String, FlxSprite>();

	/**
	 * Initializes and sets up the stage.
	 * @param id The stage id to load.
	 */
	public function new(id:String)
	{
		this.id = id;

		super(0, 0, 0);

		data = buildData(id);

		if (data != null)
		{
			buildStage();
		}
	}

	public function getNamedProp(name:String):FlxSprite
	{
		return props.get(name);
	}

	public function getIndexProp(index:Int):FlxSprite
	{
		return members[index];
	}

	public function getPlayer():Character
	{
		return characters.get('player');
	}

	public function getOpponent():Character
	{
		return characters.get('opponent');
	}

	public function getSpectator():Character
	{
		return characters.get('spectator');
	}

	function buildData(id:String):StageStructure
	{
		var data:StageStructure = null;

		try
		{
			data = cast new JsonParser<StageStructure>().fromJson(Paths.content.json('data/stages/' + id));
		}
		catch (e:Exception)
		{
			trace('[ERROR]: Could not load stage. ' + e);
		}

		return data;
	}

	function buildStage():Void
	{
		for (prop in data.props)
		{
			var propIsColorGraphic:Bool = prop.image.startsWith('#');
			var propIsAnimated:Bool = (!prop.image.startsWith('#') && prop.animations.length != 0);

			var object:FlxSprite = new FlxSprite(prop.position[0], prop.position[1]);

			if (propIsColorGraphic)
			{
				object.makeGraphic(Std.int(prop.scale[0]), Std.int(prop.scale[1]), FlxColor.fromString(prop.image));
			}
			else if (propIsAnimated)
			{
				object.frames = Paths.content.sparrowAtlas(prop.image);

				for (anim in prop.animations)
				{
					if (anim.indices.length != 0)
					{
						object.animation.addByIndices(anim.name, anim.prefix, anim.indices, '', anim.framerate, anim.flipX, anim.flipY);
					}
					else
					{
						object.animation.addByPrefix(anim.name, anim.prefix, anim.framerate, anim.flipX, anim.flipY);
					}
				}

				if (object.animation.exists('idle'))
				{
					object.animation.play('idle', true);
				}
			}
			else
			{
				object.loadGraphic(Paths.content.imageGraphic(prop.image));
			}

			object.scrollFactor.set(prop.scrollFactor[0], prop.scrollFactor[1]);

			if (!propIsColorGraphic)
			{
				object.scale.set(prop.scale[0], prop.scale[1]);
			}

			object.active = propIsAnimated;
			object.alpha = prop.alpha;
			object.antialiasing = (FunkinOptions.get('antialiasing')) ? prop.antialiasing : false;
			object.flipX = prop.flipX;
			object.flipY = prop.flipY;
			add(object);

			if (prop.name != null)
			{
				props.set(prop.name, object);
			}
		}
	}

	public function addCharacter(characterName:String, characterType:String, characterData:StageCharacterData, isPlayer:Bool):Void
	{
		if (characterData != null)
		{
			var character:Character = CharacterRegistry.instance.fetchCharacter(characterName, isPlayer);

			var characterPosition:FlxPoint = getCharacterPosition(character, characterData);

			character.setPosition(characterPosition.x, characterPosition.y);
			character.alpha = data.characters.spectator.alpha;
			character.scrollFactor.set(data.characters.spectator.scrollFactor[0], data.characters.spectator.scrollFactor[1]);
			character.dance();
			character.animation.finish();
			add(character);

			characters.set(characterType, character);
		}
	}

	function getCharacterPosition(characterObject:Character, characterData:StageCharacterData):FlxPoint
	{
		var xPos:Float = 0;

		switch (characterData.positioning.x)
		{
			case LEFT:
				xPos = characterData.position[0];

			case CENTER:
				xPos = characterData.position[0] + (characterObject.width / 2);

			case RIGHT:
				xPos = characterData.position[0] + (characterObject.width);
		}

		var yPos:Float = 0;

		switch (characterData.positioning.y)
		{
			case TOP:
				yPos = characterData.position[1];

			case CENTER:
				yPos = characterData.position[1] + (characterObject.height / 2);

			case BOTTOM:
				yPos = characterData.position[1] + (characterObject.height);
		}

		return new FlxPoint(xPos, yPos);
	}
}

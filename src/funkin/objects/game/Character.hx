package funkin.objects.game;

import funkin.structures.CharacterStructure;
import funkin.util.SongEvent.SwagEvent;
// import funkin.util.VersionUtil;
import flixel.math.FlxPoint;
import flixel.util.FlxSort;
import haxe.Json;
import openfl.utils.Assets;
import json2object.JsonParser;
import thx.semver.VersionRule;

class Character extends FlxSprite
{
	public var characterData:CharacterStructure;

	public var curCharacter:String = 'bf';

	public var deathChar:String = 'bf-dead';

	public var characterPosition:Array<Float> = [0.0, 0.0];

	public var cameraPosition:Array<Float> = [0.0, 0.0];

	public var danceEvery:Float = 2.0;

	public var singTime:Float = 4.0;

	public var healthIcon:String = 'face';

	public var ui:String = 'funkin';

	public var animOffsets:Map<String, Array<Float>> = new Map();

	public var isPlayer:Bool = false;

	public var holdTimer:Float = 0;

	public var heyTimer:Float = 0;

	public var debugMode:Bool = false;

	public var isDead:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		curCharacter = character;
		this.isPlayer = isPlayer;

		loadJson(character);

		if (isPlayer)
			flipX = !flipX;
	}

	function loadJson(character:String):Void
	{
		var assetChar:String = character;

		if (!Paths.exists('data/characters/$assetChar.json', null, TEXT))
		{
			curCharacter = 'bf';
			assetChar = 'bf';
		}

		var characterParser = new JsonParser<CharacterStructure>();
		characterData = cast characterParser.fromJson(Assets.getText(Paths.json('data/characters/$assetChar')));

		if (characterData != null)
		{
			/*
				if (!VersionUtil.validateVersion(characterData.version, funkin.util.constants.VersionConstants.CHARACTER_VERSION_RULE))
					return; */

			frames = Paths.getSparrowAtlas(characterData.image);

			for (anim in characterData.animations)
			{
				if (anim.indices.length != 0)
					animation.addByIndices(anim.name, anim.prefix, anim.indices, '', anim.framerate, anim.looped, anim.flipX, anim.flipY);
				else
					animation.addByPrefix(anim.name, anim.prefix, anim.framerate, anim.looped, anim.flipX, anim.flipY);

				addOffset(anim.name, anim.offsets[0], anim.offsets[1]);
			}

			antialiasing = (FunkinOptions.get('antialiasing') ? characterData.antialiasing : false);
			flipX = characterData.flipX;
			flipY = characterData.flipY;
			scale.set(characterData.scale[0], characterData.scale[1]);
			updateHitbox();

			// Gameplay
			characterPosition = characterData.gameplay.position;
			cameraPosition = characterData.gameplay.camera_position;
			danceEvery = characterData.gameplay.danceEvery;
			singTime = characterData.gameplay.singTime;
			deathChar = characterData.gameplay.deathChar;
			healthIcon = characterData.gameplay.healthIcon;
			ui = characterData.gameplay.ui;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (animation?.curAnim?.name?.startsWith('sing'))
			holdTimer += elapsed;

		if (heyTimer > 0)
			heyTimer -= elapsed;

		if ((!isPlayer && PlayState.botplayDad) || (isPlayer && PlayState.botplay))
		{
			if (holdTimer >= Conductor.stepCrochet * singTime * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}
		else
		{
			if (!animation?.curAnim?.name?.startsWith('sing') && animation?.curAnim?.finished)
				holdTimer = 0;

			if (animation?.curAnim?.name?.endsWith('miss') && animation?.curAnim?.finished && !debugMode)
				playAnim(getIdleAnimation(), true, false, 10);
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation?.curAnim?.name == 'hairFall' && animation?.curAnim?.finished)
					dance();
		}
	}

	var danced:Bool = false;

	public function dance():Void
	{
		if (!debugMode && !isDead && heyTimer <= 0)
		{
			danced = !danced;
			playAnim(getIdleAnimation(), true, false);
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var currentOffset:Array<Float> = animOffsets.get(AnimName);

		if (animOffsets.exists(AnimName))
			offset.set(currentOffset[0], currentOffset[1]);
		else
			offset.set(0, 0);

		if (AnimName == 'singLEFT')
			danced = true;
		else if (AnimName == 'singRIGHT')
			danced = false;

		if (AnimName == 'singUP' || AnimName == 'singDOWN')
			danced = !danced;

		if (AnimName == 'hey' || AnimName == 'cheer')
			heyTimer = 0.55;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0):Void
	{
		animOffsets[name] = [x, y];
	}

	public function getIdleAnimation():String
	{
		if (animation.exists('danceLeft') || animation.exists('danceRight'))
		{
			return (danced) ? 'danceLeft' : 'danceRight';
		}

		return 'idle';
	}
}

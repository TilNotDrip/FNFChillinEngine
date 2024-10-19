package funkin.objects.game;

import funkin.util.ChillinAnimationController;
import flixel.math.FlxPoint;
import funkin.structures.CharacterStructure;

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

	public function new(?isPlayer:Bool = false)
	{
		super(0, 0);
		animation = new ChillinAnimationController(this);

		this.isPlayer = isPlayer;
	}

	@:allow(funkin.data.registry.CharacterRegistry)
	function loadJson(curCharacter:String, characterData:CharacterStructure):Void
	{
		this.characterData = characterData;
		this.curCharacter = curCharacter;

		if (characterData != null)
		{
			frames = Paths.content.autoAtlas(characterData.image, 'shared');

			for (anim in characterData.animations)
			{
				if (anim.indices.length != 0)
				{
					animation.addByIndices(anim.name, anim.prefix, anim.indices, '', anim.framerate, anim.looped, anim.flipX, anim.flipY);
				}
				else
				{
					animation.addByPrefix(anim.name, anim.prefix, anim.framerate, anim.looped, anim.flipX, anim.flipY);
				}

				addOffset(anim.name, anim.offsets[0], anim.offsets[1]);
			}

			antialiasing = (FunkinOptions.get('antialiasing') ? characterData.antialiasing : false);
			flipX = characterData.flipX;
			flipY = characterData.flipY;
			scale.set(characterData.scale[0], characterData.scale[1]);
			updateHitbox();

			if (isPlayer)
				flipX = !flipX;

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
		if (!animation.exists(AnimName))
			return;

		animation.play(AnimName, Force, Reversed, Frame);

		var currentOffset:Array<Float> = animOffsets.get(AnimName);

		if (animOffsets.exists(AnimName))
			offset.set(characterPosition[0] + currentOffset[0], characterPosition[1] + currentOffset[1]);
		else
			offset.set(characterPosition[0], characterPosition[1]);

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

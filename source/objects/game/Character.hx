package objects.game;

import addons.SongEvent.SwagEvent;

import flixel.math.FlxPoint;

import flixel.util.FlxSort;

class Character extends FlxSprite
{
	public var curCharacter:String = 'bf';
	public var deathCharacter:String = 'bf-dead';

	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var startedDeath:Bool = false;

	public var isPixel(default, set):Bool = false;

	public var holdTimer:Float = 0;
	public var bopDance:Float = 1;

	public var cameraOffsets:FlxPoint = new FlxPoint();

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		switch (curCharacter)
		{
			case 'bf':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND');

				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');

				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');

				quickAnimAdd('hey', 'BF HEY!!');
				animation.addByPrefix('scared', 'BF idle shaking', 24, true);

				playAnim('idle');

				flipX = true;

			case 'bf-dead':
				frames = Paths.getSparrowAtlas('characters/BF_Dead');

				quickAnimAdd('firstDeath', "BF dies");
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				quickAnimAdd('deathConfirm', "BF Dead confirm");

				playAnim('firstDeath');

				flipX = true;

			case 'gf':
				frames = Paths.getSparrowAtlas('characters/GF_assets');

				bopDance = 1;

				quickAnimAdd('cheer', 'GF Cheer');
				quickAnimAdd('singLEFT', 'GF left note');
				quickAnimAdd('singRIGHT', 'GF Right Note');
				quickAnimAdd('singUP', 'GF Up Note');
				quickAnimAdd('singDOWN', 'GF Down Note');

				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, true);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24, true);

				playAnim('danceRight');

			case 'dad':
				frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');

				quickAnimAdd('idle', 'Dad idle dance');
				quickAnimAdd('singUP', 'Dad Sing Note UP');
				quickAnimAdd('singRIGHT', 'Dad Sing Note RIGHT');
				quickAnimAdd('singDOWN', 'Dad Sing Note DOWN');
				quickAnimAdd('singLEFT', 'Dad Sing Note LEFT');

				playAnim('idle');

			case 'spooky':
				frames = Paths.getSparrowAtlas('characters/spooky_kids_assets');

				bopDance = 1;

				quickAnimAdd('singUP', 'spooky UP NOTE');
				quickAnimAdd('singDOWN', 'spooky DOWN note');
				quickAnimAdd('singLEFT', 'note sing left');
				quickAnimAdd('singRIGHT', 'spooky sing right');
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				playAnim('danceRight');

				y += 200;

			case 'pico':
				frames = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');

				quickAnimAdd('idle', "Pico Idle Dance");
				quickAnimAdd('singUP', 'pico Up note0');
				quickAnimAdd('singDOWN', 'Pico Down Note0');

				if (isPlayer)
				{
					quickAnimAdd('singLEFT', 'Pico NOTE LEFT0');
					quickAnimAdd('singRIGHT', 'Pico Note Right0');
					quickAnimAdd('singRIGHTmiss', 'Pico Note Right Miss');
					quickAnimAdd('singLEFTmiss', 'Pico NOTE LEFT miss');
				}
				else
				{
					quickAnimAdd('singLEFT', 'Pico Note Right0');
					quickAnimAdd('singRIGHT', 'Pico NOTE LEFT0');
					quickAnimAdd('singRIGHTmiss', 'Pico NOTE LEFT miss');
					quickAnimAdd('singLEFTmiss', 'Pico Note Right Miss');
				}

				quickAnimAdd('singUPmiss', 'pico Up note miss');
				quickAnimAdd('singDOWNmiss', 'Pico Down Note MISS');

				playAnim('idle');

				flipX = true;

				y += 300;

			case 'monster':
				frames = Paths.getSparrowAtlas('characters/Monster_Assets');

				quickAnimAdd('idle', 'monster idle');
				quickAnimAdd('singUP', 'monster up note');
				quickAnimAdd('singDOWN', 'monster down');
				quickAnimAdd('singLEFT', 'Monster left note');
				quickAnimAdd('singRIGHT', 'Monster Right note');

				playAnim('idle');

				y += 100;

			case 'mom':
				frames = Paths.getSparrowAtlas('characters/Mom_Assets');

				quickAnimAdd('idle', "Mom Idle");
				quickAnimAdd('singUP', "Mom Up Pose");
				quickAnimAdd('singDOWN', "MOM DOWN POSE");
				quickAnimAdd('singLEFT', 'Mom Left Pose');
				quickAnimAdd('singRIGHT', 'Mom Pose Left');

				cameraOffsets.y = -150;

				playAnim('idle');

			case 'bf-car':
				frames = Paths.getSparrowAtlas('characters/bfCar');

				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');

				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');

				animation.addByIndices('idleHair', 'BF idle dance', [10, 11, 12, 13], "", 24, true);

				playAnim('idle');

				flipX = true;

			case 'gf-car':
				frames = Paths.getSparrowAtlas('characters/gfCar');

				bopDance = 1;

				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('idleHair', 'GF Dancing Beat Hair blowing CAR', [10, 11, 12, 25, 26, 27], "", 24, true);

				playAnim('danceRight');

			case 'mom-car':
				frames = Paths.getSparrowAtlas('characters/momCar');

				quickAnimAdd('idle', "Mom Idle");
				quickAnimAdd('singUP', "Mom Up Pose");
				quickAnimAdd('singDOWN', "MOM DOWN POSE");
				quickAnimAdd('singLEFT', 'Mom Left Pose');
				quickAnimAdd('singRIGHT', 'Mom Pose Left');
				animation.addByIndices('idleHair', "Mom Idle", [10, 11, 12, 13], "", 24, true);

				playAnim('idle');

			case 'bf-christmas':
				frames = Paths.getSparrowAtlas('characters/bfChristmas');

				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');

				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');

				quickAnimAdd('hey', 'BF HEY!!');

				playAnim('idle');

				flipX = true;

			case 'gf-christmas':
				frames = Paths.getSparrowAtlas('characters/gfChristmas');

				bopDance = 1;

				quickAnimAdd('cheer', 'GF Cheer');
				quickAnimAdd('singLEFT', 'GF left note');
				quickAnimAdd('singRIGHT', 'GF Right Note');
				quickAnimAdd('singUP', 'GF Up Note');
				quickAnimAdd('singDOWN', 'GF Down Note');

				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24, true);

				playAnim('danceRight');

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');

				quickAnimAdd('idle', 'Parent Christmas Idle');
				quickAnimAdd('singUP', 'Parent Up Note Dad');
				quickAnimAdd('singDOWN', 'Parent Down Note Dad');
				quickAnimAdd('singLEFT', 'Parent Left Note Dad');
				quickAnimAdd('singRIGHT', 'Parent Right Note Dad');

				quickAnimAdd('singUP-alt', 'Parent Up Note Mom');
				quickAnimAdd('singDOWN-alt', 'Parent Down Note Mom');
				quickAnimAdd('singLEFT-alt', 'Parent Left Note Mom');
				quickAnimAdd('singRIGHT-alt', 'Parent Right Note Mom');

				playAnim('idle');

				x -= 500;

			case 'monster-christmas':
				frames = Paths.getSparrowAtlas('characters/monsterChristmas');

				quickAnimAdd('idle', 'monster idle');
				quickAnimAdd('singUP', 'monster up note');
				quickAnimAdd('singDOWN', 'monster down');
				quickAnimAdd('singLEFT', 'Monster left note');
				quickAnimAdd('singRIGHT', 'Monster Right note');

				playAnim('idle');

				y += 130;

			case 'bf-pixel':
				deathCharacter = 'bf-pixel-dead';

				frames = Paths.getSparrowAtlas('characters/bfPixel');

				quickAnimAdd('idle', 'BF IDLE instance 1');
				quickAnimAdd('singUP', 'BF UP NOTE instance 1');
				quickAnimAdd('singLEFT', 'BF LEFT NOTE instance 1');
				quickAnimAdd('singRIGHT', 'BF RIGHT NOTE instance 1');
				quickAnimAdd('singDOWN', 'BF DOWN NOTE instance 1');

				quickAnimAdd('singUPmiss', 'BF UP MISS instance 1');
				quickAnimAdd('singLEFTmiss', 'BF LEFT MISS instance 1');
				quickAnimAdd('singRIGHTmiss', 'BF RIGHT MISS instance 1');
				quickAnimAdd('singDOWNmiss', 'BF DOWN MISS instance 1');

				playAnim('idle');

				flipX = true;
				isPixel = true;

				width -= 100;
				height -= 100;

			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');

				quickAnimAdd('singUP', "BF Dies pixel");
				quickAnimAdd('firstDeath', "BF Dies pixel");
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				quickAnimAdd('deathConfirm', "RETRY CONFIRM");
				animation.play('firstDeath');

				playAnim('firstDeath');

				flipX = true;

				isPixel = true;

			case 'gf-pixel':
				frames = Paths.getSparrowAtlas('characters/gfPixel');

				bopDance = 1;

				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');

				isPixel = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai');

				quickAnimAdd('idle', 'Senpai Idle instance 1');
				quickAnimAdd('singUP', 'SENPAI UP NOTE instance 1');
				quickAnimAdd('singLEFT', 'SENPAI LEFT NOTE instance 1');
				quickAnimAdd('singRIGHT', 'SENPAI RIGHT NOTE instance 1');
				quickAnimAdd('singDOWN', 'SENPAI DOWN NOTE instance 1');

				playAnim('idle');

				isPixel = true;

				x += 150;
				y += 360;

			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');

				quickAnimAdd('idle', 'Angry Senpai Idle instance 1');
				quickAnimAdd('singUP', 'Angry Senpai UP NOTE instance 1');
				quickAnimAdd('singLEFT', 'Angry Senpai LEFT NOTE instance 1');
				quickAnimAdd('singRIGHT', 'Angry Senpai RIGHT NOTE instance 1');
				quickAnimAdd('singDOWN', 'Angry Senpai DOWN NOTE instance 1');

				playAnim('idle');

				isPixel = true;

				x += 150;
				y += 360;

			case 'spirit':
				frames = Paths.getSparrowAtlas('characters/spirit');

				quickAnimAdd('idle', "idle spirit");
				quickAnimAdd('singUP', "up");
				quickAnimAdd('singRIGHT', "right");
				quickAnimAdd('singLEFT', "left");
				quickAnimAdd('singDOWN', "spirit down");

				playAnim('idle');

				isPixel = true;

				x -= 150;
				y += 100;

			case 'gf-tankmen':
				frames = Paths.getSparrowAtlas('characters/gfTankmen');

				bopDance = 1;

				animation.addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, true);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');

			case 'bf-holding-gf':
				deathCharacter = 'bf-holding-gf-dead';

				frames = Paths.getSparrowAtlas('characters/bfAndGF');

				quickAnimAdd('idle', 'BF idle dance w gf');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singUP', 'BF NOTE UP0');

				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('bfCatch', 'BF catches GF');

				playAnim('idle');

				flipX = true;

			case 'bf-holding-gf-dead':
				frames = Paths.getSparrowAtlas('characters/bfHoldingGF-DEAD');
				quickAnimAdd('singUP', 'BF Dead with GF Loop');
				quickAnimAdd('firstDeath', 'BF Dies with GF');
				animation.addByPrefix('deathLoop', 'BF Dead with GF Loop', 24, true);
				quickAnimAdd('deathConfirm', 'RETRY confirm holding gf');

				playAnim('firstDeath');

				flipX = true;

			case 'tankman':
				frames = Paths.getSparrowAtlas('characters/tankmanCaptain');

				quickAnimAdd('idle', "Tankman Idle Dance instance 1");

				if (isPlayer)
				{
					quickAnimAdd('singLEFT', 'Tankman Note Left instance 1');
					quickAnimAdd('singRIGHT', 'Tankman Right Note instance 1');
				}
				else
				{
					quickAnimAdd('singLEFT', 'Tankman Right Note instance 1');
					quickAnimAdd('singRIGHT', 'Tankman Note Left instance 1');
				}

				quickAnimAdd('singUP', 'Tankman UP note instance 1');
				quickAnimAdd('singDOWN', 'Tankman DOWN note instance 1');

				quickAnimAdd('singDOWN-alt', 'PRETTY GOOD tankman instance 1');
				quickAnimAdd('singUP-alt', 'TANKMAN UGH instance 1');

				playAnim('idle');

				flipX = true;

				y += 180;

			case 'pico-speaker':
				frames = Paths.getSparrowAtlas('characters/picoSpeaker');

				quickAnimAdd('shoot1', "Pico shoot 1");
				quickAnimAdd('shoot2', "Pico shoot 2");
				quickAnimAdd('shoot3', "Pico shoot 3");
				quickAnimAdd('shoot4', "Pico shoot 4");

				playAnim('shoot1');
		}

		loadOffsetFile(curCharacter);

		dance();
		animation.finish();

		if (isPlayer)
		{
			flipX = !flipX;

			if (!curCharacter.startsWith('bf'))
			{
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	/*public function loadMappedAnims()
	{
		var swagshit = Song.loadFromJson('picospeaker', 'stress');

		var daConversion:Array<SwagEvent> = [];

		var notes = swagshit.notes;

		for (section in notes)
		{
			for (idk in section.sectionNotes)
			{
				daConversion.push({name: 'Pico Animation', params: [(idk[1] == 0) ? 'left' : 'right'], strumTime: idk[0]});
			}
		}

		var fuckYou = {
			"events": daConversion
		}
	}*/

	public static function sortAnims(val1:Array<Dynamic>, val2:Array<Dynamic>):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, val1[0], val2[0]);
	}

	private function quickAnimAdd(name:String, prefix:String)
	{
		animation.addByPrefix(name, prefix, 24, false);
	}

	private function loadOffsetFile(offsetCharacter:String)
	{
		var daFile:Array<String> = CoolUtil.coolTextFile(Paths.file("images/characters/" + offsetCharacter + "Offsets.txt", TEXT));

		for (i in daFile)
		{
			var splitWords:Array<String> = i.split(" ");
			addOffset(splitWords[0], Std.parseInt(splitWords[1]), Std.parseInt(splitWords[2]));
		}
	}

	private var playingEndAnim:Bool = false;

	override public function update(elapsed:Float)
	{
		if (animation.curAnim.name.startsWith('sing'))
			holdTimer += elapsed;

		if((playingEndAnim && animation.curAnim.name.endsWith('-end') && animation.curAnim.finished) || animation.curAnim == null)
		{
			playingEndAnim = false;
			dance();
		}

		if ((!isPlayer && PlayState.botplayDad) || (isPlayer && PlayState.botplay))
		{
			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;

			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}
		else
		{
			if (!animation.curAnim.name.startsWith('sing') && animation.curAnim.finished)
				holdTimer = 0;

			if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
				playAnim('idle', true, false, 10);

			if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished && startedDeath)
				playAnim('deathLoop');
		}

		if (curCharacter.endsWith('-car'))
		{
			if (!animation.curAnim.name.startsWith('sing') && animation.curAnim.finished)
				playAnim('idleHair');
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');

			case "pico-speaker":
				if (animation.curAnim.finished)
					playAnim(animation.curAnim.name, false, false, animation.curAnim.numFrames - 3);
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	public function dance()
	{
		if (!debugMode)
		{
			if (animation.exists(animation.curAnim.name + '-end') && !playingEndAnim && !animation.curAnim.name.endsWith('-end'))
			{
				playAnim(animation.curAnim.name + '-end', true);
				playingEndAnim = true;
				return;
			}

			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'gf-tankmen':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');

				case 'tankman':
					if (!animation.curAnim.name.endsWith('DOWN-alt'))
						playAnim('idle');

				case 'pico-speaker':

				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
			offset.set(daOffset[0], daOffset[1]);
		else
			offset.set(0, 0);

		if (AnimName == 'singLEFT')
			danced = true;
		else if (AnimName == 'singRIGHT')
			danced = false;

		if (AnimName == 'singUP' || AnimName == 'singDOWN')
			danced = !danced;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
		animOffsets[name] = [x, y];

	private function set_isPixel(value:Bool):Bool
	{
		if (value)
		{
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			updateHitbox();

			antialiasing = false;
		}

		isPixel = value;
		return isPixel;
	}
}

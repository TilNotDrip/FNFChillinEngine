package objects.game;

import addons.SongEvent.SwagEvent;
import flixel.math.FlxPoint;
import flixel.util.FlxSort;

class Character extends FlxSprite
{
	public var curCharacter:String = 'bf';
	public var deathCharacter:String = 'bf-dead';

	public var animOffsets:Map<String, FlxPoint>;

	public var isPlayer:Bool = false;
	public var startedDeath:Bool = false;

	public var isPixel(default, set):Bool = false;

	public var holdTimer:Float = 0;
	public var holdTimerLimit:Float = 4;

	public var allowedToIdle:Bool = true;

	public var bopDance:Float = 2;

	public var cameraOffsets:FlxPoint = new FlxPoint();

	public var heyTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animation = new FunkinAnimationController(this);

		animOffsets = new Map<String, FlxPoint>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		switch (curCharacter)
		{
			default:
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

				holdTimerLimit = 6;

				quickAnimAdd('idle', 'Dad idle dance');
				quickAnimAdd('singUP', 'Dad Sing note UP');
				quickAnimAdd('singRIGHT', 'Dad Sing Note LEFT');
				quickAnimAdd('singDOWN', 'Dad Sing Note DOWN');
				quickAnimAdd('singLEFT', 'dad sing note right');

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

				y = 200;

			case 'pico', 'pico-player':
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

				y = 300;

				if (isPlayer)
					cameraOffsets.x = -250;

			case 'monster':
				frames = Paths.getSparrowAtlas('characters/Monster_Assets');

				quickAnimAdd('idle', 'monster idle');
				quickAnimAdd('singUP', 'monster up note');
				quickAnimAdd('singDOWN', 'monster down');
				quickAnimAdd('singLEFT', 'Monster left note');
				quickAnimAdd('singRIGHT', 'Monster Right note');

				playAnim('idle');

				y = 100;

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

				animation.addByIndices('idle-loop', 'BF idle dance', [12, 13, 14, 15], "", 24, true);
				animation.addByIndices('singUP-loop', 'BF NOTE UP0', [4, 5, 6, 7], "", 24, true);
				animation.addByIndices('singLEFT-loop', 'BF NOTE LEFT0', [4, 5, 6, 7], "", 24, true);
				animation.addByIndices('singRIGHT-loop', 'BF NOTE RIGHT0', [4, 5, 6, 7], "", 24, true);
				animation.addByIndices('singDOWN-loop', 'BF NOTE DOWN0', [4, 5, 6, 7], "", 24, true);

				playAnim('idle');

				flipX = true;

			case 'gf-car':
				frames = Paths.getSparrowAtlas('characters/gfCar');

				bopDance = 1;

				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);
				animation.addByIndices('danceLeft-loop', 'GF Dancing Beat Hair blowing CAR', [28, 29, 30, 31], "", 24, true);
				animation.addByIndices('danceRight-loop', 'GF Dancing Beat Hair blowing CAR', [28, 29, 30, 31], "", 24, true);

				playAnim('danceRight');

			case 'mom-car':
				frames = Paths.getSparrowAtlas('characters/momCar');

				quickAnimAdd('idle', "Mom Idle");
				quickAnimAdd('singUP', "Mom Up Pose");
				quickAnimAdd('singDOWN', "MOM DOWN POSE");
				quickAnimAdd('singLEFT', 'Mom Left Pose');
				quickAnimAdd('singRIGHT', 'Mom Pose Left');

				animation.addByIndices('idle-loop', "Mom Idle", [12, 13, 14, 15], "", 24, true);
				animation.addByIndices('singUP-loop', "Mom Up Pose", [4, 5, 6, 7], "", 24, true);
				animation.addByIndices('singDOWN-loop', "MOM DOWN POSE", [4, 5, 6, 7], "", 24, true);
				animation.addByIndices('singLEFT-loop', 'Mom Left Pose', [4, 5, 6, 7], "", 24, true);
				animation.addByIndices('singRIGHT-loop', 'Mom Pose Left', [4, 5, 6, 7], "", 24, true);

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

				x = -500;

			case 'monster-christmas':
				frames = Paths.getSparrowAtlas('characters/monsterChristmas');

				quickAnimAdd('idle', 'monster idle');
				quickAnimAdd('singUP', 'monster up note');
				quickAnimAdd('singDOWN', 'monster down');
				quickAnimAdd('singLEFT', 'Monster left note');
				quickAnimAdd('singRIGHT', 'Monster Right note');

				playAnim('idle');

				y = 130;

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

				x = 150;
				y = 360;

			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');

				quickAnimAdd('idle', 'Angry Senpai Idle instance 1');
				quickAnimAdd('singUP', 'Angry Senpai UP NOTE instance 1');
				quickAnimAdd('singLEFT', 'Angry Senpai LEFT NOTE instance 1');
				quickAnimAdd('singRIGHT', 'Angry Senpai RIGHT NOTE instance 1');
				quickAnimAdd('singDOWN', 'Angry Senpai DOWN NOTE instance 1');

				playAnim('idle');

				isPixel = true;

				x = 150;
				y = 360;

			case 'spirit':
				frames = Paths.getSparrowAtlas('characters/spirit');

				quickAnimAdd('idle', "idle spirit");
				quickAnimAdd('singUP', "up");
				quickAnimAdd('singRIGHT', "right");
				quickAnimAdd('singLEFT', "left");
				quickAnimAdd('singDOWN', "spirit down");

				playAnim('idle');

				isPixel = true;

				x = -150;
				y = 100;

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

				y = 180;

			case 'pico-speaker':
				frames = Paths.getSparrowAtlas('characters/picoSpeaker');

				quickAnimAdd('shoot1', "Pico shoot 1");
				quickAnimAdd('shoot2', "Pico shoot 2");
				quickAnimAdd('shoot3', "Pico shoot 3");
				quickAnimAdd('shoot4', "Pico shoot 4");

				animation.addByIndices('shoot1-loop', 'Pico shoot 1', [23, 24, 25], "", 24, true);
				animation.addByIndices('shoot2-loop', 'Pico shoot 2', [23, 24, 25], "", 24, true);
				animation.addByIndices('shoot3-loop', 'Pico shoot 3', [23, 24, 25], "", 24, true);
				animation.addByIndices('shoot4-loop', 'Pico shoot 4', [23, 24, 25], "", 24, true);

				playAnim('shoot1');

			case 'darnell':
				frames = Paths.getSparrowAtlas('characters/darnell');

				quickAnimAdd('idle', 'Idle0');
				quickAnimAdd('singLEFT', 'Pose Left0');
				quickAnimAdd('singDOWN', 'Pose Down0');
				quickAnimAdd('singUP', 'Pose Up0');
				quickAnimAdd('singRIGHT', 'Pose Right0');

				quickAnimAdd('laugh', 'Laugh0');
				animation.addByIndices('laughCutscene', 'Laugh', [
					0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5
				], "", 24, false);

				quickAnimAdd('lightCan', 'Light Can');
				quickAnimAdd('kickCan', 'Kick Up');
				quickAnimAdd('kneeCan', 'Kick Forward');
				quickAnimAdd('pissed', 'Gets Pissed');

				playAnim('idle');

				cameraOffsets.x = 300;

			case 'nene':
				frames = Paths.getSparrowAtlas('characters/Nene');

				bopDance = 1;

				animation.addByIndices('danceLeft', 'Idle0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Idle0', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				animation.addByIndices('drop70', 'Laugh0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 6, 7, 8, 9, 10, 11, 6, 7, 8, 9, 10, 11], "", 24, false);
				quickAnimAdd('combo50', 'ComboCheer0');
				animation.addByIndices('combo100', 'ComboFawn0', [0, 1, 2, 3, 4, 5, 6, 4, 5, 6, 4, 5, 6, 4, 5, 6], "", 24, false);

				animation.addByIndices('laughCutscene', 'Laugh0', [
					0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11
				], "", 24, false);

				quickAnimAdd('raiseKnife', 'KnifeRaise0');
				quickAnimAdd('idleKnife', 'KnifeIdle0');
				quickAnimAdd('lowerKnife', 'KnifeLower0');

				playAnim('danceRight');
		}

		loadOffsetFile(curCharacter);

		dance();
		animation.finish();

		Conductor.beatSignal.add(beatHit);

		if (isPlayer)
			// {
			flipX = !flipX;

		/*if (!curCharacter.startsWith('bf'))
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
		}*/

		// }
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
	private function quickAnimAdd(name:String, prefix:String)
	{
		animation.addByPrefix(name, prefix, 24, false);
	}

	private function loadOffsetFile(offsetCharacter:String)
	{
		var daFile:Null<Array<String>> = CoolUtil.coolTextFile(Paths.file("images/characters/" + offsetCharacter + "Offsets.txt", TEXT));

		if (daFile == null)
			return;

		for (i in daFile)
		{
			var splitWords:Array<String> = i.split(" ");
			animOffsets[splitWords[0]] = new FlxPoint(Std.parseFloat(splitWords[1]), Std.parseFloat(splitWords[2]));
		}
	}

	// private var playingEndAnim:Bool = false;

	override public function update(elapsed:Float)
	{
		if (animation.curAnim.name.startsWith('sing'))
			holdTimer += elapsed;

		if (heyTimer > 0)
			heyTimer -= elapsed;

		/*if(playingEndAnim && animation.curAnim.name.endsWith('-end') && animation.curAnim.finished)
			{
				playingEndAnim = false;
				dance();
		}*/

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');

				/*case "pico-speaker":
					if (animation.curAnim.finished)
						playAnim(animation.curAnim.name, false, false, animation.curAnim.numFrames - 3); */
		}

		super.update(elapsed);
	}

	private function beatHit()
	{
		if (animation.curAnim.name.startsWith('sing'))
		{
			if (holdTimer >= (Conductor.stepCrochet * holdTimerLimit) / 1000 && allowedToIdle)
				dance();
		}
		else
		{
			if (Conductor.curBeat % bopDance == 0)
				dance();
		}
	}

	private var danced:Bool = false;

	public function dance()
	{
		if (heyTimer <= 0)
		{
			holdTimer = 0;

			var cantIdle:Bool = false;

			/*if (animation.exists(animation.curAnim.name + '-end') && !playingEndAnim && !animation.curAnim.name.endsWith('-end'))
				{
					playAnim(animation.curAnim.name + '-end', true);
					playingEndAnim = true;
					return;
			}*/

			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'gf-tankmen':
					cantIdle = animation.curAnim.name.startsWith('hair');

				case 'tankman':
					cantIdle = animation.curAnim.name.endsWith('DOWN-alt');

				case 'pico-speaker':
					cantIdle = true;
			}

			if (!cantIdle)
			{
				if (animation.exists('danceLeft') && animation.exists('danceRight'))
				{
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				}
				else
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);

		offset.set(0, 0);

		if (daOffset != null)
			offset += daOffset;

		if (AnimName == 'singLEFT')
			danced = true;
		else if (AnimName == 'singRIGHT')
			danced = false;

		if (AnimName == 'singUP' || AnimName == 'singDOWN')
			danced = !danced;

		if (AnimName == 'hey' || AnimName == 'cheer')
			heyTimer = 0.55;
	}

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

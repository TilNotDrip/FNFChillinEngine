package funkin.stages.bgs;

import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
#if flxanimate
import flxanimate.FlxAnimate;
#end
import funkin.objects.game.BGSprite;
import funkin.objects.game.Character;
import funkin.stages.objects.TankmenBG;

class Tank extends StageBackend
{
	var foregroundSprites:FlxTypedGroup<BGSprite>;

	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var tankWatchtower:BGSprite;
	var tankGround:BGSprite;

	override public function create()
	{
		GF_POSITION[0] -= 200.0;
		GF_POSITION[1] -= 74.0;

		DAD_POSITION = [20.0, 160.0];
		BF_POSITION = [810.0, 450.0];

		zoom = 0.90;

		foregroundSprites = new FlxTypedGroup<BGSprite>();

		var bg:BGSprite = new BGSprite('tankSky', -400, -400, 0, 0);
		add(bg);

		var tankSky:BGSprite = new BGSprite('tankClouds', FlxG.random.int(-700, -100), FlxG.random.int(-20, 20), 0.1, 0.1);
		tankSky.active = true;
		tankSky.velocity.x = FlxG.random.float(5, 15);
		add(tankSky);

		var tankMountains:BGSprite = new BGSprite('tankMountains', -300, -20, 0.2, 0.2);
		tankMountains.setGraphicSize(Std.int(tankMountains.width * 1.2));
		tankMountains.updateHitbox();
		add(tankMountains);

		var tankBuildings:BGSprite = new BGSprite('tankBuildings', -200, 0, 0.30, 0.30);
		tankBuildings.setGraphicSize(Std.int(tankBuildings.width * 1.1));
		tankBuildings.updateHitbox();
		add(tankBuildings);

		var tankRuins:BGSprite = new BGSprite('tankRuins', -200, 0, 0.35, 0.35);
		tankRuins.setGraphicSize(Std.int(tankRuins.width * 1.1));
		tankRuins.updateHitbox();
		add(tankRuins);

		var smokeLeft:BGSprite = new BGSprite('smokeLeft', -200, -100, 0.4, 0.4, ['SmokeBlurLeft'], true);
		add(smokeLeft);

		var smokeRight:BGSprite = new BGSprite('smokeRight', 1100, -100, 0.4, 0.4, ['SmokeRight'], true);
		add(smokeRight);

		tankWatchtower = new BGSprite('tankWatchtower', 100, 50, 0.5, 0.5, ['watchtower gradient color']);
		add(tankWatchtower);

		tankGround = new BGSprite('tankRolling', 300, 300, 0.5, 0.5, ['BG tank w lighting'], true);
		add(tankGround);

		tankmanRun = new FlxTypedGroup<TankmenBG>();
		add(tankmanRun);

		var tankGround:BGSprite = new BGSprite('tankGround', -420, -150);
		tankGround.setGraphicSize(Std.int(tankGround.width * 1.15));
		tankGround.updateHitbox();
		add(tankGround);

		moveTank();

		var fgTank0:BGSprite = new BGSprite('tank0', -500, 650, 1.7, 1.5, ['fg tankhead far right']);
		foregroundSprites.add(fgTank0);

		var fgTank1:BGSprite = new BGSprite('tank1', -300, 750, 2, 0.2, ['fg tankhead 5']);
		foregroundSprites.add(fgTank1);

		var fgTank2:BGSprite = new BGSprite('tank2', 450, 940, 1.5, 1.5, ['foreground man 3']);
		foregroundSprites.add(fgTank2);

		var fgTank4:BGSprite = new BGSprite('tank4', 1300, 900, 1.5, 1.5, ['fg tankman bobbin 3']);
		foregroundSprites.add(fgTank4);

		var fgTank5:BGSprite = new BGSprite('tank5', 1620, 700, 1.5, 1.5, ['fg tankhead far right']);
		foregroundSprites.add(fgTank5);

		var fgTank3:BGSprite = new BGSprite('tank3', 1300, 1200, 3.5, 2.5, ['fg tankhead 4']);
		foregroundSprites.add(fgTank3);
	}

	override public function createPost()
	{
		if (PlayState.SONG.player3 == 'pico-speaker')
		{
			var tempTankman:TankmenBG = new TankmenBG(20, 500, true);
			tempTankman.strumTime = 10;
			tempTankman.resetShit(20, 600, true);
			tankmanRun.add(tempTankman);

			for (i in 0...TankmenBG.animationNotes.length)
			{
				if (FlxG.random.bool(16))
				{
					var tankman:TankmenBG = tankmanRun.recycle(TankmenBG);
					tankman.strumTime = TankmenBG.animationNotes[i][0];
					tankman.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
					tankmanRun.add(tankman);
				}
			}
		}

		add(foregroundSprites);

		#if !debug
		if (isStoryMode)
		#else
		if (true)
		#end
		{
			switch (curSong.formatToPath())
			{
				case 'ugh':
					startCallback = ughIntro;
				case 'guns':
					startCallback = gunsIntro;
				case 'stress':
					startCallback = stressIntro;
			}
		}
	}

	#if (FUNKIN_VIDEOS && !hxvlc)
	var blackShit:FlxSprite;
	#end

	function ughIntro()
	{
		#if (FUNKIN_VIDEOS && !hxvlc)
		blackShit = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		add(blackShit);

		game.playVideo('ughCutscene');

		camGAME.zoom = zoom * 1.2;

		camFollow.x += 100;
		camFollow.y += 100;
		#else
		inCutscene = true;

		camGAME.zoom = game.cameraZoom = 0.9 * 1.2;

		game.cameraMovement(opponent);
		camFollow.x -= 100;
		// camFollow.y += 100;
		camGAME.snapToTarget();

		FlxG.sound.playMusic(Paths.content.music('cutscene/DISTORTO'), 0);
		FlxG.sound.music.fadeIn(5, 0, 0.5);

		opponent.visible = false;
		var tankCutsceneObj:FlxAnimate = new FlxAnimate(opponentGroup.x + 417 + opponent.characterPosition[0],
			opponentGroup.y + 225 + opponent.characterPosition[1], Paths.location.atlas('cutscenes/tankman', 'week7'));
		addBehindOpponent(tankCutsceneObj);

		tankCutsceneObj.anim.play('TANK TALK 1 P1');

		// This should be the 2nd frame right? According to old code that is when it plays.
		new FlxTimer().start(1 / 24 * 2, function(camMoveTank1:FlxTimer)
		{
			FlxG.sound.play(Paths.content.sound("cutscene/wellWellWell"));
		});

		// Move camera to Boyfriend.
		new FlxTimer().start(3, function(camMoveTank1:FlxTimer)
		{
			camFollow.x += 800;
			camFollow.y += 100;
		});

		// Make Boyfriend play his Up anim and beep.
		new FlxTimer().start(4.5, function(bfBeep:FlxTimer)
		{
			player.playAnim("singUP");

			var bfBeepSfx:FlxSound = FlxG.sound.play(Paths.content.sound("cutscene/bfBeep", "week7"));

			// Go back to idle once he's done beeping.
			bfBeepSfx.onComplete = function()
			{
				player.playAnim("idle");
			};
		});

		new FlxTimer().start(6, function(killYou:FlxTimer)
		{
			camFollow.x -= 800;
			camFollow.y -= 100;

			FlxG.sound.play(Paths.content.sound("cutscene/killYou"));
			// Play the "Kill You" animation.
			tankCutsceneObj.anim.play("TANK TALK 1 P2");
		});

		// Finishing up the cutscene.
		new FlxTimer().start(12.1, function(endCutscene:FlxTimer)
		{
			game.cameraMovement(opponent);

			FlxTween.tween(camGAME, {zoom: zoom}, 0.5, {
				ease: FlxEase.quadInOut,
				onUpdate: function(_)
				{
					game.cameraZoom = camGAME.zoom;
				}
			});

			tankCutsceneObj.destroy();

			// The original opponent can come back now.
			opponent.visible = true;

			// Stop the cutscene music.
			FlxG.sound.music.stop();
			FlxG.sound.music.destroy();

			// Play the song now.
			inCutscene = false;
			startCountdown();
		});
		#end
	}

	function gunsIntro()
	{
		#if (FUNKIN_VIDEOS && !hxvlc)
		blackShit = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		add(blackShit);

		game.playVideo('gunsCutscene');
		#else
		inCutscene = true;
		camHUD.visible = false;

		FlxTween.tween(camGAME, {zoom: 0.9 * 1.3}, 0.4, // 0.9 was the original tank stage zoom in 0.2.8. (Also the one showed in the video)
			{
				ease: FlxEase.quadInOut,
				onUpdate: function(_)
				{
					game.cameraZoom = camGAME.zoom;
				}
			});

		// Make the current opponent invisible for now.
		opponent.visible = false;

		// Setup Tankman object.
		var tankCutsceneObj:FlxAnimate = new FlxAnimate(opponentGroup.x + 417 + opponent.characterPosition[0],
			opponentGroup.y + 225 + opponent.characterPosition[1], Paths.location.atlas('cutscenes/tankman', 'week7'));
		addBehindOpponent(tankCutsceneObj);

		tankCutsceneObj.anim.play('TANK TALK 2');

		game.cameraMovement(opponent);
		// camFollow.y -= 100;
		camFollow.x -= 100;
		camGAME.snapToTarget();

		FlxG.sound.play(Paths.content.sound("cutscene/tankSong2"));

		// Tankman makes Girlfriend cry.
		new FlxTimer().start(4.1, function(gfCry:FlxTimer)
		{
			FlxTween.tween(camGAME, {zoom: 0.9 * 1.4}, 0.4, {
				ease: FlxEase.quadOut,
				onUpdate: function(_)
				{
					game.cameraZoom = camGAME.zoom;
				}
			});

			FlxTween.tween(camGAME, {zoom: 0.9 * 1.3}, 0.4, {
				ease: FlxEase.quadInOut,
				startDelay: 0.45,
				onUpdate: function(_)
				{
					game.cameraZoom = camGAME.zoom;
				}
			});

			gf.playAnim("sad");

			// Just to make sure she cries until the song starts.
			gf.animation.finishCallback = function(gfCryForever:String)
			{
				gf.playAnim("sad");
			};
		});

		// Finishing up the cutscene.
		new FlxTimer().start(11, function(endCutscene:FlxTimer)
		{
			game.cameraMovement(opponent);

			FlxTween.tween(camGAME, {zoom: zoom}, 0.5, {
				ease: FlxEase.quadInOut,
				onUpdate: function(_)
				{
					game.cameraZoom = camGAME.zoom;
				}
			});

			tankCutsceneObj.destroy();

			// The original opponent can come back now.
			opponent.visible = true;

			// Stop the cutscene music.
			FlxG.sound.music.stop();
			FlxG.sound.music.destroy();

			// she doesnt need to cry no more
			gf.animation.finishCallback = null;

			// Play the song now.
			inCutscene = false;
			startCountdown();
		});
		#end
	}

	function stressIntro()
	{
		#if (FUNKIN_VIDEOS && !hxvlc)
		blackShit = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		add(blackShit);

		game.playVideo('stressCutscene');
		#else
		inCutscene = true;
		camHUD.visible = false;

		camGAME.zoom = game.cameraZoom = 0.9 * 1.15;

		// Make the characters on stage invisible for now.
		gf.visible = false;
		opponent.visible = false;
		player.visible = false;

		// Setup a Fake Girlfriend.
		var fakeGF:Character = new Character(gfGroup.x, gfGroup.y, 'gf-tankmen');
		fakeGF.x += fakeGF.characterPosition[0];
		fakeGF.y += fakeGF.characterPosition[1];
		fakeGF.scrollFactor.set(0.95, 0.95);
		fakeGF.dance();
		fakeGF.animation.finish();
		addBehindGF(fakeGF);

		// Setup GF Turning Sparrow object.
		var gfCutsceneObj:FlxSprite = new FlxSprite(fakeGF.x - 220, fakeGF.y - 463);
		gfCutsceneObj.frames = Paths.content.autoAtlas("cutscenes/GF_Turn", "week7");
		gfCutsceneObj.animation.addByPrefix("gfTurn", "GF STARTS TO TURN", 24, false);
		gfCutsceneObj.visible = false;
		addBehindGF(gfCutsceneObj);

		// Setup Pico Atlas object.
		var picoCutsceneObj:FlxAnimate = new FlxAnimate(gfGroup.x - 114, gfGroup.y + 119, Paths.location.atlas("cutscenes/pico", "week7"));
		picoCutsceneObj.visible = false;
		addBehindGF(picoCutsceneObj);

		// Setup a Fake Boyfriend.
		var fakeBF:Character = new Character(playerGroup.x, playerGroup.y, 'bf', true);
		fakeBF.x += fakeBF.characterPosition[0];
		fakeBF.y += fakeBF.characterPosition[1];
		fakeBF.dance();
		fakeBF.animation.finish();
		addBehindPlayer(fakeBF);

		// Setup Tankman object.
		var tankCutsceneObj:FlxAnimate = new FlxAnimate(opponentGroup.x + 417 + opponent.characterPosition[0],
			opponentGroup.y + 225 + opponent.characterPosition[1], Paths.location.atlas('cutscenes/tankman', 'week7'));
		addBehindOpponent(tankCutsceneObj);

		tankCutsceneObj.anim.play('TANK TALK 3 P1 UNCUT');

		game.cameraMovement(opponent);
		camGAME.snapToTarget();

		FlxG.sound.play(Paths.content.sound("cutscene/stressCutscene"));

		// GF starts to turn demonic.
		new FlxTimer().start(15.1, function(gfTurn:FlxTimer)
		{
			camFollow.x += 200;
			camFollow.y -= 170;

			fakeGF.destroy();

			gfCutsceneObj.visible = true;
			gfCutsceneObj.animation.play("gfTurn");

			gfCutsceneObj.animation.finishCallback = (name:String) ->
			{
				picoCutsceneObj.visible = true;
				picoCutsceneObj.anim.play();
				gfCutsceneObj.destroy();
			}

			picoCutsceneObj.anim.onComplete.add(function()
			{
				gf.visible = true;
				picoCutsceneObj.destroy();
			});

			FlxTween.tween(camGAME, {zoom: camGAME.zoom * 1.3}, 1.9, {
				ease: FlxEase.quadInOut,
				onUpdate: function(_)
				{
					game.cameraZoom = camGAME.zoom;
				}
			});
		});

		// Pico arrives and kills some tankmen.
		new FlxTimer().start(17.3, function(picoArrives:FlxTimer)
		{
			camGAME.zoom = game.cameraZoom = 0.8;

			fakeBF.destroy();

			player.visible = true;
			player.playAnim("bfCatch");

			player.animation.finishCallback = function(bfCatch:String)
			{
				player.dance();
				player.animation.finishCallback = null;
			};
		});

		// Tankman talks to Pico.
		new FlxTimer().start(19.6, function(lookWhoItIs:FlxTimer)
		{
			tankCutsceneObj.anim.play("TANK TALK 3 P2 UNCUT");
		});

		new FlxTimer().start(20.3, function(lookWhoCamMove:FlxTimer)
		{
			camFollow.x -= 80;
			camFollow.y += 180;
		});

		// You little cunt.
		new FlxTimer().start(31.5, function(cunt:FlxTimer)
		{
			camFollow.x += 400;
			camFollow.y += 150;
			camGAME.zoom = game.cameraZoom = 0.9 * 1.4;
			camGAME.snapToTarget();

			FlxTween.tween(camGAME, {zoom: camGAME.zoom + 0.1}, 0.5, {
				ease: FlxEase.elasticOut,
				onUpdate: function(_)
				{
					game.cameraZoom = camGAME.zoom;
				}
			});

			player.playAnim("singUPmiss");

			// We can see his head cut off during this part so we will hide him until the player is done his miss animation.
			// PlayState.instance.currentStage.getNamedProp("tankmanAudience3").alpha = 0;

			player.animation.finishCallback = function(bfMiss:String)
			{
				player.dance();

				camFollow.x -= 400;
				camFollow.y -= 150;
				camGAME.zoom = game.cameraZoom /= 1.4;
				camGAME.snapToTarget();

				// PlayState.instance.currentStage.getNamedProp("tankmanAudience3").alpha = 1;

				player.animation.finishCallback = null;
			};
		});

		// Finishing up the cutscene.
		new FlxTimer().start(35.1, function(endCutscene:FlxTimer)
		{
			game.cameraMovement(opponent);

			FlxTween.tween(camGAME, {zoom: zoom}, 0.5, {
				ease: FlxEase.quadInOut,
				onUpdate: function(_)
				{
					game.cameraZoom = camGAME.zoom;
				}
			});

			tankCutsceneObj.destroy();

			// The original opponent can come back now.
			opponent.visible = true;

			// Stop the cutscene music.
			FlxG.sound.music.stop();
			FlxG.sound.music.destroy();

			// she doesnt need to cry no more
			gf.animation.finishCallback = null;

			// Play the song now.
			inCutscene = false;
			startCountdown();
		});
		#end
	}

	#if (FUNKIN_VIDEOS && !hxvlc)
	override public function endingVideo()
	{
		remove(blackShit);
		FlxTween.tween(FlxG.camera, {zoom: zoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});
	}
	#end

	override public function update(elapsed:Float):Void
	{
		if (!inCutscene)
			moveTank();
	}

	function moveTank():Void
	{
		var daAngleOffset:Float = 1;
		tankAngle += FlxG.elapsed * tankSpeed;
		tankGround.angle = tankAngle - 90 + 15;

		tankGround.x = tankX + Math.cos(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1500;
		tankGround.y = 1300 + Math.sin(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1100;
	}

	var tankResetShit:Bool = false;
	var tankMoving:Bool = false;
	var tankAngle:Float = FlxG.random.int(-90, 45);
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankX:Float = 400;

	override public function beatHit():Void
	{
		foregroundSprites.forEach(function(spr:BGSprite)
		{
			spr.dance();
		});

		tankWatchtower.dance();
	}
}

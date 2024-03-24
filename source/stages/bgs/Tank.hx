package stages.bgs;

import flixel.math.FlxAngle;

import flxanimate.FlxAnimate;

import objects.Character;

import stages.objects.TankmenBG;

class Tank extends StageBackend
{
    var foregroundSprites:FlxTypedGroup<BGSprite>;

    var tankmanRun:FlxTypedGroup<TankmenBG>;
	var tankWatchtower:BGSprite;
	var tankGround:BGSprite;

    var gfCutsceneLayer:FlxGroup;
	var bfTankCutsceneLayer:FlxGroup;

    override function create()
    {
		hasCutscene = true;

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

        var smokeLeft:BGSprite = new BGSprite('smokeLeft', -200, -100, 0.4, 0.4, ['SmokeBlurLeft instance 1'], true);
        add(smokeLeft);

        var smokeRight:BGSprite = new BGSprite('smokeRight', 1100, -100, 0.4, 0.4, ['SmokeRight instance 1'], true);
        add(smokeRight);

        tankWatchtower = new BGSprite('tankWatchtower', 100, 50, 0.5, 0.5, ['watchtower gradient color instance 1']);
        add(tankWatchtower);

        tankGround = new BGSprite('tankRolling', 300, 300, 0.5, 0.5, ['BG tank w lighting instance 1'], true);
        add(tankGround);

        tankmanRun = new FlxTypedGroup<TankmenBG>();
        add(tankmanRun);

        var tankGround:BGSprite = new BGSprite('tankGround', -420, -150);
        tankGround.setGraphicSize(Std.int(tankGround.width * 1.15));
        tankGround.updateHitbox();
        add(tankGround);

        moveTank();

        var fgTank0:BGSprite = new BGSprite('tank0', -500, 650, 1.7, 1.5, ['fg tankhead far right instance 1']);
        foregroundSprites.add(fgTank0);

        var fgTank1:BGSprite = new BGSprite('tank1', -300, 750, 2, 0.2, ['fg tankhead 5 instance 1']);
        foregroundSprites.add(fgTank1);

        var fgTank2:BGSprite = new BGSprite('tank2', 450, 940, 1.5, 1.5, ['foreground man 3 instance 1']);
        foregroundSprites.add(fgTank2);

        var fgTank4:BGSprite = new BGSprite('tank4', 1300, 900, 1.5, 1.5, ['fg tankman bobbin 3 instance 1']);
        foregroundSprites.add(fgTank4);

        var fgTank5:BGSprite = new BGSprite('tank5', 1620, 700, 1.5, 1.5, ['fg tankhead far right instance 1']);
        foregroundSprites.add(fgTank5);

        var fgTank3:BGSprite = new BGSprite('tank3', 1300, 1200, 3.5, 2.5, ['fg tankhead 4 instance 1']);
        foregroundSprites.add(fgTank3);
    }

    override function createPost()
    {
        switch (PlayState.SONG.player3)
		{
			case 'pico-speaker':
				PlayState.game.gf.x -= 50;
				PlayState.game.gf.y -= 200;

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

        PlayState.game.gf.y += 10;
		PlayState.game.gf.x -= 30;
		PlayState.game.boyfriend.x += 40;
		PlayState.game.boyfriend.y += 0;
		PlayState.game.dad.y += 60;
		PlayState.game.dad.x -= 80;

		if (PlayState.SONG.player3 != 'pico-speaker')
		{
			PlayState.game.gf.x -= 170;
			PlayState.game.gf.y -= 75;
		}

        add(foregroundSprites);

        gfCutsceneLayer = new FlxGroup();
		add(gfCutsceneLayer);

		bfTankCutsceneLayer = new FlxGroup();
		add(bfTankCutsceneLayer);

        if (PlayState.isStoryMode && !PlayState.seenCutscene)
        {
			PlayState.seenCutscene = true;

            switch (PlayState.SONG.song.formatToPath())
            {
                case 'ugh':
                    ughIntro();
                case 'guns':
                    gunsIntro();
                case 'stress':
                    stressIntro();
            }
        }
    }

	function ughIntro()
	{
		PlayState.game.inCutscene = true;

		FlxG.camera.zoom = zoom * 1.2;

		PlayState.game.camFollow.x += 100;
		PlayState.game.camFollow.y += 100;

		FlxG.sound.playMusic(Paths.music('DISTORTO'), 0);
		FlxG.sound.music.fadeIn(5, 0, 0.5);

		PlayState.game.dad.visible = false;
		var tankCutscene:FlxAnimate = new FlxAnimate(-20, 320, Paths.getLibraryPath('images/cutscenceStuff/ughIntro', 'week7'));
		tankCutscene.anim.addBySymbol('wellWellWell', 'part 1', 24, false);
		tankCutscene.anim.addBySymbol('killYou', 'part 2', 24, false);
		gfCutsceneLayer.add(tankCutscene);

		tankCutscene.anim.play('wellWellWell');

		PlayState.game.camHUD.visible = false;

		FlxG.camera.zoom *= 1.2;

		var eduardoAhh:FlxSound = FlxG.sound.load(Paths.sound('wellWellWell'));
		eduardoAhh.play(true);

		cameraMovement(PlayState.game.dad);

		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			FlxTween.tween(FlxG.camera, {zoom: zoom * 1.2}, 0.27, {ease: FlxEase.quadInOut});
			cameraMovement(PlayState.game.boyfriend);

			new FlxTimer().start(1.5, function(bep:FlxTimer)
			{
				PlayState.game.boyfriend.playAnim('singUP');
				FlxG.sound.play(Paths.sound('bfBeep'), function()
				{
					PlayState.game.boyfriend.playAnim('idle');
				});
			});

			new FlxTimer().start(3, function(swaggy:FlxTimer)
			{
				cameraMovement(PlayState.game.dad);
				FlxTween.tween(FlxG.camera, {zoom: zoom * 1.2}, 0.5, {ease: FlxEase.quadInOut});
				eduardoAhh.loadEmbedded(Paths.sound('killYou'));
				eduardoAhh.play(true);
				tankCutscene.anim.play('killYou');
				new FlxTimer().start(6.1, function(swagasdga:FlxTimer)
				{
					FlxTween.tween(FlxG.camera, {zoom: zoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});

					FlxG.sound.music.fadeOut((Conductor.crochet / 1000) * 5, 0);

					new FlxTimer().start((Conductor.crochet / 1000) * 5, function(money:FlxTimer)
					{
						PlayState.game.dad.visible = true;
						gfCutsceneLayer.remove(tankCutscene);
					});

					PlayState.game.startCountdown();
					PlayState.game.camHUD.visible = true;
				});
			});
		});
	}

	function gunsIntro()
	{
		PlayState.game.inCutscene = true;

		PlayState.game.camHUD.visible = false;

		FlxG.sound.playMusic(Paths.music('DISTORTO'), 0);
		FlxG.sound.music.fadeIn(5, 0, 0.5);

		cameraMovement(PlayState.game.dad);
		PlayState.game.camFollow.y += 100;

		FlxTween.tween(FlxG.camera, {zoom: zoom * 1.3}, 4, {ease: FlxEase.quadInOut});

		PlayState.game.dad.visible = false;
		var tankCutscene:FlxAnimate = new FlxAnimate(-20, 320, Paths.getLibraryPath('images/cutscenceStuff/ughIntro', 'week7'));
		tankCutscene.anim.addBySymbol('open fire', 'roast her', 24, false);
		gfCutsceneLayer.add(tankCutscene);

		tankCutscene.anim.play('open fire');

		var eduardoAhh:FlxSound = FlxG.sound.load(Paths.sound('wellWellWell'));
		eduardoAhh.play(true);

		new FlxTimer().start(4.1, function(ugly:FlxTimer)
		{
			FlxTween.tween(FlxG.camera, {zoom: zoom * 1.4}, 0.4, {ease: FlxEase.quadOut});
			FlxTween.tween(FlxG.camera, {zoom: zoom * 1.3}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.45});

			PlayState.game.gf.playAnim('sad');
		});

		new FlxTimer().start(11, function(tmr:FlxTimer)
		{
			FlxG.sound.music.fadeOut((Conductor.crochet / 1000) * 5, 0);

			FlxTween.tween(FlxG.camera, {zoom: zoom}, (Conductor.crochet * 5) / 1000, {ease: FlxEase.quartIn});
			PlayState.game.startCountdown();
			new FlxTimer().start((Conductor.crochet * 25) / 1000, function(daTim:FlxTimer)
			{
				PlayState.game.dad.visible = true;
				gfCutsceneLayer.remove(tankCutscene);
			});

            PlayState.game.camHUD.visible = true;
		});
	}

	function stressIntro()
	{
		PlayState.game.inCutscene = true;

		PlayState.game.camHUD.visible = false;
		PlayState.game.camFollow.setPosition(PlayState.game.camPos.x, PlayState.game.camPos.y);
		PlayState.game.dad.visible = false;
		PlayState.game.gf.visible = false;

		var gfTankmen:FlxSprite = new FlxSprite(210, 70);
		gfTankmen.frames = Paths.getSparrowAtlas('characters/gfTankmen');
		gfTankmen.animation.addByPrefix('loop', 'GF Dancing at Gunpoint', 24, true);
		gfTankmen.animation.play('loop');
		gfCutsceneLayer.add(gfTankmen);

		var tankCutscene:FlxAnimate = new FlxAnimate(-20, 320, Paths.getLibraryPath('images/cutscenceStuff/stressTank', 'week7'));
		tankCutscene.anim.addBySymbol('god damn', 'part 1', 24, false);
		tankCutscene.anim.addBySymbol('pico reference', 'part 2', 24, false);
		gfCutsceneLayer.add(tankCutscene);
		bfTankCutsceneLayer.add(tankCutscene);

		PlayState.game.camFollow.setPosition(PlayState.game.gf.x + 350, PlayState.game.gf.y + 560);
		FlxG.camera.focusOn(PlayState.game.camFollow.getPosition());

		PlayState.game.boyfriend.visible = false;

		var fakeBF:Character = new Character(PlayState.game.boyfriend.x, PlayState.game.boyfriend.y, 'bf', true);
		bfTankCutsceneLayer.add(fakeBF);

		var bfCatchGf:FlxSprite = new FlxSprite(PlayState.game.boyfriend.x - 10, PlayState.game.boyfriend.y - 90);
		bfCatchGf.frames = Paths.getSparrowAtlas('cutsceneStuff/bfCatchesGF');
		bfCatchGf.animation.addByPrefix('catch', 'BF catches GF', 24, false);
		add(bfCatchGf);
		bfCatchGf.visible = false;

		var picoCutscene:FlxAnimate = new FlxAnimate(-20, 320, Paths.getLibraryPath('images/cutscenceStuff/goPicoYeahYeah', 'week7'));
		picoCutscene.anim.addBySymbol('holy', 'pico go wild', 24, false);
		picoCutscene.anim.addBySymbol('loop', 'idle', 24, true);
		gfCutsceneLayer.add(picoCutscene);
		picoCutscene.visible = false;

		var cutsceneAudio:FlxSound = FlxG.sound.load(Paths.sound('stressCutscene'));

		if (PreferencesMenu.getPref('censor-naughty'))
			cutsceneAudio.loadEmbedded(Paths.sound('song3censor'));

		cutsceneAudio.play(true);

		FlxG.camera.zoom = zoom * 1.15;

		PlayState.game.camFollow.x -= 200;

		new FlxTimer().start(31.5, function(cunt:FlxTimer)
		{
			PlayState.game.camFollow.x += 400;
			PlayState.game.camFollow.y += 150;
			FlxG.camera.zoom = zoom * 1.4;
			FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.1}, 0.5, {ease: FlxEase.elasticOut});
			FlxG.camera.focusOn(PlayState.game.camFollow.getPosition());
			PlayState.game.boyfriend.playAnim('singUPmiss');
			PlayState.game.boyfriend.animation.finishCallback = function(animFinish:String)
			{
				PlayState.game.camFollow.x -= 400;
				PlayState.game.camFollow.y -= 150;
				FlxG.camera.zoom /= 1.4;
				FlxG.camera.focusOn(PlayState.game.camFollow.getPosition());

				PlayState.game.boyfriend.animation.finishCallback = null;
			};
		});

		new FlxTimer().start(15.1, function(tmr:FlxTimer)
		{
			PlayState.game.camFollow.y -= 170;
			PlayState.game.camFollow.x += 200;
			FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom * 1.3}, 2.1, {
				ease: FlxEase.quadInOut
			});

			new FlxTimer().start(2.2, function(swagTimer:FlxTimer)
			{
				FlxG.camera.zoom = 0.8;
				PlayState.game.boyfriend.visible = false;
				bfCatchGf.visible = true;
				bfCatchGf.animation.play('catch');

				bfTankCutsceneLayer.remove(fakeBF);

				bfCatchGf.animation.finishCallback = function(anim:String)
				{
					remove(bfCatchGf);
					PlayState.game.boyfriend.visible = true;
				};

				new FlxTimer().start(3, function(weedShitBaby:FlxTimer)
				{
					PlayState.game.camFollow.y += 180;
					PlayState.game.camFollow.x -= 80;
				});

				new FlxTimer().start(2.3, function(gayLol:FlxTimer)
				{
					tankCutscene.anim.play('pico reference');
				});
			});

			picoCutscene.alpha = 1;
			picoCutscene.anim.play('holy');
			picoCutscene.anim.onComplete = function()
			{
				picoCutscene.anim.play('idle');
				picoCutscene.anim.onComplete = null;
			};

			new FlxTimer().start(20, function(alsoTmr:FlxTimer)
			{
				PlayState.game.dad.visible = true;
				PlayState.game.gf.visible = true;
				bfTankCutsceneLayer.remove(tankCutscene);
				PlayState.game.startCountdown();

				gfCutsceneLayer.remove(picoCutscene);
			});
		});
	}

    override function update(elapsed:Float)
    {
        moveTank();
    }

    function moveTank():Void
	{
		if (!PlayState.game.inCutscene)
		{
			var daAngleOffset:Float = 1;
			tankAngle += FlxG.elapsed * tankSpeed;
			tankGround.angle = tankAngle - 90 + 15;

			tankGround.x = tankX + Math.cos(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1500;
			tankGround.y = 1300 + Math.sin(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1100;
		}
	}

	var tankResetShit:Bool = false;
	var tankMoving:Bool = false;
	var tankAngle:Float = FlxG.random.int(-90, 45);
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankX:Float = 400;

    override function beatHit()
    {
        foregroundSprites.forEach(function(spr:BGSprite)
		{
			spr.dance();
		});

        tankWatchtower.dance();
    }
}
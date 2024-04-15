package stages.bgs;

import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

#if flxanimate
import flxanimate.FlxAnimate;
#end

import objects.game.BGSprite;
import objects.game.Character;

import stages.objects.TankmenBG;

class Tank extends StageBackend
{
    private var foregroundSprites:FlxTypedGroup<BGSprite>;

    private var tankmanRun:FlxTypedGroup<TankmenBG>;
	private var tankWatchtower:BGSprite;
	private var tankGround:BGSprite;

    private var gfCutsceneLayer:FlxGroup;
	private var bfTankCutsceneLayer:FlxGroup;

    override public function create()
    {
		zoom = 0.90;

		if (isStoryMode)
			if (curSong.formatToPath() == 'ugh' || curSong.formatToPath() == 'guns' || curSong.formatToPath() == 'stress')
				hasCutscene = true;

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

		gfCutsceneLayer = new FlxGroup();
		add(gfCutsceneLayer);
    }

    override public function createPost()
    {
        switch (PlayState.SONG.player3)
		{
			case 'pico-speaker':
				gf.x -= 50;
				gf.y -= 200;

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

        gf.y += 10;
		gf.x -= 30;
		player.x += 40;
		player.y += 0;
		opponent.y += 60;
		opponent.x -= 80;

		if (PlayState.SONG.player3 != 'pico-speaker')
		{
			gf.x -= 170;
			gf.y -= 75;
		}

        gfCutsceneLayer = new FlxGroup();
		add(gfCutsceneLayer);

		bfTankCutsceneLayer = new FlxGroup();
		add(bfTankCutsceneLayer);

        if (isStoryMode && !PlayState.seenCutscene)
        {
            switch (curSong.formatToPath())
            {
                case 'ugh':
                    ughIntro();
                case 'guns':
                    gunsIntro();
                case 'stress':
                    stressIntro();
				default:
					startCountdown();
            }
        }

		add(foregroundSprites);
    }

	#if html5
	private var blackShit:FlxSprite;
	#end

	private function ughIntro()
	{
		inCutscene = true;

		#if html5
		blackShit = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackShit.scrollFactor.set();
		add(blackShit);

		game.playVideo('ughCutscene');

		camGAME.zoom = zoom * 1.2;

		camFollow.x += 100;
		camFollow.y += 100;
		#else
		camGAME.zoom = zoom * 1.2;

		camFollow.x += 100;
		camFollow.y += 100;

		FlxG.sound.playMusic(Paths.music('DISTORTO'), 0);
		FlxG.sound.music.fadeIn(5, 0, 0.5);

		opponent.visible = false;
		var tankCutscene:FlxAnimate = new FlxAnimate(opponent.x + 400, opponent.y + 200, 'assets/week7/images/cutsceneStuff/ughIntro');
		// fun fact, to get this working i talked to cheemsnfriends cuz i kept getting null errors (parent)
		tankCutscene.anim.addBySymbol('wellWellWell', 'TANK TALK 1 P1', 24, false);
		tankCutscene.anim.addBySymbol('killYou', 'TANK TALK 1 P2', 24, false);
		bfTankCutsceneLayer.add(tankCutscene);

		tankCutscene.anim.play('wellWellWell');

		FlxG.camera.zoom *= 1.2;
		camFollow.y += 100;

		var camPosMath:FlxPoint = new FlxPoint(camFollow.x, camFollow.y);

		camGAME.zoom *= 1.2;

		var eduardoAhh:FlxSound = FlxG.sound.load(Paths.sound('wellWellWell'));
		eduardoAhh.play(true);

		cameraMovement(opponent);

		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			camFollow.setPosition(player.getMidpoint().x, player.getMidpoint().y - 70);
			FlxTween.tween(camGAME, {zoom: zoom * 1.2}, 0.27, {ease: FlxEase.quadInOut});

			new FlxTimer().start(1.5, function(bep:FlxTimer)
			{
				player.playAnim('singUP');
				FlxG.sound.play(Paths.sound('bfBeep'), function()
				{
					player.playAnim('idle');
				});
			});

			new FlxTimer().start(3, function(swaggy:FlxTimer)
			{
				camFollow.setPosition(opponent.getMidpoint().x + 10, opponent.getMidpoint().y - 70);
				FlxTween.tween(camGAME, {zoom: zoom * 1.2}, 0.5, {ease: FlxEase.quadInOut});
				eduardoAhh.loadEmbedded(Paths.sound('killYou'));
				eduardoAhh.play(true);
				tankCutscene.anim.play('killYou');
				new FlxTimer().start(6.1, function(swagasdga:FlxTimer)
				{
					FlxTween.tween(camGAME, {zoom: zoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});

					FlxG.sound.music.fadeOut((Conductor.crochet / 1000) * 5, 0);

					new FlxTimer().start((Conductor.crochet / 1000) * 5, function(money:FlxTimer)
					{
						opponent.visible = true;
						bfTankCutsceneLayer.remove(tankCutscene);
					});

					startCountdown();
				});
			});
		});
		#end
	}

	private function gunsIntro()
	{
		inCutscene = true;

		#if html5
		blackShit = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackShit.scrollFactor.set();
		add(blackShit);

		game.playVideo('gunsCutscene');
		#else
		FlxG.sound.playMusic(Paths.music('DISTORTO'), 0);
		FlxG.sound.music.fadeIn(5, 0, 0.5);

		cameraMovement(opponent);

		FlxTween.tween(camGAME, {zoom: zoom * 1.3}, 4, {ease: FlxEase.quadInOut, onUpdate: function(twn:FlxTween) {
			FlxG.camera.zoom = camGAME.zoom;
		}});

		opponent.visible = false;
		var tankCutscene:FlxAnimate = new FlxAnimate(opponent.x + 400, opponent.y + 200, 'assets/week7/images/cutsceneStuff/gunsIntro');
		tankCutscene.anim.addBySymbol('open fire', 'TANK TALK 2', 24, false);
		bfTankCutsceneLayer.add(tankCutscene);

		tankCutscene.anim.play('open fire');

		var eduardoAhh:FlxSound = FlxG.sound.load(Paths.sound('tankSong2'));
		eduardoAhh.play(true);

		new FlxTimer().start(4.1, function(ugly:FlxTimer)
		{
			FlxTween.tween(camGAME, {zoom: zoom * 1.4}, 0.4, {ease: FlxEase.quadOut, onUpdate: function(twn:FlxTween) {
				FlxG.camera.zoom = camGAME.zoom;
			}});
			FlxTween.tween(camGAME, {zoom: zoom * 1.3}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.45, onUpdate: function(twn:FlxTween) {
				FlxG.camera.zoom = camGAME.zoom;
			}});

			gf.playAnim('sad');
		});

		new FlxTimer().start(11, function(tmr:FlxTimer)
		{
			FlxG.sound.music.fadeOut((Conductor.crochet / 1000) * 5, 0);

			FlxTween.tween(camGAME, {zoom: zoom}, (Conductor.crochet * 5) / 1000, {ease: FlxEase.quartIn});
			startCountdown();
			new FlxTimer().start((Conductor.crochet * 25) / 1000, function(daTim:FlxTimer)
			{
				opponent.visible = true;
				bfTankCutsceneLayer.remove(tankCutscene);
			});
		});
		#end
	}

	private function stressIntro()
	{
		inCutscene = true;

		#if html5
		blackShit = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackShit.scrollFactor.set();
		add(blackShit);

		game.playVideo('stressCutscene');
		#else
		camFollow.setPosition(camPos.x, camPos.y);
		opponent.visible = false;
		gf.visible = false;

		var gfTankmen:FlxSprite = new FlxSprite(210, 70);
		gfTankmen.frames = Paths.getSparrowAtlas('characters/gfTankmen');
		gfTankmen.animation.addByPrefix('loop', 'GF Dancing at Gunpoint', 24, true);
		gfTankmen.animation.play('loop');
		gfCutsceneLayer.add(gfTankmen);

		var tankCutscene:FlxAnimate = new FlxAnimate(opponent.x + 400, opponent.y + 200, 'assets/week7/images/cutsceneStuff/stressIntro');
		tankCutscene.anim.addBySymbol('god damn', 'TANK TALK 3 P1 UNCUT', 24, false);
		tankCutscene.anim.addBySymbol('pico reference', 'TANK TALK 3 P2 UNCUT', 24, false);
		bfTankCutsceneLayer.add(tankCutscene);

		tankCutscene.anim.play('god damn');

		camFollow.setPosition(gf.x + 350, gf.y + 560);
		camGAME.focusOn(camFollow.getPosition());

		player.visible = false;

		var fakeBF:Character = new Character(player.x, player.y, 'bf', true);
		bfTankCutsceneLayer.add(fakeBF);

		/*var picoCutscene:FlxAnimate = new FlxAnimate(-20, 320, Paths.getLibraryPath('images/cutscenceStuff/goPicoYeahYeah', 'week7'));
		picoCutscene.anim.addBySymbol('holy', 'pico go wild', 24, false);
		picoCutscene.anim.addBySymbol('loop', 'idle', 24, true);
		gfCutsceneLayer.add(picoCutscene);
		picoCutscene.visible = false;*/

		var cutsceneAudio:FlxSound = FlxG.sound.load(Paths.sound('stressCutscene'));

		cutsceneAudio.play(true);

		camGAME.zoom = zoom * 1.15;

		camFollow.x -= 200;

		new FlxTimer().start(31.5, function(cunt:FlxTimer)
		{
			camFollow.x += 400;
			camFollow.y += 150;
			camGAME.zoom = zoom * 1.4;
			FlxTween.tween(camGAME, {zoom: camGAME.zoom + 0.1}, 0.5, {ease: FlxEase.elasticOut, onUpdate: function(twn:FlxTween) {
				FlxG.camera.zoom = camGAME.zoom;
			}});
			camGAME.focusOn(camFollow.getPosition());
			player.playAnim('singUPmiss');
			player.animation.finishCallback = function(animFinish:String)
			{
				camFollow.x -= 400;
				camFollow.y -= 150;
				camGAME.zoom /= 1.4;
				camGAME.focusOn(camFollow.getPosition());

				player.animation.finishCallback = null;
			};
		});

		new FlxTimer().start(15.1, function(tmr:FlxTimer)
		{
			camFollow.y -= 170;
			camFollow.x += 200;
			FlxTween.tween(FlxG.camera, {zoom: camGAME.zoom * 1.3}, 2.1, {
				ease: FlxEase.quadInOut, onUpdate: function(twn:FlxTween) {
					FlxG.camera.zoom = camGAME.zoom;
				}
			});

			new FlxTimer().start(2.2, function(swagTimer:FlxTimer)
			{
				camGAME.zoom = 0.8;
				player.playAnim('bfCatch');

				player.visible = true;
				bfTankCutsceneLayer.remove(fakeBF);

				player.animation.finishCallback = function(anim:String)
				{
					player.playAnim('idle');
					player.animation.finishCallback = null;
				};

				new FlxTimer().start(3, function(weedShitBaby:FlxTimer)
				{
					camFollow.y += 180;
					camFollow.x -= 80;
				});

				new FlxTimer().start(2.3, function(gayLol:FlxTimer)
				{
					tankCutscene.anim.play('pico reference');
				});
			});

			/*picoCutscene.alpha = 1;
			picoCutscene.anim.play('holy');
			picoCutscene.anim.onComplete = function()
			{
				picoCutscene.anim.play('idle');
				picoCutscene.anim.onComplete = null;
			};*/

			new FlxTimer().start(20, function(alsoTmr:FlxTimer)
			{
				opponent.visible = true;
				gf.visible = true;
				bfTankCutsceneLayer.remove(tankCutscene);
				player.animation.finishCallback = null;
				startCountdown();

				gfCutsceneLayer.remove(gfTankmen);
				//gfCutsceneLayer.remove(picoCutscene);
			});
		});
		#end
	}

	#if html5
	override public function endingVideo()
	{
		remove(blackShit);
		FlxTween.tween(FlxG.camera, {zoom: zoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});
	}
	#end

    override public function update(elapsed:Float)
    {
        moveTank();
    }

    private function moveTank():Void
	{
		if (!inCutscene)
		{
			var daAngleOffset:Float = 1;
			tankAngle += FlxG.elapsed * tankSpeed;
			tankGround.angle = tankAngle - 90 + 15;

			tankGround.x = tankX + Math.cos(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1500;
			tankGround.y = 1300 + Math.sin(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1100;
		}
	}

	private var tankResetShit:Bool = false;
	private var tankMoving:Bool = false;
	private var tankAngle:Float = FlxG.random.int(-90, 45);
	private var tankSpeed:Float = FlxG.random.float(5, 7);
	private var tankX:Float = 400;

    override public function beatHit()
    {
        foregroundSprites.forEach(function(spr:BGSprite)
		{
			spr.dance();
		});

        tankWatchtower.dance();
    }
}
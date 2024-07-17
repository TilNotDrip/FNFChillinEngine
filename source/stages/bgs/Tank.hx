package stages.bgs;

import objects.game.BGSprite;
import objects.game.Character;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import stages.objects.TankmenBG;

class Tank extends StageBackend
{
	private var foregroundSprites:FlxTypedGroup<BGSprite>;

	private var tankmanRun:FlxTypedGroup<TankmenBG>;
	private var tankWatchtower:BGSprite;
	private var tankGround:BGSprite;

	override public function create()
	{
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

	override public function createPost()
	{
		switch (PlayState.SONG.metadata.gf)
		{
			case 'pico-speaker':
				gfGroup.x -= 50;
				gfGroup.y -= 200;

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

		gfGroup.y += 10;
		gfGroup.x -= 30;
		playerGroup.x += 40;
		playerGroup.y += 0;
		opponentGroup.y += 60;
		opponentGroup.x -= 80;

		if (PlayState.SONG.metadata.gf != 'pico-speaker')
		{
			gfGroup.x -= 170;
			gfGroup.y -= 75;
		}

		add(foregroundSprites);

		if (isStoryMode)
		{
			blackShit = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			add(blackShit);

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

	var blackShit:FlxSprite;

	private function ughIntro()
	{
		#if FUNKIN_VIDEOS
		game.playVideo('ughCutscene');
		#end
	}

	private function gunsIntro()
	{
		#if FUNKIN_VIDEOS
		game.playVideo('gunsCutscene');
		#end
	}

	private function stressIntro()
	{
		#if FUNKIN_VIDEOS
		game.playVideo('stressCutscene');
		#end
	}

	#if (VIDEOS && !hxvlc)
	override public function endingVideo()
	{
		remove(blackShit);
		FlxTween.tween(FlxG.camera, {zoom: zoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});
	}
	#end

	override public function update(elapsed:Float)
	{
		moveTank();
		super.update(elapsed);
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

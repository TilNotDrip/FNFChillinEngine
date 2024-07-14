package stages.bgs;

import objects.game.BGSprite;
import objects.game.Character;
import shaders.OverlayBlend;
import stages.objects.BackgroundDancer;

class Limo extends StageBackend
{
	private var limo:BGSprite;
	private var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	private var fastCar:FlxSprite;

	override public function create()
	{
		zoom = 0.90;

		var skyOverlay:OverlayBlend = new OverlayBlend();
		var sunOverlay:FlxSprite = new FlxSprite().loadGraphic(Paths.image('limo/limoOverlay'));
		sunOverlay.setGraphicSize(Std.int(sunOverlay.width * 2));
		sunOverlay.updateHitbox();
		skyOverlay.funnyShit.input = sunOverlay.pixels;

		var limoSunset:BGSprite = new BGSprite('limo/limoSunset', -120, -50, 0.1, 0.1);
		limoSunset.shader = skyOverlay;
		add(limoSunset);

		var bgLimo:BGSprite = new BGSprite('limo/bgLimo', -200, 480, 0.4, 0.4, ['background limo pink'], true);
		add(bgLimo);

		grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
		add(grpLimoDancers);

		for (i in 0...5)
		{
			var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
			dancer.scrollFactor.set(0.4, 0.4);
			grpLimoDancers.add(dancer);
		}

		limo = new BGSprite('limo/limoDrive', -120, 550, 1, 1, ['Limo stage']);

		fastCar = new BGSprite('limo/fastCarLol', -300, 160);
	}

	override public function createPost()
	{
		addBehindOpponent(limo);

		resetFastCar();
		add(fastCar);

		playerGroup.y -= 220;
		playerGroup.x += 260;

		if (FlxG.random.bool(0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001)) // finger slipped
		{
			var sunOverlay:FlxSprite = new FlxSprite(-398, -304).loadGraphic(Paths.image('limo/limoOverlay'));
			sunOverlay.setGraphicSize(Std.int(sunOverlay.width * 0.76));
			sunOverlay.updateHitbox();
			sunOverlay.alpha = 0.465;
			sunOverlay.scrollFactor.set(0.2, 0.2);
			sunOverlay.blend = ADD; // into your fucking face crusher
			add(sunOverlay);
		}
	}

	override public function cameraMovement(char:Character)
	{
		if (char == player)
			camFollow.x = player.getMidpoint().x - 300;
	}

	private var fastCarCanDrive:Bool = true;

	private function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	private function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	override public function beatHit()
	{
		grpLimoDancers.forEach(function(dancer:BackgroundDancer)
		{
			dancer.dance();
		});

		if (FlxG.random.bool(10) && fastCarCanDrive)
			fastCarDrive();
	}
}

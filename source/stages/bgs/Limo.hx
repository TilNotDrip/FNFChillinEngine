package stages.bgs;

import stages.objects.BackgroundDancer;

class Limo extends StageBackend
{
    var limo:BGSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

    override function create()
    {
        zoom = 0.90;

		var skyBG:BGSprite = new BGSprite('limo/limoSunset', -120, -50, 0.1, 0.1);
		add(skyBG);

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

    override function createPost()
    {
        addBehindOpponent(limo);

        resetFastCar();
		add(fastCar);

        player.y -= 220;
		player.x += 260;
    }

    override function cameraMovement(char:objects.Character)
    {
        if (char == player)
            camFollow.x = player.getMidpoint().x - 300;
    }

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

    override function beatHit()
    {
		if (PreferencesMenu.getPref('camera-zoom') && curSong.formatToPath() == 'milf' && curBeat >= 168 && curBeat < 200 && camGAME.zoom < 1.35)
		{
			camGAME.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

        grpLimoDancers.forEach(function(dancer:BackgroundDancer)
        {
            dancer.dance();
        });

        if (FlxG.random.bool(10) && fastCarCanDrive)
            fastCarDrive();
    }
}
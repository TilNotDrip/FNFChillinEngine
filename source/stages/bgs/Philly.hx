package stages.bgs;

import objects.game.BGSprite;

import shaders.BuildingShaders;

class Philly extends StageBackend
{
	private var phillyCityLight:BGSprite;
	private var phillyTrain:BGSprite;
	private var trainSound:FlxSound;
	private var phillyLightColors:Array<FlxColor> = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];

    private var lightFadeShader:BuildingShaders;

    private var curLight:Int = 0;
	private var oldLight:Int = 0;

    override public function create()
    {
        var bg:BGSprite = new BGSprite('philly/sky', -100, 0, 0.1, 0.1);
        add(bg);

        var city:BGSprite = new BGSprite('philly/city', -10, 0, 0.3, 0.3);
        city.setGraphicSize(Std.int(city.width * 0.85));
        city.updateHitbox();
        add(city);

        lightFadeShader = new BuildingShaders();

        phillyCityLight = new BGSprite('philly/win', city.x, 0, 0.3, 0.3);
        phillyCityLight.setGraphicSize(Std.int(phillyCityLight.width * 0.85));
        phillyCityLight.shader = lightFadeShader.shader;
        phillyCityLight.updateHitbox();
        add(phillyCityLight);

        var randomFirstLight:Int = FlxG.random.int(0, phillyLightColors.length - 1);
        phillyCityLight.color = phillyLightColors[curLight];

        var streetBehind:BGSprite = new BGSprite('philly/behindTrain', -40, 50);
        add(streetBehind);

        phillyTrain = new BGSprite('philly/train', 2000, 360);
        add(phillyTrain);

        trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
        FlxG.sound.list.add(trainSound);

        var street:BGSprite = new BGSprite('philly/street', -40, streetBehind.y);
        add(street);
    }

    override public function update(elapsed:Float)
    {
        if (trainMoving)
        {
            trainFrameTiming += elapsed;

            if (trainFrameTiming >= 1 / 24)
            {
                updateTrainPos();
                trainFrameTiming = 0;
            }
        }

        lightFadeShader.update((Conductor.crochet / 1000) * FlxG.elapsed * 1.5);
    }

	private var trainMoving:Bool = false;
	private var trainFrameTiming:Float = 0;

	private var trainCars:Int = 8;
	private var trainFinishing:Bool = false;
	private var trainCooldown:Int = 0;

	private function trainStart():Void
	{
		trainMoving = true;
		trainSound.play(true);
	}

	private var startedMoving:Bool = false;

	private function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	private function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

    override public function beatHit()
    {
        if (!trainMoving)
            trainCooldown += 1;

        if (Conductor.curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
        {
            trainCooldown = FlxG.random.int(-4, 0);
            trainStart();
        }
    }

    override public function sectionHit()
    {
        lightFadeShader.reset();
        while(oldLight == curLight) curLight = FlxG.random.int(0, phillyLightColors.length - 1);
        phillyCityLight.color = phillyLightColors[curLight];
        oldLight = curLight;
    }
}
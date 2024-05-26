package stages.bgs;

import flixel.math.FlxPoint;
import objects.game.BGSprite;
import flixel.addons.display.FlxTiledSprite;
import flxanimate.FlxAnimate;

class Streets extends StageBackend
{
    var scrollingSky:FlxTiledSprite;

	var pupilState:PupilState = NORMAL;

	var abot:FlxAnimate;
	// var abotViz:ABotVis;
	var stereoBG:FlxSprite;
	var eyeWhites:FlxSprite;
	var pupil:FlxAnimate;

    var car1:BGSprite;
    var car2:BGSprite;
    var traffic:BGSprite;
    override public function create()
    {
        zoom = 0.77;

        scrollingSky = new FlxTiledSprite(Paths.image('phillyStreets/phillySkybox'), 2922, 718, true, false);
		scrollingSky.setPosition(-650, -375);
		scrollingSky.scrollFactor.set(0.1, 0.1);
		scrollingSky.scale.set(0.65, 0.65);
        add(scrollingSky);

        var skyline:BGSprite = new BGSprite('phillyStreets/phillySkyline', -545, -273, 0.2, 0.2);
        add(skyline);

        var foregroundCity:BGSprite = new BGSprite('phillyStreets/phillyForegroundCity', 625, 94, 0.3, 0.3);
        add(foregroundCity);

        var construction:BGSprite = new BGSprite('phillyStreets/phillyConstruction', 1800, 364, 0.7, 1);
        add(construction);

        var highwayLights:BGSprite = new BGSprite('phillyStreets/phillyHighwayLights', 284, 305);
        add(highwayLights);

        var highwayLightmap:BGSprite = new BGSprite('phillyStreets/phillyHighwayLights_lightmap', 284, 305);
		highwayLightmap.blend = ADD;
        add(highwayLightmap);

        var highway:BGSprite = new BGSprite('phillyStreets/phillyHighway', 139, 209);
        add(highway);

        var smog:BGSprite = new BGSprite('phillyStreets/phillySmog', -6, 245);
        add(smog);

        car1 = new BGSprite('phillyStreets/phillyCars', 1748, 818, 1, 1, ['car1', 'car2', 'car3', 'car4']);
        add(car1);

        car2 = new BGSprite('phillyStreets/phillyCars', 1748, 818, 1, 1, ['car1', 'car2', 'car3', 'car4']);
        car2.flipX = true;
        add(car2);

        traffic = new BGSprite('phillyStreets/phillyTraffic', 1840, 608, 0.9, 1, ['redtogreen', 'greentored']);
        add(traffic);

		var trafficLightMap:BGSprite = new BGSprite('phillyStreets/phillyTraffic_lightmap', 1840, 608, 0.9, 1);
		trafficLightMap.blend = ADD;
        add(trafficLightMap);

        var foreground:BGSprite = new BGSprite('phillyStreets/phillyForeground', 88, 317);
        add(foreground);


		// FlxG.debugger.track(abot);
		// FlxG.debugger.track(pupil);
    }

    override public function createPost()
    {
        var sprayCans:BGSprite = new BGSprite('SpraycanPile', 920, 1045);
        add(sprayCans);

		var globalOffset:Array<Int> = [-290, -450];
        playerGroup.setPosition(2151 + globalOffset[0], 1228 + globalOffset[1]);
        gfGroup.setPosition(1453 + globalOffset[0], 900 + globalOffset[1]);
        opponentGroup.setPosition(900 + globalOffset[0], 1110 + globalOffset[1]);

		// a-bot!!
		eyeWhites = new FlxSprite().makeGraphic(160, 60, FlxColor.WHITE);
		addBehindGF(eyeWhites);

		stereoBG = new FlxSprite(0, 0, Paths.image('characters/abot/stereoBG'));
		addBehindGF(stereoBG);

		pupil = new FlxAnimate(0, 0, Paths.atlas("characters/abot/systemEyes", 'shared'));
		//pupil.scrollFactor.set();
		addBehindGF(pupil);

		//viz

		abot = new FlxAnimate(0, 0, Paths.atlas("characters/abot/abotSystem", 'shared'));
		//abot.scrollFactor.set();
		addBehindGF(abot);

		//pupil.scrollFactor.set(1, 1);
		//abot.scrollFactor.set(1, 1);
    }

    override public function update(elapsed:Float)
    {
        if(scrollingSky != null) scrollingSky.scrollX -= FlxG.elapsed * 22;

		abot.x = gfGroup.x - 100;
		abot.y = gfGroup.y + 316; // 764 - 740

		eyeWhites.x = abot.x + 40;
		eyeWhites.y = abot.y + 250;

		pupil.x = gfGroup.x - 607;
		pupil.y = gfGroup.y - 176;

		stereoBG.x = abot.x + 150;
		stereoBG.y = abot.y + 30;

		if (pupil.anim.isPlaying)
		{
			switch (pupilState)
			{
				case NORMAL:
					if (pupil.anim.curFrame >= 17)
					{
						//pupilState = NORMAL;
						pupil.anim.pause();
					}

				case LEFT:
					if (pupil.anim.curFrame >= 31)
					{
						//pupilState = LEFT;
						pupil.anim.pause();
					}

			}
		}
    }

	override public function cameraMovement(char:objects.game.Character)
	{
		if(char == game.dad && pupilState == LEFT)
		{
			pupilState = NORMAL;
			pupil.anim.play('', true);
			pupil.anim.curFrame = 17;
		}

		if(char == game.boyfriend && pupilState == NORMAL)
		{
			pupilState = LEFT;
			pupil.anim.play('', true);
			pupil.anim.curFrame = 0;
		}
	}

    var lightsStop:Bool = false;
    var lastChange:Int = 0;
	var changeInterval:Int = 8; // make sure it doesnt change until AT LEAST this many beats
    override public function beatHit()
	{
		super.beatHit();

		// Try driving a car when its possible
		if (FlxG.random.bool(10) && Conductor.curBeat != (lastChange + changeInterval) && carInterruptable)
		{
			if(!lightsStop)
				driveCar(car1);
			else
				driveCarLights(car1);
		}

		// try driving one on the right too. in this case theres no red light logic, it just can only spawn on green lights
		if(FlxG.random.bool(10) && Conductor.curBeat != (lastChange + changeInterval) && car2Interruptable && !lightsStop) 
            driveCarBack(car2);

		// After the interval has been hit, change the light state.
		if (Conductor.curBeat == (lastChange + changeInterval)) 
            changeLights(Conductor.curBeat);
	}

    var carWaiting:Bool = false; // if the car is waiting at the lights and is ready to go on green
	var carInterruptable:Bool = true; // if the car can be reset
	var car2Interruptable:Bool = true;

    /**
     * Drives a car towards the lights and stops.
     * Used when a car tries to drive while the lights are red.
    */
	function driveCarLights(sprite:FlxSprite):Void{
		carInterruptable = false;
		FlxTween.cancelTweensOf(sprite);

		var variant:Int = FlxG.random.int(1,4);
		sprite.animation.play('car' + variant);

		var extraOffset = [0, 0];
		var duration:Float = 2;
		switch(variant)
        {
			case 1:
				duration = FlxG.random.float(1, 1.7);
			case 2:
				extraOffset = [20, -15];
				duration = FlxG.random.float(0.9, 1.5);
			case 3:
				extraOffset = [30, 50];
				duration = FlxG.random.float(1.5, 2.5);
			case 4:
				extraOffset = [10, 60];
				duration = FlxG.random.float(1.5, 2.5);
		}

		var rotations:Array<Int> = [-7, -5];
		var offset:Array<Float> = [306.6, 168.3];
		sprite.offset.set(extraOffset[0], extraOffset[1]);

		var path:Array<FlxPoint> = [
			FlxPoint.get(1500 - offset[0] - 20, 1049 - offset[1] - 20),
			FlxPoint.get(1770 - offset[0] - 80, 994 - offset[1] + 10),
			FlxPoint.get(1950 - offset[0] - 80, 980 - offset[1] + 15)
		];
		
		FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.cubeOut});
		FlxTween.quadPath(sprite, path, duration, true,
        {
            ease: FlxEase.cubeOut,
	        onComplete: function(_) 
            {
                carWaiting = true;

		        if(!lightsStop) 
                   finishCarLights(car1);
            }
        });
	}

	/**
     * Drives a car across the screen without stopping.
     * Used when the lights are green.
    */
	function driveCar(sprite:FlxSprite):Void
    {
		carInterruptable = false;
		FlxTween.cancelTweensOf(sprite);

		var variant:Int = FlxG.random.int(1,4);
		sprite.animation.play('car' + variant);

		// setting an offset here because the current implementation of stage prop offsets was not working at all for me
		// if possible id love to not have to do this but im keeping this for now
		var extraOffset = [0, 0];
		var duration:Float = 2;

		// set different values of speed for the car types (and the offset)
		switch(variant)
        {
			case 1:
				duration = FlxG.random.float(1, 1.7);
			case 2:
				extraOffset = [20, -15];
				duration = FlxG.random.float(0.6, 1.2);
			case 3:
				extraOffset = [30, 50];
				duration = FlxG.random.float(1.5, 2.5);
			case 4:
				extraOffset = [10, 60];
				duration = FlxG.random.float(1.5, 2.5);
		}

		// random arbitrary values for getting the cars in place
		// could just add them to the points but im LAZY!!!!!!
		var offset:Array<Float> = [306.6, 168.3];
		sprite.offset.set(extraOffset[0], extraOffset[1]);

		// start/end rotation
		var rotations:Array<Int> = [-8, 18];

		// the path to move the car on
		var path:Array<FlxPoint> = 
        [
				FlxPoint.get(1570 - offset[0], 1049 - offset[1] - 30),
				FlxPoint.get(2400 - offset[0], 980 - offset[1] - 50),
				FlxPoint.get(3102 - offset[0], 1127 - offset[1] + 40)
		];

		FlxTween.angle(sprite, rotations[0], rotations[1], duration, null );
		FlxTween.quadPath(sprite, path, duration, true,
        {
            ease: null,
			onComplete: function(_) {
      	        carInterruptable = true;
      	    }
        });
	}

	function driveCarBack(sprite:FlxSprite):Void
    {
		car2Interruptable = false;
		FlxTween.cancelTweensOf(sprite);

		var variant:Int = FlxG.random.int(1,4);
		sprite.animation.play('car' + variant);

		// setting an offset here because the current implementation of stage prop offsets was not working at all for me
		// if possible id love to not have to do this but im keeping this for now
		var extraOffset = [0, 0];
		var duration:Float = 2;

		// set different values of speed for the car types (and the offset)
		switch(variant)
        {
			case 1:
				duration = FlxG.random.float(1, 1.7);
			case 2:
				extraOffset = [20, -15];
	    		duration = FlxG.random.float(0.6, 1.2);
	    	case 3:
	    		extraOffset = [30, 50];
	    		duration = FlxG.random.float(1.5, 2.5);
	    	case 4:
	    		extraOffset = [10, 60];
	    		duration = FlxG.random.float(1.5, 2.5);
	    }

	    // random arbitrary values for getting the cars in place
	    // could just add them to the points but im LAZY!!!!!!
	    var offset:Array<Float> = [306.6, 168.3];
	    sprite.offset.set(extraOffset[0], extraOffset[1]);

	    // start/end rotation
	    var rotations:Array<Int> = [18, -8];
        
	    // the path to move the car on
	    var path:Array<FlxPoint> = [
	    	FlxPoint.get(3102 - offset[0], 1127 - offset[1] + 60),
	    	FlxPoint.get(2400 - offset[0], 980 - offset[1] - 30),
	    	FlxPoint.get(1570 - offset[0], 1049 - offset[1] - 10)
	  	];

	    FlxTween.angle(sprite, rotations[0], rotations[1], duration, null);

	    FlxTween.quadPath(sprite, path, duration, true,
        {
            ease: null,
	    	onComplete: function(_) 
            {
          	    car2Interruptable = true;
            }
        });
	}

    function finishCarLights(sprite:FlxSprite):Void
    {
		carWaiting = false;

		var duration:Float = FlxG.random.float(1.8, 3);
		var rotations:Array<Int> = [-5, 18];
		var offset:Array<Float> = [306.6, 168.3];
		var startdelay:Float = FlxG.random.float(0.2, 1.2);

		var path:Array<FlxPoint> = [
			FlxPoint.get(1950 - offset[0] - 80, 980 - offset[1] + 15),
			FlxPoint.get(2400 - offset[0], 980 - offset[1] - 50),
			FlxPoint.get(3102 - offset[0], 1127 - offset[1] + 40)
		];

		FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.sineIn, startDelay: startdelay});

		FlxTween.quadPath(sprite, path, duration, true,
        {
            ease: FlxEase.sineIn,
		    startDelay: startdelay,
		    onComplete: function(_) 
            {
                carInterruptable = true;
            }
        });
	}

    function changeLights(beat:Int):Void
    {
		lastChange = beat;
		lightsStop = !lightsStop;

		if(lightsStop)
        {
			traffic.animation.play('greentored');
			changeInterval = 20;
		} 
        else 
        {
			traffic.animation.play('redtogreen');
			changeInterval = 30;

			if(carWaiting) 
                finishCarLights(car1);
		}
	}
}

enum abstract PupilState(Int)
{
	var NORMAL = 0;
	var LEFT = 1;
}
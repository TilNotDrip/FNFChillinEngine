package substates;

import flixel.FlxObject;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:objects.Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";
	var randomGameover:Int = 1;

	public function new(x:Float, y:Float)
	{
		var daBf:String = '';
		if (PlayState.isPixel)
		{
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
		}
		else
			daBf = 'bf';

		var daSong = PlayState.SONG.song.toLowerCase();

		switch (daSong)
		{
			case 'stress':
				daBf = 'bf-holding-gf-dead';
		}

		super();

		Conductor.songPosition = 0;

		bf = new objects.Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

		var randomCensor:Array<Int> = [];

		if (PreferencesMenu.getPref('censor-naughty'))
			randomCensor = [1, 3, 8, 13, 17, 21];

		randomGameover = FlxG.random.int(1, 25, randomCensor);
	}

	var playingDeathSound:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new states.StoryMenuState());
			else
				FlxG.switchState(new states.FreeplayState());
		}

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new states.AnimationDebug(bf.curCharacter));
		#end

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		switch (PlayState.storyWeek)
		{
			case 7:
				if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished && !playingDeathSound)
				{
					playingDeathSound = true;

					bf.startedDeath = true;
					coolStartDeath(0.2);

					FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + randomGameover), 1, false, null, true, function()
					{
						if (!isEnding)
							FlxG.sound.music.fadeIn(4, 0.2, 1);
					});
				}
			default:
				if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
				{
					bf.startedDeath = true;
					coolStartDeath();
				}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	private function coolStartDeath(?vol:Float = 1):Void
	{
		if (!isEnding)
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), vol);
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}

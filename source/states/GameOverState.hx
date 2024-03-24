package states;

class GameOverState extends MusicBeatState
{
	var stageSuffix:String = "";
	var randomGameover:Int = 1;

	public function new()
	{
		if (PlayState.isPixel)
			stageSuffix = '-pixel';

		super();

		Conductor.songPosition = 0;
		Conductor.changeBPM(100);

		var randomCensor:Array<Int> = [];

		if (PreferencesMenu.getPref('censor-naughty'))
			randomCensor = [1, 3, 8, 13, 17, 21];

		randomGameover = FlxG.random.int(1, 25, randomCensor);
	}

	override function create()
	{
		Application.current.window.title += ' [Secret Game Over]';

		var loser:FlxSprite = new FlxSprite(100, 100);
		loser.frames = Paths.getSparrowAtlas('lose');
		loser.animation.addByPrefix('lose', 'lose', 24, false);
		loser.animation.play('lose');
		add(loser);

		var restart:FlxSprite = new FlxSprite(500, 50).loadGraphic(Paths.image('restart'));
		restart.setGraphicSize(Std.int(restart.width * 0.6));
		restart.updateHitbox();
		restart.alpha = 0;
		add(restart);

		FlxTween.tween(restart, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(restart, {y: restart.y + 40}, 7, {ease: FlxEase.quartInOut, type: PINGPONG});

		super.create();
	}

	var playingDeathSound:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			FlxG.sound.music.fadeOut(0.5, 0, function(twn:FlxTween)
			{
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
				LoadingState.loadAndSwitchState(new PlayState());
			});
		}

		if (controls.BACK)
		{
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		if (PlayState.storyWeek.name == 'week7')
		{
			if (!playingDeathSound)
			{
				playingDeathSound = true;

				FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), 0.2);

				FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + randomGameover), 1, false, null, true, function()
				{
					FlxG.sound.music.fadeIn(4, 0.2, 1);
				});					
			}
		}
		else
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), 1);

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}
}

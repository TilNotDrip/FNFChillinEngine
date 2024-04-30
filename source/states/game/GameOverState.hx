package states.game;

import objects.game.DeathCharacter;

class GameOverState extends MusicBeatState
{
	public var deadCharacter:DeathCharacter;
	public var curCharacter = 'bf-dead';

	private var startVol:Float = 1;
	private var stageSuffix:String = '';

	private var randomGameover:Int = 1;

	public function new(character:String = 'bf-dead')
	{
		curCharacter = character;

		super();
	}

	override public function create()
	{
		Application.current.window.title += ' [Secret Game Over]';

		#if DISCORD
		DiscordRPC.details = PlayState.game.rpcDetailsText + ' [Game Over (Secret)]';
		DiscordRPC.state = 'Deaths: ' + PlayState.deathCounter;
		#end

		Conductor.songPosition = 0;

		deadCharacter = new DeathCharacter(0, 0, curCharacter);

		if (deadCharacter.isPixel)
			stageSuffix = '-pixel';

		var loser:FlxSprite = new FlxSprite(100, 100);
		loser.frames = Paths.getSparrowAtlas('gameOver/lose');
		loser.animation.addByPrefix('lose', 'lose...', 24, false);
		loser.animation.play('lose');
		add(loser);

		var restart:FlxSprite = new FlxSprite(500, 50).loadGraphic(Paths.image('gameOver/restart'));
		restart.setGraphicSize(Std.int(restart.width * 0.6));
		restart.updateHitbox();
		restart.alpha = 0;
		add(restart);

		FlxTween.tween(restart, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(restart, {y: restart.y + 40}, 7, {ease: FlxEase.quartInOut, type: PINGPONG});

		if (PlayState.game.dad.curCharacter == 'tankman')
		{
			randomGameover = FlxG.random.int(1, 25);
			startVol = 0.2;
		}

		Conductor.changeBPM(100);

		if (FlxG.sound.music != null)
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), startVol);

		super.create();
	}

	private var playingDeathSound:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
			respawn();

		if (controls.BACK)
			despawn();

		if (PlayState.game.dad.curCharacter == 'tankman')
		{
			if (!playingDeathSound)
			{
				playingDeathSound = true;

				FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + randomGameover), 1, false, null, true, function()
				{
					FlxG.sound.music.fadeIn(4, 0.2, 1);
				});					
			}
		}

		if (FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;
	}

	private function respawn()
	{
		FlxG.sound.music.fadeOut(0.5, 0, function(twn:FlxTween)
		{
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			LoadingState.loadAndSwitchState(new PlayState());
		});
	}

	private function despawn()
	{
		PlayState.deathCounter = 0;
		PlayState.seenCutscene = false;
		PlayState.seenEndCutscene = false;

		FlxG.sound.music.stop();

		if (PlayState.isStoryMode)
			FlxG.switchState(new StoryMenuState());
		else
			FlxG.switchState(new FreeplayState());
	}
}

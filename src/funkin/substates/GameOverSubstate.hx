package funkin.substates;

import funkin.stages.StageBackend;
import flixel.FlxCamera;
import flixel.FlxObject;
import funkin.objects.game.Character;
import funkin.states.tools.AnimationDebug;

/**
 * A substate which renders over the PlayState when the player dies.
 * Displays the player death animation, plays the music, and handles restarting the song.
 *
 * The newest implementation uses a substate, which prevents having to reload the song and stage each reset.
 */
class GameOverSubstate extends MusicBeatSubstate
{
	/**
	 * The currently active GameOverSubState.
	 * There should be only one GameOverSubState in existance at a time, we can use a singleton.
	 */
	public static var instance:Null<GameOverSubstate> = null;

	/**
	 * The character displayed on the death screen.
	 */
	public var character:Null<Character> = null;

	/**
	 * The UI.
	 *
	 * This controls what type of sound and music is played.
	 *
	 * This is set by the character.
	 */
	public var ui:String = 'funkin';

	/**
	 * The invisible object in the scene which the camera focuses on.
	 */
	var cameraFollowPoint:FlxObject;

	/**
	 * The music playing in the background of the state.
	 */
	var gameOverMusic:Null<FlxSound> = null;

	/**
	 * Whether the player has confirmed and prepared to restart the level or to go back to the freeplay menu.
	 * This means the animation and transition have already started.
	 */
	var isEnding:Bool = false;

	/**
	 * Whether the death music is on its first loop.
	 */
	var isStarting:Bool = true;

	var isChartingMode:Bool = false;

	var transparent:Bool;

	var secretGameover:Bool = false;

	public function new(params:GameOverParams)
	{
		super();

		isChartingMode = params?.isChartingMode ?? false;
		transparent = params.transparent;
		secretGameover = params?.secretGameover ?? false;

		cameraFollowPoint = new FlxObject(FlxG.camera.x, FlxG.camera.y, 1, 1);

		// TODO: How the fuck did FunkinCrew use FlxG.camera is it cuz of persistent update or what?
		camera = FlxG.camera;
	}

	override public function create():Void
	{
		instance = this;

		Application.current.window.title += ' [Game Over]';

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = PlayState.instance.rpcDetailsText + ' [Game Over]';
		DiscordRPC.state = 'Deaths: ' + PlayState.deathCounter;
		PlayState.instance.setRpcTimestamps(false);
		#end

		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		bg.alpha = transparent ? 0.25 : 1.0;
		bg.scrollFactor.set();
		bg.screenCenter();
		add(bg);

		character = new Character(StageBackend.stage.BF_POSITION[0], StageBackend.stage.BF_POSITION[1], PlayState.instance.boyfriend.deathChar, true);
		ui = character.ui;

		if (!secretGameover)
		{
			character.x += character.characterPosition[0];
			character.y += character.characterPosition[1];
			character.isDead = true;
			character.updateHitbox();
			add(character);
		}
		else
		{
			character.destroy();
			character = null;

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

			if (!playingJeffQuote && PlayState.instance.dad.curCharacter == 'tankman')
			{
				playingJeffQuote = true;
				playJeffQuote();
				playGameOverMusic(0.2);
			}
			else
			{
				playGameOverMusic(1);
			}
		}

		setupCamTarget();

		Conductor.songPosition = 0;
		Conductor.changeBPM(100);
	}

	function setupCamTarget():Void
	{
		if (character == null)
			return;

		cameraFollowPoint = new FlxObject(FlxG.camera.x, FlxG.camera.y, 1, 1);
		cameraFollowPoint.setPosition(character.getGraphicMidpoint().x, character.getGraphicMidpoint().y);
		cameraFollowPoint.x -= character.cameraPosition[0];
		cameraFollowPoint.y += character.cameraPosition[1];
		add(cameraFollowPoint);

		camera.target = null;
		camera.follow(cameraFollowPoint, LOCKON, 0.04 / 2);
	}

	var hasStartedAnimation:Bool = false;

	override public function update(elapsed:Float):Void
	{
		if (!hasStartedAnimation)
		{
			hasStartedAnimation = true;

			if (character != null)
			{
				character.playAnim('firstDeath', true, false, 0);
				playBlueballSfx();
			}
		}

		camera.zoom = MathUtil.smoothLerp(camera.zoom, 1.0, elapsed, 0.5);

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (character != null)
		{
			if (character?.animation?.curAnim?.name == 'firstDeath' && character?.animation?.curAnim?.finished)
			{
				if (!playingJeffQuote && PlayState.instance.dad.curCharacter == 'tankman')
				{
					playingJeffQuote = true;
					playJeffQuote();
					playGameOverMusic(0.2);
				}
				else
				{
					playGameOverMusic(1);
				}

				character.playAnim('deathLoop', true, false, 0);
			}
		}

		if (controls.ACCEPT)
		{
			confirmDeath();
		}

		if (controls.BACK)
		{
			FlxG.switchState((PlayState.isStoryMode) ? new StoryMenuState() : new FreeplayState());
		}

		super.update(elapsed);
	}

	function confirmDeath():Void
	{
		if (isEnding)
			return;

		isEnding = true;

		playGameOverMusic(1);

		if (character != null)
		{
			character.playAnim('deathConfirm', true, false, 0);
		}

		new FlxTimer().start(0.7, function(tmr:FlxTimer)
		{
			camera.fade(FlxColor.BLACK, 2, false, function()
			{
				camera.fade(FlxColor.BLACK, 1, true, null, true);
				LoadingState.loadAndSwitchState(new PlayState());
			});
		});
	}

	function playBlueballSfx():Void
	{
		FlxG.sound.play(Paths.sound('gameplay/$ui/fnf_loss_sfx'));
	}

	function playGameOverMusic(startVolume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music('gameplay/$ui/gameOver${isEnding ? 'End' : 'Start'}'), startVolume);
		gameOverMusic = FlxG.sound.music;
	}

	var playingJeffQuote:Bool = false;

	/**
	 * Week 7-specific hardcoded behavior, to play a custom death quote.
	 */
	function playJeffQuote():Void
	{
		FlxG.sound.play(Paths.sound('gameplay/jeffGameover/jeffGameover-' + FlxG.random.int(1, 25)), 1.0, false, null, true, function()
		{
			// Once the quote ends, fade in the game over music.
			if (!isEnding && gameOverMusic != null)
			{
				gameOverMusic.fadeIn(4, 0.2, 1);
			}
		});
	}
}

// TODO: Make a params package or just make a haxe file with all the params in there.

/**
 * Parameters used to instantiate a GameOverSubState.
 */
typedef GameOverParams =
{
	var isChartingMode:Bool;
	var transparent:Bool;
	var secretGameover:Bool;
}

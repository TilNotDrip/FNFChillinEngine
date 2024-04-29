package substates;

import flixel.FlxCamera;
import flixel.FlxObject;

import objects.game.DeathCharacter;

import states.tools.AnimationDebug;

class GameOverSubstate extends MusicBeatSubstate
{
	public var bf:String = '';
	public var deathChar:DeathCharacter;

	public var stageSuffix:String = '';
	private var startVol:Float = 1;

	private var camFollow:FlxObject;

	private var randomGameover:Int = 1;

	public function new(x:Float, y:Float, bf:String = '', camera:FlxCamera)
	{
		Application.current.window.title += ' [Game Over]';

		this.bf = bf;
		this.camera = camera;

		super();

		Conductor.songPosition = 0;

		deathChar = new DeathCharacter(x, y, bf);
		deathChar.playAnim('firstDeath');
		add(deathChar);

		if (deathChar.isPixel)
		{
			stageSuffix = '-pixel';
			deathChar.antialiasing = false;
		}

		camFollow = new FlxObject(deathChar.getGraphicMidpoint().x, deathChar.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		camera.scroll.set();
		camera.target = null;

		if (PlayState.game.dad.curCharacter == 'tankman')
		{
			randomGameover = FlxG.random.int(1, 25);
			startVol = 0.2;
		}

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);
	}

	private var playingDeathSound:Bool = false;
	private var isEnding:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
			respawn();

		if (controls.BACK)
			despawn();

		if (ChillSettings.get('devMode', OTHER) && FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(deathChar.curCharacter, true));

		if (deathChar.animation.curAnim.name == 'firstDeath')
		{
			if (deathChar.animation.curAnim.curFrame == 12)
				camera.follow(camFollow, LOCKON, 0.01);

			if (deathChar.animation.curAnim.finished)
			{
				if (PlayState.game.dad.curCharacter == 'tankman' && !playingDeathSound)
				{
					playingDeathSound = true;

					FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + randomGameover), 1, false, null, true, function()
					{
						if (!isEnding)
							FlxG.sound.music.fadeIn(4, 0.2, 1);
					});
				}

				deathChar.startedDeath = true;

				if (!isEnding)
					FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), startVol);
			}
		}

		if (FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;
	}

	private function respawn()
	{
		if (!isEnding)
		{
			isEnding = true;
			deathChar.playAnim('deathConfirm', true);

			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));

			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				PlayState.game.camGAME.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
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

package substates;

import flixel.FlxCamera;
import flixel.FlxObject;

import objects.game.Character;

import states.tools.AnimationDebug;

class GameOverSubstate extends MusicBeatSubstate
{
	public var bf:String = '';
	public var deathChar:Character;
	public var stageSuffix:String = "";

	private var camFollow:FlxObject;
	private var randomGameover:Int = 1;

	public function new(x:Float, y:Float, bf:String = '', camera:FlxCamera)
	{
		Application.current.window.title += ' [Game Over]';

		this.bf = bf;
		this.camera = camera;

		if (PlayState.isPixel)
			stageSuffix = '-pixel';

		super();

		Conductor.songPosition = 0;

		deathChar = new Character(x, y, bf, true);
		add(deathChar);

		if (deathChar.isPixel)
			deathChar.antialiasing = false;

		camFollow = new FlxObject(deathChar.getGraphicMidpoint().x, deathChar.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		camera.scroll.set();
		camera.target = null;

		deathChar.playAnim('firstDeath');

		randomGameover = FlxG.random.int(1, 25);
	}

	var playingDeathSound:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
			endBullshit();

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

		if (ChillSettings.get('devMode', OTHER) && FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(deathChar.curCharacter, true));

		if (deathChar.animation.curAnim.name == 'firstDeath' && deathChar.animation.curAnim.curFrame == 12)
			camera.follow(camFollow, LOCKON, 0.01);

		switch (PlayState.game.dad.curCharacter)
		{
			case 'tankman':
				if (deathChar.animation.curAnim.name == 'firstDeath' && deathChar.animation.curAnim.finished && !playingDeathSound)
				{
					playingDeathSound = true;

					deathChar.startedDeath = true;
					coolStartDeath(0.2);

					FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + randomGameover), 1, false, null, true, function()
					{
						if (!isEnding)
							FlxG.sound.music.fadeIn(4, 0.2, 1);
					});
				}
			default:
				if (deathChar.animation.curAnim.name == 'firstDeath' && deathChar.animation.curAnim.finished)
				{
					deathChar.startedDeath = true;
					coolStartDeath();
				}
		}

		if (FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;
	}

	private function coolStartDeath(?vol:Float = 1):Void
	{
		if (!isEnding)
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), vol);
	}

	private var isEnding:Bool = false;

	private function endBullshit():Void
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
}

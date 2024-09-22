package funkin.stages.bgs;

import funkin.objects.game.BGSprite;
import funkin.objects.game.Character;
import funkin.objects.game.DialogueBox;
import funkin.stages.objects.BackgroundGirls;

class School extends StageBackend
{
	var bgGirls:BackgroundGirls;

	override public function create()
	{
		GF_POSITION = [580.0, 430.0];
		BF_POSITION = [950.0, 670.0];

		ui = 'funkin-pixel';

		var bgSky = new BGSprite('weeb/weebSky', 0, 0, 0.1, 0.1);
		bgSky.antialiasing = false;
		add(bgSky);

		var repositionShit = -200;

		var bgSchool:BGSprite = new BGSprite('weeb/weebSchool', repositionShit, 0, 0.6, 0.90);
		bgSchool.scrollFactor.set(0.6, 0.90);
		bgSchool.antialiasing = false;
		add(bgSchool);

		var bgStreet:BGSprite = new BGSprite('weeb/weebStreet', repositionShit, 0, 0.95, 0.95);
		bgStreet.antialiasing = false;
		add(bgStreet);

		var fgTrees:BGSprite = new BGSprite('weeb/weebTreesBack', repositionShit + 170, 130, 0.9, 0.9);
		fgTrees.antialiasing = false;
		add(fgTrees);

		var bgTrees:BGSprite = new BGSprite('weeb/weebTrees', repositionShit - 380, -800, 0.85, 0.85, ['trees'], true);
		bgTrees.animation.curAnim.frameRate = 12;
		bgTrees.antialiasing = false;
		add(bgTrees);

		var treeLeaves:BGSprite = new BGSprite('weeb/petals', repositionShit, -40, 0.85, 0.85, ['PETALS ALL'], true);
		treeLeaves.antialiasing = false;
		add(treeLeaves);

		var widShit = Std.int(bgSky.width * 6);

		bgSky.setGraphicSize(widShit);
		bgSchool.setGraphicSize(widShit);
		bgStreet.setGraphicSize(widShit);
		bgTrees.setGraphicSize(Std.int(widShit * 1.4));
		fgTrees.setGraphicSize(Std.int(widShit * 0.8));
		treeLeaves.setGraphicSize(widShit);

		fgTrees.updateHitbox();
		bgSky.updateHitbox();
		bgSchool.updateHitbox();
		bgStreet.updateHitbox();
		bgTrees.updateHitbox();
		treeLeaves.updateHitbox();

		bgGirls = new BackgroundGirls(-100, 190);
		bgGirls.scrollFactor.set(0.9, 0.9);

		if (curSong.formatToPath() == 'roses')
			bgGirls.getScared();

		bgGirls.setGraphicSize(Std.int(bgGirls.width * PlayState.daPixelZoom));
		bgGirls.updateHitbox();
		add(bgGirls);
	}

	override public function createPost()
	{
		if (FunkinOptions.get('cutscenes') && isStoryMode && (curSong.formatToPath() == 'senpai' || curSong.formatToPath() == 'roses'))
		{
			startCallback = () ->
			{
				var doof:DialogueBox = new DialogueBox(false, game.dialogue);
				doof.scrollFactor.set();
				doof.finishThing = startCountdown;
				doof.cameras = [camDIALOGUE];

				if (curSong.formatToPath() == 'senpai' || curSong.formatToPath() == 'roses')
				{
					schoolIntro(doof);
				}
			};
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;

		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.antialiasing = false;
		black.scrollFactor.set();
		add(black);

		if (curSong.formatToPath() == 'roses')
		{
			remove(black);
			FlxG.sound.play(Paths.content.sound('ANGRY'));
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
				tmr.reset(0.3);
			else
			{
				if (dialogueBox != null)
					add(dialogueBox);
				else
					startCountdown();

				remove(black);
			}
		});
	}

	override public function cameraMovement(char:Character)
	{
		if (char == player)
		{
			camFollow.x = player.getMidpoint().x - 200;
			camFollow.y = player.getMidpoint().y - 200;
		}
	}

	override public function beatHit()
	{
		bgGirls.dance();
	}
}

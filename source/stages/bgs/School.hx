package stages.bgs;

import objects.DialogueBox;
import stages.objects.BackgroundGirls;

class School extends StageBackend
{
    var bgGirls:BackgroundGirls;

    override function create()
    {
        if (PlayState.SONG.song.formatToPath() == 'senpai' || PlayState.SONG.song.formatToPath() == 'roses')
            hasCutscene = true;

        pixel = true;

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

        if (PlayState.SONG.song.formatToPath() == 'roses')
        {
            bgGirls.getScared();
        }

        bgGirls.setGraphicSize(Std.int(bgGirls.width * PlayState.daPixelZoom));
        bgGirls.updateHitbox();
        add(bgGirls);
    }

    override function createPost()
    {
        PlayState.game.boyfriend.x += 200;
		PlayState.game.boyfriend.y += 220;
		PlayState.game.gf.x += 180;
		PlayState.game.gf.y += 300;

        var doof:DialogueBox = new DialogueBox(false, PlayState.game.dialogue);
        doof.scrollFactor.set();
        doof.finishThing = PlayState.game.startCountdown;
        doof.cameras = [PlayState.game.camDIALOGUE];

        if (PlayState.isStoryMode && !PlayState.seenCutscene)
            if (PlayState.SONG.song.formatToPath() == 'senpai' || PlayState.SONG.song.formatToPath() == 'roses')
                schoolIntro(doof);
    }

    function schoolIntro(?dialogueBox:DialogueBox):Void
	{
        PlayState.game.inCutscene = true;

		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		PlayState.game.camFollow.setPosition(PlayState.game.camPos.x, PlayState.game.camPos.y);

		if (PlayState.SONG.song.formatToPath() == 'roses' )
		{
			remove(black);
			FlxG.sound.play(Paths.sound('ANGRY'));
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
				tmr.reset(0.3);
			else
			{
				if (dialogueBox != null)
				{
                    add(dialogueBox);
				}
				else
					PlayState.game.startCountdown();

				remove(black);
			}
		});
	}

    override function cameraMovement(char:objects.Character)
    {
        if (char == PlayState.game.boyfriend) {
			PlayState.game.camFollow.x = PlayState.game.boyfriend.getMidpoint().x - 200;
            PlayState.game.camFollow.y = PlayState.game.boyfriend.getMidpoint().y - 200;
        }
    }

    override function beatHit()
    {
        bgGirls.dance();
    }
}
package stages.bgs;

import flixel.addons.effects.FlxTrail;

import objects.game.BGSprite;
import objects.game.Character;
import objects.game.DialogueBox;

class SchoolEvil extends StageBackend
{
    override public function create()
    {
        pixel = true;

        if (curSong.formatToPath() == 'thorns' && isStoryMode)
            hasCutscene = true;

        var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool', 400, 200, 0.8, 0.9, ['background 2 instance 1'], true);
        bg.antialiasing = false;
        bg.scale.set(6, 6);
        add(bg);
    }

    override public function createPost()
    {
        var evilTrail = new FlxTrail(opponent, null, 4, 4, 0.3, 0.069);
		addBehindOpponent(evilTrail);

        player.x += 200;
		player.y += 220;
		gf.x += 180;
		gf.y += 300;

        var doof:DialogueBox = new DialogueBox(false, game.dialogue);
        doof.scrollFactor.set();
        doof.finishThing = startCountdown;
        doof.cameras = [camDIALOGUE];

        if (isStoryMode && !PlayState.seenCutscene)
            if (curSong.formatToPath() == 'thorns')
                schoolIntro(doof);
    }

    private function schoolIntro(?dialogueBox:DialogueBox):Void
	{
        inCutscene = true;

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
        red.antialiasing = false;
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion instance 1', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * PlayState.daPixelZoom));
        senpaiEvil.antialiasing = false;
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += senpaiEvil.width / 5;

		camFollow.setPosition(camPos.x, camPos.y);

		add(red);

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			if (dialogueBox != null)
			{
                add(senpaiEvil);
                senpaiEvil.alpha = 0;
                new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
                {
                    senpaiEvil.alpha += 0.15;
                    if (senpaiEvil.alpha < 1)
                        swagTimer.reset();
                    else
                    {
                        senpaiEvil.animation.play('idle');
                        FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
                        {
                            remove(senpaiEvil);
                            remove(red);
                            camGAME.fade(FlxColor.WHITE, 0.01, true, function()
                            {
                                add(dialogueBox);
                            }, true);
                        });
                        new FlxTimer().start(3.2, function(deadTime:FlxTimer)
                        {
                            camGAME.fade(FlxColor.WHITE, 1.6, false);
                        });
                    }
                });
			}
			else
				startCountdown();
		});
	}

    override public function cameraMovement(char:Character)
    {
        if (char == player) {
			camFollow.x = player.getMidpoint().x - 200;
            camFollow.y = player.getMidpoint().y - 200;
        }
    }
}
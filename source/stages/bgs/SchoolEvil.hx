package stages.bgs;

import objects.DialogueBox;

import flixel.addons.effects.FlxTrail;

class SchoolEvil extends StageBackend
{
    override function create()
    {
        if (PlayState.SONG.song.formatToPath() == 'thorns')
            hasCutscene = true;

        pixel = true;

        var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool', 400, 200, 0.8, 0.9, ['background 2 instance 1'], true);
        bg.antialiasing = false;
        bg.scale.set(6, 6);
        add(bg);
    }

    override function createPost()
    {
        var evilTrail = new FlxTrail(PlayState.game.dad, null, 4, 4, 0.3, 0.069);
		addBehindDad(evilTrail);

        PlayState.game.boyfriend.x += 200;
		PlayState.game.boyfriend.y += 220;
		PlayState.game.gf.x += 180;
		PlayState.game.gf.y += 300;

        var doof:DialogueBox = new DialogueBox(false, PlayState.game.dialogue);
        doof.scrollFactor.set();
        doof.finishThing = PlayState.game.startCountdown;
        doof.cameras = [PlayState.game.camDIALOGUE];

        if (PlayState.isStoryMode && !PlayState.seenCutscene)
        {
            switch (PlayState.SONG.song.formatToPath())
            {
                case 'thorns':
                    schoolIntro(doof);
                default:
                    PlayState.game.startCountdown();
            }
        }
    }

    function schoolIntro(?dialogueBox:DialogueBox):Void
	{
        PlayState.game.inCutscene = true;

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion instance 1', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * PlayState.daPixelZoom));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += senpaiEvil.width / 5;

		PlayState.game.camFollow.setPosition(PlayState.game.camPos.x, PlayState.game.camPos.y);

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
                            PlayState.game.camGAME.fade(FlxColor.WHITE, 0.01, true, function()
                            {
                                add(dialogueBox);
                            }, true);
                        });
                        new FlxTimer().start(3.2, function(deadTime:FlxTimer)
                        {
                            PlayState.game.camGAME.fade(FlxColor.WHITE, 1.6, false);
                        });
                    }
                });
			}
			else
				PlayState.game.startCountdown();
		});
	}

    override function cameraMovement(char:objects.Character)
    {
        if (char == PlayState.game.boyfriend) {
			PlayState.game.camFollow.x = PlayState.game.boyfriend.getMidpoint().x - 200;
            PlayState.game.camFollow.y = PlayState.game.boyfriend.getMidpoint().y - 200;
        }
    }
}
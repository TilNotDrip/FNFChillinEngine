package stages.bgs;

import objects.game.BGSprite;
import objects.game.Character;

class MallEvil extends StageBackend
{
    override function create()
    {
        if (curSong.formatToPath() == 'winter-horrorland' && isStoryMode)
            hasCutscene = true;

        var bg:BGSprite = new BGSprite('christmas/evilBG', -400, -500, 0.2, 0.2);
        bg.setGraphicSize(Std.int(bg.width * 0.8));
        bg.updateHitbox();
        add(bg);

        var evilTree:BGSprite = new BGSprite('christmas/evilTree', 300, -300, 0.2, 0.2);
        add(evilTree);

        var evilSnow:BGSprite = new BGSprite('christmas/evilSnow', -200, 700);
        add(evilSnow);
    }

    override function createPost()
    {
        player.x += 320;
		opponent.y -= 80;

        if (isStoryMode && !PlayState.seenCutscene)
        {
            switch (curSong.formatToPath())
            {
                case 'winter-horrorland':
                    inCutscene = true;

                    var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
                    add(blackScreen);
                    blackScreen.scrollFactor.set();

                    new FlxTimer().start(0.1, function(tmr:FlxTimer)
                    {
                        remove(blackScreen);
                        FlxG.sound.play(Paths.sound('Lights_Turn_On'));
                        camFollow.y = -2050;
                        camFollow.x += 200;
                        camGAME.focusOn(camFollow.getPosition());
                        camGAME.zoom = 1.5;

                        new FlxTimer().start(0.8, function(tmr:FlxTimer)
                        {
                            remove(blackScreen);
                            FlxTween.tween(camGAME, {zoom: zoom}, 2.5, {
                                ease: FlxEase.quadInOut,
                                onComplete: function(twn:FlxTween)
                                {
                                    startCountdown();
                                }
                            });
                        });
                    });

                default:
                    startCountdown();
            }
        }
    }

    override function cameraMovement(char:Character)
    {
        if (char == player)
            camFollow.y =  player.getMidpoint().y - 200;
    }
}
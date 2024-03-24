package stages.bgs;

import objects.Character;

class MallEvil extends StageBackend
{
    override function create()
    {
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
        PlayState.game.boyfriend.x += 320;
		PlayState.game.dad.y -= 80;

        if (PlayState.isStoryMode && !PlayState.seenCutscene)
        {
            PlayState.seenCutscene = true;

            switch (PlayState.SONG.song.formatToPath())
            {
                case 'winter-horrorland':
                    PlayState.game.inCutscene = true;

                    var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
                    add(blackScreen);
                    blackScreen.scrollFactor.set();
                    PlayState.game.camHUD.visible = false;

                    new FlxTimer().start(0.1, function(tmr:FlxTimer)
                    {
                        remove(blackScreen);
                        FlxG.sound.play(Paths.sound('Lights_Turn_On'));
                        PlayState.game.camFollow.y = -2050;
                        PlayState.game.camFollow.x += 200;
                        FlxG.camera.focusOn(PlayState.game.camFollow.getPosition());
                        FlxG.camera.zoom = 1.5;

                        new FlxTimer().start(0.8, function(tmr:FlxTimer)
                        {
                            PlayState.game.camHUD.visible = true;
                            remove(blackScreen);
                            FlxTween.tween(FlxG.camera, {zoom: zoom}, 2.5, {
                                ease: FlxEase.quadInOut,
                                onComplete: function(twn:FlxTween)
                                {
                                    PlayState.game.startCountdown();
                                }
                            });
                        });
                    });

                default:
                    PlayState.game.startCountdown();
            }
        }
    }

    override function cameraMovement(char:objects.Character)
    {
        if (char == PlayState.game.boyfriend)
            PlayState.game.camFollow.y =  PlayState.game.boyfriend.getMidpoint().y - 200;
    }
}
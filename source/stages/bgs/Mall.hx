package stages.bgs;

class Mall extends StageBackend
{
    var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;

    override function create()
    {
        if (PlayState.SONG.song.formatToPath() == 'eggnog')
            hasEndCutscene = true;

        zoom = 0.80;

        var bg:BGSprite = new BGSprite('christmas/bgWalls', -1000, -500, 0.2, 0.2);
        bg.setGraphicSize(Std.int(bg.width * 0.8));
        bg.updateHitbox();
        add(bg);

        upperBoppers = new BGSprite('christmas/upperBop', -240, -90, 0.33, 0.33, ['Upper Crowd Bob']);
        upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
        upperBoppers.updateHitbox();
        add(upperBoppers);

        var bgEscalator:BGSprite = new BGSprite('christmas/bgEscalator', -1100, -600, 0.3, 0.3);
        bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
        bgEscalator.updateHitbox();
        add(bgEscalator);

        var tree:BGSprite = new BGSprite('christmas/christmasTree', 370, -250, 0.40, 0.40);
        add(tree);

        bottomBoppers = new BGSprite('christmas/bottomBop', -300, 140, 0.9, 0.9, ['Bottom Level Boppers']);
        bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
        bottomBoppers.updateHitbox();
        add(bottomBoppers);

        var fgSnow:BGSprite = new BGSprite('christmas/fgSnow', -600, 700);
        add(fgSnow);

        santa = new BGSprite('christmas/santa', -840, 150, 1, 1, ['santa idle in fear']);
        add(santa);
    }

    override function createPost()
    {
        PlayState.game.boyfriend.x += 200;
    }

    override function cameraMovement(char:objects.Character)
    {
        if (char == PlayState.game.boyfriend)
            PlayState.game.camFollow.y =  PlayState.game.boyfriend.getMidpoint().y - 200;
    }

    override function beatHit()
    {
        upperBoppers.animation.play('Upper Crowd Bob', true);
		bottomBoppers.animation.play('Bottom Level Boppers', true);
		santa.animation.play('santa idle in fear', true);
    }

    override function endSong()
    {
        if (PlayState.SONG.song.formatToPath() == 'eggnog' && PlayState.isStoryMode)
        {
            PlayState.game.inCutscene = true;

            var blackShit:FlxSprite = new FlxSprite(-FlxG.width * PlayState.game.camGAME.zoom, - FlxG.height * PlayState.game.camGAME.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
            blackShit.scrollFactor.set();
            add(blackShit);

            FlxG.sound.play(Paths.sound('Lights_Shut_off'), function()
            {
                endingStuff();
            });
        }
    }
}
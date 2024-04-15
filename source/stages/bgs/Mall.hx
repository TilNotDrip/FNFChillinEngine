package stages.bgs;

import objects.game.BGSprite;
import objects.game.Character;

class Mall extends StageBackend
{
    private var upperBoppers:BGSprite;
	private var bottomBoppers:BGSprite;
	private var santa:BGSprite;

    override public function create()
    {
        zoom = 0.80;

        if (curSong.formatToPath() == 'eggnog' && isStoryMode)
            hasEndCutscene = true;

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

    override public function createPost()
    {
        player.x += 200;
    }

    override public function cameraMovement(char:Character)
    {
        if (char == player)
            camFollow.y =  player.getMidpoint().y - 200;
    }

    override public function beatHit()
    {
        upperBoppers.animation.play('Upper Crowd Bob', true);
		bottomBoppers.animation.play('Bottom Level Boppers', true);
		santa.animation.play('santa idle in fear', true);
    }

    override public function endSong()
    {
        if (curSong.formatToPath() == 'eggnog' && isStoryMode)
        {
            inCutscene = true;

            var blackShit:FlxSprite = new FlxSprite(-FlxG.width * camGAME.zoom, - FlxG.height * camGAME.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
            blackShit.scrollFactor.set();
            add(blackShit);

            FlxG.sound.play(Paths.sound('Lights_Shut_off'), function()
            {
                endingStuff();
            });
        }
    }
}
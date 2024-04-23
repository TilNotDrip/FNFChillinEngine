var aubrey:FlxSprite = null;
function create()
{
    addLibrary('flixel.tweens.FlxEase');
    addLibrary('flixel.tweens.FlxTween');
    aubrey = new FlxSprite().loadGraphic(Paths.image('normal'));
    aubrey.alpha = 1;
    aubrey.cameras = [camHUD];
    aubrey.screenCenter();
    add(aubrey);
}

function createPost()
{
    game.vocals = new FlxSound();
}

function sectionHit()
{
    aubrey.alpha = 1;
    aubrey.scale.set(FlxG.random.float(0.1, 9), FlxG.random.float(0.1, 9));
    FlxTween.tween(aubrey, {alpha: 0}, (Conductor.crochet * 2) / 1000, {ease: FlxEase.cubeOut});
    trace('r');
}

var bfFire:FlxSound = new FlxSound();
function goodNoteHit(note:objects.Note)
{
    if(note.isSustainNote) return;
    bfFire.stop();
    bfFire.loadEmbedded(Paths.sound('fireInTheHole' + fireHandler(false)));
    bfFire.pitch = FlxG.random.float(0.6, 1.6);
    bfFire.play();
}

var dadFire:FlxSound = new FlxSound();
function opponentNoteHit(note:objects.Note)
{
    if(note.isSustainNote) return;
    dadFire.stop();
    dadFire.loadEmbedded(Paths.sound('fireInTheHole' + fireHandler(true)));
    dadFire.pitch = FlxG.random.float(0.6, 1.6);
    dadFire.play();
}

var dadTimer:Int = 0;
var bfTimer:Int = 0;
function fireHandler(dad:Bool):Int
{
    if(dad)
    {
        dadTimer++;
        
        if(dadTimer == 6)
            dadTimer = 1;
    }
    else
    {
        bfTimer++;
        
        if(bfTimer == 6)
            bfTimer = 1;
    }

    if(dad)
        return dadTimer;
    else
        return bfTimer;
        
}
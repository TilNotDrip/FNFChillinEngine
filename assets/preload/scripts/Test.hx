import objects.game.Note;
import modding.Module;
import flixel.FlxG;
import flixel.FlxSprite;
import addons.Paths;

class Test extends Module
{
    public function new() 
    {
        trace('yippee!');
        super('test');
    }

    override public function create()
    {
        super.create();
        FlxG.state.add(new FlxSprite().loadGraphic(Paths.image('icons/bf', 'preload')));
    }

    override public function goodNoteHit(note:Note)
    {
        super.goodNoteHit(note);

        /*if(FlxG.random.bool(50))
        {
            note.revive();
            note.wasHit = false;
        }*/
    }
}
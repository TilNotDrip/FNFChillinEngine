package options.substates;

import options.states.OptionsState;

class BaseSubState extends MusicBeatSubstate
{
    var parent:OptionsState;

    public function new(parent:OptionsState)
    {
        this.parent = parent;

        super();

        var option:Alphabet = new Alphabet(0, 0, 'i ate ur doorframe', true, false);
        option.screenCenter();
        add(option);
    }

    override function update(elapsed:Float)
    {
        if (controls.BACK)
        {
            parent.closeMenu();
            close();
        }

        super.update(elapsed);
    }
}
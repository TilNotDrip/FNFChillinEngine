package options.substates.options;

import options.states.OptionsState;

class ControlsSubState extends BaseSubState
{
    var parent:OptionsState;

    public function new(parent:OptionsState)
    {
        super();

        var option:Alphabet = new Alphabet(0, 0, 'WIP', true, false);
        option.screenCenter();
        add(option);
    }
}
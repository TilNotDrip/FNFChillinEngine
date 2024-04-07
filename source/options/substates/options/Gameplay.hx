package options.substates.options;

import display.FPS;

import openfl.Lib;

import options.objects.Option;

class Gameplay extends BaseSubState
{
    override function create()
    {
        var camZoom:Option = new Option('Camera Zooming', '', 'camZoom', 'gameplay', CHECKBOX);
        addOption(camZoom);

        var ghostTapping:Option = new Option('Ghost Tapping', '', 'ghostTapping', 'gameplay', CHECKBOX);
        addOption(ghostTapping);

        var downScroll:Option = new Option('Downscroll', '', 'downScroll', 'gameplay', CHECKBOX);
        addOption(downScroll);

        var middleScroll:Option = new Option('Middlescroll', '', 'middleScroll', 'gameplay', CHECKBOX);
        addOption(middleScroll);

        var noteSplashes:Option = new Option('Note Splashes', '', 'noteSplashes', 'gameplay', CHECKBOX);
        addOption(noteSplashes);

        var cutscenes:Option = new Option('Cutscenes', '', 'cutscenes', 'gameplay', CHECKBOX);
        addOption(cutscenes);

        super.create();
    }
}
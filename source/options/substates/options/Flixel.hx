package options.substates.options;

import display.FPS;

import openfl.Lib;

import options.objects.Option;

class Flixel extends BaseSubState
{
    override function create()
    {
        var autoPause:Option = new Option('Auto Pause', 'Whether to freeze the game is unfocused.', 'autoPause', 'flixel', CHECKBOX);
        autoPause.onChange = autopausing;
        addOption(autoPause);

        #if FLX_MOUSE
        var systemCursor:Option = new Option('System Cursor', 'Whether to use your systems default cursor or not.', 'systemCursor', 'flixel', CHECKBOX);
        systemCursor.onChange = changeCursor;
        addOption(systemCursor);
        #end

        super.create();
    }

    function autopausing()
        FlxG.autoPause = ChillSettings.get('autoPause', 'flixel');

    #if FLX_MOUSE
    function changeCursor()
        FlxG.mouse.useSystemCursor = ChillSettings.get('systemCursor', 'flixel');
    #end
}
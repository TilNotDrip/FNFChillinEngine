package options.substates.options;

import options.objects.Option;

class Display extends BaseSubState
{
    override function create()
    {
        var fps:Option = new Option('FPS', 'How much frames the game runs per second.', 'fps', DISPLAY, NUMBER);
        fps.numType = Int;
        fps.minimumValue = 30;
        #if !html5 fps.maximumValue = 360; #else fps.maximumValue = 60; #end
        fps.onChange = changeFPS;
        addOption(fps);

        var fpsCounter:Option = new Option('FPS Counter', 'Shows the FPS Counter in the Top Left Corner.', 'fpsCounter', DISPLAY, CHECKBOX);
        fpsCounter.onChange = displayFPS;
        addOption(fpsCounter);

        var fullscreen:Option = new Option('Fullscreen', 'Puts the game in fullscreen.', 'fullscreen', DISPLAY, CHECKBOX);
        fullscreen.onChange = changeFullscreen;
        addOption(fullscreen);

        var antialiasing:Option = new Option('Antialiasing', 'Whether objects have antialiasing or not.', 'antialiasing', DISPLAY, CHECKBOX);
        antialiasing.onChange = changeAntialiasing;
        addOption(antialiasing);

        var flashingLights:Option = new Option('Flashing Lights', 'Whether flashing lights are shown or not.', 'flashingLights', DISPLAY, CHECKBOX);
        addOption(flashingLights);

        super.create();
    }

    function changeFPS()
    {
		FlxG.updateFramerate = ChillSettings.get('fps', DISPLAY);
        FlxG.drawFramerate = ChillSettings.get('fps', DISPLAY);
    }

    function displayFPS()
    {
        if (Main.fpsCounter != null)
            Main.fpsCounter.visible = ChillSettings.get('fpsCounter', DISPLAY);
    }

    function changeFullscreen()
        FlxG.fullscreen = ChillSettings.get('fullscreen', DISPLAY);

    function changeAntialiasing()
        FlxSprite.defaultAntialiasing = ChillSettings.get('antialiasing', DISPLAY);
}
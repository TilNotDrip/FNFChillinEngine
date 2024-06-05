package modding;

import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import openfl.Assets;

#if sys
import sys.FileSystem;
#end

import hscript.plus.ScriptState;

class HScript
{
    public static var StopFunction:HScriptFunctions = STOP;
    public static var ContinueFunction:HScriptFunctions = CONTINUE;

    private static var importList:Array<Dynamic> = [
        flixel.FlxG,
        flixel.FlxSprite,
        flixel.FlxSubState,

        flixel.graphics.frames.FlxAtlasFrames,

        flixel.group.FlxGroup.FlxTypedGroup,
        flixel.group.FlxGroup,

        flixel.math.FlxMath,

        flixel.sound.FlxSound,

        flixel.text.FlxText,

        flixel.tweens.FlxEase,
        flixel.tweens.FlxTween,

        //flixel.util.FlxColor, // gonna fix this later
        flixel.util.FlxTimer,

        lime.app.Application,

        addons.Controls,
        addons.CoolUtil,

        addons.Paths,

        options.ChillSettings,

        states.game.GameBackend,
        states.game.PlayState,

        states.menus.StoryMenuState,
        states.menus.FreeplayState,
        states.menus.MainMenuState,

        states.LoadingState,
        StringTools,
        addons.CoolTools
    ];

    public var scripts:Array<HScriptState> = [];

    public function new(path:String, specialImports:Map<String, Dynamic>)
    {
        for(scriptPath in ModLoader.modFile(path))
        {
            var scriptsAvailable:Array<String> = FileSystem.readDirectory(scriptPath);

            try {
                for(script in scriptsAvailable)
                {
                    var daScript:HScriptState = new HScriptState();
                    daScript.executeFile(script);
                    scripts.push(daScript);
                }
            } catch(e) {
                trace('overdue charger notices');
            }
        }
    }

    var daFunctionToCall:Dynamic = null;
    public function runFunction(func:String, ?args:Array<Dynamic> = null):Array<Dynamic>
    {
        var returnArray:Array<Dynamic> = [];
        for(script in scripts)
        {
            daFunctionToCall = script.get(func);

            if(Reflect.isFunction(daFunctionToCall))
                returnArray.push(Reflect.callMethod(this, daFunctionToCall, args));
        }

        return returnArray;
    }


    public function destroy() 
    {
        for(script in scripts)
            script.destroy();
    }
}

private class HScriptState extends ScriptState implements IFlxDestroyable
{
    override function error(e:Dynamic) 
    {
        trace('Exception on Script (' + e + ')');
		return;
	}

    public function destroy()
    {
        _parser = null;
        _interp = null;
    }
}

enum abstract HScriptFunctions(String)
{
    var CONTINUE = 'continue';
    var STOP = 'stop';
}
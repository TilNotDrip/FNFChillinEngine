package addons;

import sys.FileSystem;
import openfl.Assets;
import tea.SScript;

class HScript extends SScript
{
    public static var StopFunction:HScriptFunctions = STOP;
    public static var ContinueFunction:HScriptFunctions = CONTINUE;
    
    private static var importList:Array<Dynamic> = [ // copied import just because
        flixel.FlxG,
        flixel.FlxSprite,
        flixel.FlxState,
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

        #if discord_rpc
        addons.discord.LegacyDiscord,
        #end

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

    private var initializeThing:Bool = false;
    private static var initializedScripts:Array<HScript> = [];

    var specialImports:Map<String, Dynamic> = [];

    /**
     * only use this if you want to load one script!
     */
    public function new(scriptPath:String, specialImports:Map<String, Dynamic>)
    {
        this.specialImports = specialImports;

        if (!Assets.exists(scriptPath)) // Dumbass fix for now -Crusher
        {
            FlxG.log.error(scriptPath + ' doesnt exist!');
            return;
        }

        super(scriptPath);

        initializedScripts.push(this);
    }

    override function preset():Void
	{
		super.preset();

		for(classAdd in importList)
        {
            var classAddName:Array<String> = Type.getClassName(classAdd).split('.');
            set(classAddName[classAddName.length-1], classAdd);
        }

        set('addLibrary', addLibrary);
        
        for(daImport in specialImports.keys())
        {
            set(daImport, specialImports.get(daImport));
        }
	}

    public function runLocalFunction(name:String, ?args:Null<Array<Dynamic>> = null):tea.SScript.Tea
	{
        if(!initializeThing) // stupid fix
        {
            initializeThing = true;

            set('add', FlxG.state.add);
            set('insert', FlxG.state.insert);
            set('remove', FlxG.state.remove);
        } 

		return call(name, args);
	}

    public static function runFunction(name:String, ?args:Array<Dynamic> = null):Array<tea.SScript.Tea>
    {
        var returnArray:Array<tea.SScript.Tea> = [];

        for(script in initializedScripts)
        {
            var daCall:tea.SScript.Tea = script.runLocalFunction(name, args);

            if(!daCall.succeeded && !daCall.exceptions.toString().contains('does not exist'))
                trace('Exceptions for $name in ${script.scriptFile}: ' + daCall.exceptions);

            returnArray.push(daCall);
        }

        return returnArray;
    }

	public function addLibrary(library:String)
	{
		var libraryName:Array<String> = library.split('.');
		set(libraryName[libraryName.length-1], Type.resolveClass(library));
	}

    override public function destroy()
    {
        initializedScripts.remove(this);
        super.destroy();
    }

    public static function destroyAllScripts()
    {
        for(script in initializedScripts)
            script.destroy();
    }

    public static function loadAllScriptsAtPath(beforePath:String, specialImports:Map<String, Dynamic>):Array<HScript>
    {
        var daArray:Array<HScript> = [];
        for(path in ModLoader.modFile(beforePath))
        {
            for(daFile in FileSystem.readDirectory(path))
            {
                if(daFile.endsWith('.hx')) daArray.push(new HScript(path + '/' + daFile, specialImports));
            }
        }

        return daArray;
    }
}

enum abstract HScriptFunctions(Int)
{
    var STOP = 0;
    var CONTINUE = 1;
}
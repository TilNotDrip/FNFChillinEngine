package addons;

import openfl.Assets;

class HScript extends tea.SScript
{
    static var importList:Array<Dynamic> = [ // copied import just because
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

    var initializeThing:Bool = false;
    static var initializedScripts:Array<HScript> = [];

    var specialImports:Map<String, Dynamic> = [];

    public function new(scriptPath:String, specialImports:Map<String, Dynamic>)
    {
        this.specialImports = specialImports;
        super(scriptPath + '.hx');

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
            if(daCall.exceptions != [] && !daCall.exceptions.toString().contains('does not exist')) trace('exceptions for $name in ${script.scriptFile}: ' + daCall.exceptions);
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

    public static function loadAllScriptsAtPath(path:String):Array<HScript>
    {
        var daArray:Array<HScript> = [];
        for(daFile in FileSystem.readDirectory(path))
        {
            daArray.push(new HScript('mods/scripts/' + daFile));
        }

        return daArray;
    }
}
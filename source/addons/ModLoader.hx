package addons;

#if MOD_SUPPORT
import flixel.FlxObject;
import flixel.FlxBasic;
import polymod.Polymod;

class ModLoader
{
    public static var mods(default, set):Array<String> = [];
    static var params:PolymodParams;
    public function new()
    {
        var modDir:String = '../../../';

        #if mac modDir += modDir; #end // <APPLICATION>.app/Contents/Resources! 

        modDir += 'mods';

        params = {
            modRoot: modDir,
			errorCallback: onError,
			ignoredFiles: Polymod.getDefaultIgnoreList(),
			framework: Framework.FLIXEL
        };

        mods = []; // run set_mods
    }

    static function set_mods(dirs:Array<String>):Array<String> 
    {
        trace('Loading: ${dirs}');

        params.dirs = dirs;

        if(params == null) return dirs;

		var results = Polymod.init(params);

		// Reload graphics before rendering again.
		var loadedMods = results.map(function(item:ModMetadata)
		{
			return item.id;
		});

		trace('Loaded mods: ${loadedMods}');

        return dirs;
    }


    static function onError(error:PolymodError)
    {
        var message:String = 
        'Whoopsee! You got an error! ('
        + Std.string(error.code).toUpperCase() + ')!'
        + '\n This is what you need to know:' 
        + '\n' + error.message;

        lime.app.Application.current.window.alert(message, 'Error!');
    }
}


#end
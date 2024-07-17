package modding;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

import hscript.AbstractScriptClass;
import hscript.InterpEx;
import hscript.ParserEx;

class HScript
{
	private static var interp:InterpEx = null;

	private static var loadedScripts:Array<AbstractScriptClass> = [];

	public static function init()
	{
		interp = new InterpEx();

		loadScripts();
	}

	private static function loadScripts()
	{
		var scriptsFound:Array<String> = [];

		var currentDirectories:Array<String> = ['assets'];
        while(currentDirectories.length > 0)
        {
			var curDirectory:String = currentDirectories.shift();
            for(path in FileSystem.readDirectory(curDirectory))
            {
				var fullPath:String = curDirectory + '/' + path;
                if(path.endsWith('.hx'))
                    scriptsFound.push(fullPath);
                else if(FileSystem.isDirectory(fullPath))
                    currentDirectories.push(fullPath);
            }
        }

		for(path in scriptsFound)
		{
			var parsedScript:String = File.getContent(path);

			var parser:ParserEx = new ParserEx();
			
        	var module:Array<hscript.Expr.ModuleDecl> = parser.parseModule(parsedScript);
        	interp.registerModule(module);

			var pkg:Array<String> = null;
			var classesToLoad:Array<String> = [];
			
			for(moduleThing in module)
			{
				switch (moduleThing) 
				{
					case DPackage(path):
						pkg = path;
					case DClass(c):
						classesToLoad.push(((pkg != null) ? (pkg.join(".") + ".") : '') + c.name);
					case DImport(oke, ok):
					case DTypedef(ok):
				}
			}

			for(classs in classesToLoad)
				loadedScripts.push(interp.createScriptClassInstance(classs));
		}
	}

	public static function listScriptsClasses(superClass:Dynamic)
	{
		return loadedScripts.filter(function(script:AbstractScriptClass) {
			return Std.isOfType(script.superClass, superClass);
		});
	}
}
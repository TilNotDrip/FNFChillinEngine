package modding;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

import hscript.*;

class HScript
{
	public static var variables(get, null):Map<String, Dynamic>; static function get_variables() return _interp.variables;

	static var _parser:Parser;
	static var _interp:Interp;

	static var scriptsLoaded:Map<String, Dynamic> = new Map();

	public static function init()
	{
		_parser = new Parser();
		_parser.allowTypes = true;
		
		_interp = new Interp();
		//_interp.setResolveImportFunction(resolveImport);

		addGeneralScripts();
	}

	/**
	 * Adds all scripts in scripts to the mod manager.
	 */
	public static function addGeneralScripts()
	{
		for(path in ModLoader.modFile('scripts/'))
		{
			var letsHope:Array<String> = [];

			try letsHope = FileSystem.readDirectory(path);

			if(letsHope == null)
				letsHope = [];

			for(file in letsHope)
			{
				if((path + file).endsWith('.hx'))
					addScript(path + file);
			} 
		}
	}

	/**
	 * Adds a singular script to the manager.
	 * @param path 
	 */
	public static function addScript(path:String)
	{
		var name:String = path.substring(path.lastIndexOf('/')+1, path.lastIndexOf('.hx'));

		var script:String = File.getContent(path);

		_interp.execute(_parser.parseString(script, path));

		var daClass:Dynamic = variables.get(name);

		variables.set('STOP', StopFunction);

		if(daClass.create != null)
			daClass.create();
	}

	static function resolveImport(importyy:String)
	{
		for(script in scriptsLoaded.keys())
		{
			if(script.substring(script.lastIndexOf('.')+1) == importyy)
				return scriptsLoaded.get(script);
		}

		return Type.resolveClass(importyy);
	}

	public static function runForAllScripts(func:(String, Dynamic)->Void)
	{
		for(script in scriptsLoaded.keys())
			func(script, scriptsLoaded.get(script));
	}
}

class StopFunction // gotta do smth so it isnt empty
{
	function doShit()
	{
		return false;
	}
}
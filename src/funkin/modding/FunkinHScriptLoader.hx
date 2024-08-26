package funkin.modding;

import hscript.AbstractScriptClass;
import hscript.InterpEx;
import hscript.ParserEx;

class FunkinHScriptLoader
{
	private static var interp:InterpEx;

	private static var loadedScripts:Map<String, AbstractScriptClass>;

	public static function init():Void
	{
		interp = new InterpEx();
		loadedScripts = new Map<String, AbstractScriptClass>();

		loadScripts();
	}

	static function loadScripts():Void
	{
		for (path in Paths.location.list('scripts'))
		{
			if (path.endsWith('.${Constants.EXT_SCRIPT}'))
			{
				var parser:ParserEx = new ParserEx();

				var module:Array<hscript.Expr.ModuleDecl> = parser.parseModule(Paths.content.getText(path));
				interp.registerModule(module);

				var pkg:Array<String> = null;
				var classesToLoad:Array<String> = [];

				for (moduleScript in module)
				{
					switch (moduleScript)
					{
						case DPackage(path):
							pkg = path;
						case DClass(c):
							classesToLoad.push(((pkg != null) ? (pkg.join(".") + ".") : '') + c.name);
						case DImport(oke, ok):
						case DTypedef(ok):
					}
				}

				for (scriptedClass in classesToLoad)
					loadedScripts.set(scriptedClass, interp.createScriptClassInstance(scriptedClass));
			}
		}
	}
}

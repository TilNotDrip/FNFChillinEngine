package structures;

typedef Mod =
{
	/**
	 * The folder that the mod is located in.
	 */
	var folder:String;

	/**
	 * Whether the mod is enabled or not.
	 */
	var enabled:Bool;

	/**
	 * The mod metadata where some important information is stored.
	 */
	var metadata:ModMetadata;
}

typedef ModMetadata =
{
	/**
	 * The mod id.
	 *
	 * Can be used for dependencies.
	 */
	var id:String;

	/**
	 * The mod display name.
	 */
	var name:String;

	/**
	 * The mod description.
	 */
	@:optional var description:String;

	/**
	 * The mod credits.
	 *
	 * This contains information about people who helped make this mod.
	 */
	@:optional var credits:Array<ModCredits>;

	/**
	 * The mod dependencies.
	 *
	 * This is a list full of mods that this current mod needs.
	 */
	var dependencies:Array<ModDependency>;

	/**
	 * The mod optional dependencies.
	 *
	 * This is a list full of mods that this current mod will work with if installed.
	 */
	@:optional var optional_dependencies:Array<ModDependency>;

	var api_version:String;
	var version:String;
}

typedef ModCredits =
{
	var name:String;
	var description:String;
	@:optional var url:String;
}

typedef ModDependency =
{
	var id:String;
	var version:String;
}

typedef ModOptions =
{
	var name:String;
	var description:String;
	var variable:String;
	var type:String;
	var defaultValue:Dynamic;
}

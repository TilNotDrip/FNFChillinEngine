package funkin.structures;

typedef Mod =
{
	var folder:String;
	var enabled:Bool;
	var metadata:ModMetadata;
}

typedef ModMetadata =
{
	/**
	 * The mod id.
	 *
	 * This is like a codename for the mod you can call from scripts or use as a dependency.
	 */
	@:default('unknown')
	var id:String;

	/**
	 * The mod name.
	 *
	 * This is for display (or used for mod dependencies)
	 */
	@:default('Unknown')
	var name:String;

	/**
	 * The mod description.
	 *
	 * This tells people about the mod.
	 */
	@:default('No description provided.')
	var description:String;

	/**
	 * If this mod is always loaded.
	 */
	var global:Bool;

	/**
	 * The mod credits.
	 *
	 * This contains people that helped with the mod and will be added in the credits menu.
	 */
	@:optional
	var credits:Array<ModCredits>;

	/**
	 * Mods that this mod requires/supports.
	 */
	@:optional
	var dependencies:ModDependencies;

	/**
	 * The version data for the mod.
	 */
	var versions:ModVersions;
}

typedef ModCredits =
{
	var section:String;
	var people:Array<ModCreditPerson>;
}

typedef ModCreditPerson =
{
	var name:String;

	@:optional
	var description:String;

	@:default('unknown')
	@:optional
	var icon:String;

	@:optional
	var url:String;
}

typedef ModDependencies =
{
	/**
	 * Mods that this mod requires to work.
	 *
	 * If all dependencies aren't found after every other mods are loaded then this one doesn't get loaded.
	 */
	var required:Array<ModDependency>;

	/**
	 * Mods that this mod supports.
	 *
	 * If this dependency is found then the mod will probably use it.
	 */
	var optional:Array<ModDependency>;
}

typedef ModDependency =
{
	/**
	 * The dependency id.
	 *
	 * If this isn't specified then the name is required.
	 */
	@:optional
	var id:String;

	/**
	 * The dependency name.
	 *
	 * If this isn't specified then the id is required.
	 */
	@:optional
	var name:String;

	/**
	 * The dependency version/version rule.
	 *
	 * If the dependency version isn't specified then it will just load but things may break.
	 */
	@:optional
	var version:String;
}

typedef ModVersions =
{
	/**
	 * The current version of the mod api being used for this mod.
	 *
	 * This should be the version displayed in Constants.VERSION_MOD.
	 */
	@:default(funkin.util.Constants.VERSION_MOD)
	var api:String;

	/**
	 * The current mod version.
	 */
	@:default('Unknown')
	var mod:String;
}

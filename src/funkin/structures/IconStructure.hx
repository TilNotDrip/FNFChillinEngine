package funkin.structures;

typedef IconStructure =
{
	/**
	 * Used for split animations, basically icons normally.
	 */
	var resolution:Array<Int>;

	/**
	 * Color of the icon.
	 */
	var color:String;

	/**
	 * If the icon should have antialiasing enabled.
	 */
	var antialiasing:Bool;

	/**
	 * If the icon should play a bop on beat.
	 */
	var shouldBop:Bool;

	var animations:Array<AnimationStructure>;
	var healthAnimations:Array<HealthAnimation>;
}

typedef HealthAnimation =
{
	var atHealth:Float;
	var goesUnder:Bool;
	var anim:String;
}

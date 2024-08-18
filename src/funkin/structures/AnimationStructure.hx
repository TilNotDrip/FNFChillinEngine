package funkin.structures;

typedef AnimationStructure =
{
	/**
	 * The animation name.
	 */
	var name:String;

	/**
	 * The animation prefix.
	 */
	var prefix:String;

	/**
	 * The framerate the animation plays at.
	 * @default 24
	 */
	@:default(24)
	@:optional
	var ?framerate:Float;

	/**
	 * The specific frames in the prefix to play.
	 * @default None
	 */
	@:default([])
	// @:alias("frameIndices")
	@:optional
	var ?indices:Array<Int>;

	/**
	 * Whether the animation is looped.
	 * @default false
	 */
	@:default(false)
	@:optional
	var ?looped:Bool;

	/**
	 * Whether the animation is flipped horizontally.
	 * @default false
	 */
	@:default(false)
	@:optional
	var ?flipX:Bool;

	/**
	 * Whether the animation is flipped vertically.
	 * @default false
	 */
	@:default(false)
	@:optional
	var ?flipY:Bool;
}

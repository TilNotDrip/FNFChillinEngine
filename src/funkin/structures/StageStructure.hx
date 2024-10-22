package funkin.structures;

import funkin.structures.AnimationStructure;

typedef StageStructure =
{
	@:default(funkin.util.Constants.VERSION_STAGE)
	var version:String;

	@:default('Unknown')
	@:optional
	var displayName:String;

	@:default(null)
	@:optional
	var directory:String;

	@:default('funkin')
	var ui:String;

	/**
	 * The default camera zoom on the stage.
	 *
	 * @default 1.0
	 */
	@:default(1.0)
	@:optional
	var zoom:Float;

	/**
	 * The props shown in the stage.
	 *
	 * @default Empty Stage.
	 */
	@:default([])
	@:optional
	var props:Array<StageProp>;

	@:default([])
	@:optional
	var characters:Map<String, StageCharacterData>;
}

typedef StageProp =
{
	/**
	 * The name of a prop.
	 *
	 * This is used for getting the prop in scripts.
	 *
	 * (Optional)
	 */
	@:optional
	var name:String;

	/**
	 * The graphic name (or xml if animations are used) that the prop uses.
	 *
	 * (If this starts with a **#** then it will instead make a coloured graphic.)
	 *
	 * @default #000000
	 */
	@:default('#000000')
	var image:String;

	/**
	 * The position of the prop.
	 *
	 * @default [0.0, 0.0]
	 */
	@:default([0.0, 0.0])
	@:optional
	var position:Array<Float>;

	/**
	 * THe animations that this prop has.
	 *
	 * If an animation is named `idle` than that will be played.
	 *
	 * If this is left empty than the prop will just be a static graphic.
	 *
	 * @default []
	 */
	@:default([])
	@:optional
	var animations:Array<AnimationStructure>;

	/**
	 * The factor of how much this prop is controlled by the camera.
	 *
	 * @default [1.0, 1.0]
	 */
	@:default([1.0, 1.0])
	@:optional
	var scrollFactor:Array<Float>;

	/**
	 * How much this prop is scaled.
	 *
	 * Or if its a coloured graphic (via putting a # in the start of image) than this will be how big the coloured graphic is.
	 *
	 * @default [1.0, 1.0]
	 */
	@:default([1.0, 1.0])
	@:optional
	var scale:Array<Float>;

	/**
	 * How visible the prop is.
	 *
	 * @default 1.0
	 */
	@:default(1.0)
	@:optional
	var alpha:Float;

	/**
	 * Whether this prop is antialiased or not.
	 *
	 * If the option `antialiasing` is ticked off than this will have no effect.
	 *
	 * @default true
	 */
	@:default(true)
	@:optional
	var antialiasing:Bool;

	@:default(false)
	@:optional
	var flipX:Bool;

	@:default(false)
	@:optional
	var flipY:Bool;
}

typedef StageCharacterData =
{
	@:default([0.0, 0.0])
	@:optional
	var position:Array<Float>;

	@:default([0.0, 0.0])
	@:optional
	var cameraPosition:Array<Float>;

	@:default(1.0)
	@:optional
	var alpha:Float;

	@:default([1.0, 1.0])
	@:optional
	var scrollFactor:Array<Float>;

	/**
	 * The positioning information for the character.
	 *
	 * @default X: LEFT | Y: TOP
	 */
	@:default({
		x: LEFT,
		y: TOP
	})
	@:optional
	var positioning:StageCharacterPositioningStructure;
}

typedef StageCharacterPositioningStructure =
{
	/**
	 * Where the X is located on the character.
	 * @default LEFT
	 */
	@:default(LEFT)
	@:optional
	var x:StageCharacterPositionX;

	/**
	 * Where the Y is located on the character.
	 * @default TOP
	 */
	@:default(TOP)
	@:optional
	var y:StageCharacterPositionY;
}

enum abstract StageCharacterPositionX(String)
{
	var LEFT = 'left';
	var CENTER = 'center';
	var RIGHT = 'right';
}

enum abstract StageCharacterPositionY(String)
{
	var TOP = 'top';
	var CENTER = 'center';
	var BOTTOM = 'bottom';
}

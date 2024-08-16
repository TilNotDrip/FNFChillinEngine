package funkin.structures;

import thx.semver.Version;

typedef CharacterStructure =
{
	/**
	 * The version that this character format is on.
	 * @default Current Character Version
	 */
	@:default(funkin.util.Constants.VERSION_CHARACTER)
	var version:Version;

	/**
	 * The image (and xml) that gets loaded for the character.
	 */
	var image:String;

	/**
	 * The character animations
	 */
	var animations:Array<CharacterAnimation>;

	/**
	 * Whether the character has antialiasing enabled.
	 * @default true
	 */
	@:default(true)
	@:optional
	var antialiasing:Bool;

	/**
	 * Whether the character is flipped horizontally.
	 * @default false
	 */
	@:default(false)
	@:optional
	var ?flipX:Bool;

	/**
	 * Whether the character is flipped vertically.
	 * @default false
	 */
	@:default(false)
	@:optional
	var ?flipY:Bool;

	/**
	 * The scale of the character.
	 * @default [1, 1]
	 */
	@:default([1, 1])
	@:optional
	var scale:Array<Float>;

	/**
	 * The gameplay information for the character when used in-game.
	 */
	@:optional
	var gameplay:CharacterGameplayStructure;

	/**
	 * The editor information for the character when used in editors.
	 */
	@:optional
	var editor:CharacterEditorStructure;

	/**
	 * The positioning information for the character.
	 */
	@:optional
	var positioning:CharacterPositioningStructure;

	/**
	 * Who / What generated the json file.
	 * @default Unknown
	 */
	@:default('Unknown')
	@:optional
	var ?generatedBy:String;
}

/**
 * The base animation structure but with offsets.
 */
typedef CharacterAnimation =
{
	> AnimationStructure,

	/**
	 * The offsets for this animation only.
	 * @default [0, 0]
	 */
	@:default([0, 0])
	@:optional
	var ?offsets:Array<Float>;
}

typedef CharacterGameplayStructure =
{
	/**
	 * Where the character is positioned inside the game.
	 * @default [0, 0]
	 */
	@:default([0, 0])
	@:optional
	var ?position:Array<Float>;

	/**
	 * Where the character camera is positioned inside the game.
	 * @default [0, 0]
	 */
	@:default([0, 0])
	@:optional
	var ?camera_position:Array<Float>;

	/**
	 * How much beats until the character plays their dancing animation.
	 * @default 2
	 */
	@:default(2)
	@:optional
	var ?danceEvery:Int;

	/**
	 * How long the character sings for inbetween steps.
	 * @default 8.0
	 */
	@:default(8.0)
	@:optional
	var ?singTime:Float;

	/**
	 * The character to switch to upon death.
	 * @default bf-dead
	 */
	@:default('bf-dead')
	@:optional
	var ?deathChar:String;

	/**
	 * The health icon that the character uses.
	 * @default face
	 */
	@:default('face')
	@:optional
	var ?healthIcon:String;

	/**
	 * The UI Suffix used when using this character. (on their side only)
	 * @default funkin
	 */
	@:default('funkin')
	@:optional
	var ?ui:String;
}

typedef CharacterEditorStructure =
{
	/**
	 * The name that shows up in editors.
	 * @default Character ID
	 */
	@:optional
	var ?displayName:String;

	/**
	 * Whether the character is showed as an player.
	 * @default false
	 */
	@:default(false)
	@:optional
	var ?isPlayer:Bool;
}

typedef CharacterPositioningStructure =
{
	/**
	 * Where the X is located on the character.
	 * @default LEFT
	 */
	@:default(LEFT)
	@:optional
	var x:CharacterPositionX;

	/**
	 * Where the Y is located on the character.
	 * @default TOP
	 */
	@:default(TOP)
	@:optional
	var y:CharacterPositionY;
}

enum abstract CharacterPositionX(String)
{
	var LEFT = 'left';
	var CENTER = 'center';
	var RIGHT = 'right';
}

enum abstract CharacterPositionY(String)
{
	var TOP = 'top';
	var CENTER = 'center';
	var BOTTOM = 'bottom';
}

package objects.game;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.graphics.frames.FlxFramesCollection;
import shaders.RGBShader;

class NoteHoldCover extends FlxTypedSpriteGroup<FlxSprite>
{
	static final FRAMERATE_DEFAULT:Int = 24;

	static var glowFrames:FlxFramesCollection;

	var glow:FlxSprite;
	var sparks:FlxSprite;

	public var state:NoteHoldCoverState = START;
	public var direction:Null<Int> = null;

	public var rgbShader:RGBShader = new RGBShader();

	public function new()
	{
		super(0, 0);

		setup();
	}

	public static function preloadFrames():Void
	{
		glowFrames = null;

		var atlas:FlxFramesCollection = Paths.getSparrowAtlas('ui/sustainCovers');
		atlas.parent.persist = true;

		glowFrames = atlas;
	}

	/**
	 * Add ALL the animations to this sprite. We will recycle and reuse the FlxSprite multiple times.
	 */
	function setup():Void
	{
		glow = new FlxSprite();
		add(glow);

		if (glowFrames == null)
			preloadFrames();

		glow.frames = glowFrames;

		glow.animation.addByPrefix('holdCoverStart', 'sustain cover start', FRAMERATE_DEFAULT, false);
		glow.animation.addByPrefix('holdCover', 'sustain cover loop', FRAMERATE_DEFAULT, true,);
		glow.animation.addByPrefix('holdCoverEnd', 'sustain cover end', FRAMERATE_DEFAULT, false,);

		glow.animation.finishCallback = onAnimationFinished;

		shader = rgbShader.shader;

		glow.shader = shader;

		if (sparks != null)
			sparks.shader = shader;
	}

	public function playStart():Void
	{
		state = START;
		glow.animation.play('holdCoverStart');
	}

	public function playContinue():Void
	{
		state = START;
		glow.animation.play('holdCover');
	}

	public function playEnd():Void
	{
		state = END;
		glow.animation.play('holdCoverEnd');
	}

	public override function kill():Void
	{
		super.kill();

		visible = false;
		direction = null;

		if (glow != null)
			glow.visible = false;

		if (sparks != null)
			sparks.visible = false;

		state = NONE;
	}

	public override function revive():Void
	{
		super.revive();

		visible = true;
		alpha = 1.0;
		direction = null;

		if (glow != null)
			glow.visible = true;
		if (sparks != null)
			sparks.visible = true;

		state = NONE;
	}

	public function onAnimationFinished(animationName:String):Void
	{
		if (animationName.startsWith('holdCoverStart'))
		{
			playContinue();
		}

		if (animationName.startsWith('holdCoverEnd'))
		{
			this.visible = false;
			this.kill();
		}
	}

	public function setColors(colors:Array<FlxColor>):Void
	{
		rgbShader.rgb = colors;
		shader = rgbShader.shader;
	}
}

enum abstract NoteHoldCoverState(Int)
{
	var START = 1;
	var END = 0;

	var NONE = 2;
}

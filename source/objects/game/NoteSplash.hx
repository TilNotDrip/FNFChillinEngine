package objects.game;

import shaders.RGBShader;

class NoteSplash extends FlxSprite
{
	public var rgbShader:RGBShader = new RGBShader();

	public function new(x:Float, y:Float, noteData:Int = 0):Void
	{
		super(x, y);

		setupNoteSplash(x, y, noteData);
	}

	public function setupNoteSplash(x:Float, y:Float, noteData:Int = 0, isPixel:Bool = false)
	{
		if (isPixel)
			setPosition(x + 142, y + 143);
		else
			setPosition(x, y);

		loadSplash(isPixel);

		alpha = 0.6;

		animation.play('splash-' + FlxG.random.int(0, 1), true);
		updateHitbox();

		offset.set(width * 0.3, height * 0.3);
	}

	override public function update(elapsed:Float)
	{
		if (animation.curAnim != null && animation.curAnim.finished)
			kill();

		super.update(elapsed);
	}

	private function loadSplash(pixel:Bool = false)
	{
		if (pixel)
		{
			loadGraphic(Paths.image('pixelui/Splashes'), true, 48, 48);

			animation.add('splash-0', [0, 1, 2, 3], 24, false);
			animation.add('splash-1', [4, 5, 6, 7], 24, false);

			setGraphicSize(Std.int(width * 8));
			updateHitbox();

			antialiasing = false;
		}
		else
		{
			frames = Paths.getSparrowAtlas('ui/Splashes');

			animation.addByPrefix('splash-0', 'note impact 1', 24, false);
			animation.addByPrefix('splash-1', 'note impact 2', 24, false);
		}
	}

	public function setColors(colors:Array<FlxColor>)
	{
		rgbShader.rgb = colors;
		shader = rgbShader.shader;
	}
}
package objects;

class NoteSplash extends FlxSprite
{
	public function new(x:Float, y:Float, noteData:Int = 0):Void
	{
		super(x, y);

		if (PlayState.isPixel)
		{
			loadGraphic(Paths.image('pixelui/noteSplashes'), true, 48, 48);

			animation.add('note0-0', [0, 1, 2, 3], 24, false);
			animation.add('note1-0', [4, 5, 6, 7], 24, false);
			animation.add('note2-0', [8, 9, 10, 11], 24, false);
			animation.add('note3-0', [12, 13, 14, 15], 24, false);
			animation.add('note0-1', [0, 1, 2, 3], 24, false);
			animation.add('note1-1', [4, 5, 6, 7], 24, false);
			animation.add('note2-1', [8, 9, 10, 11], 24, false);
			animation.add('note3-1', [12, 13, 14, 15], 24, false);

			setGraphicSize(Std.int(width * 8));
			updateHitbox();

			antialiasing = false;
		}
		else
		{
			frames = Paths.getSparrowAtlas('ui/noteSplashes');

			animation.addByPrefix('note1-0', 'note impact 1  blue', 24, false);
			animation.addByPrefix('note2-0', 'note impact 1 green', 24, false);
			animation.addByPrefix('note0-0', 'note impact 1 purple', 24, false);
			animation.addByPrefix('note3-0', 'note impact 1 red', 24, false);
			animation.addByPrefix('note1-1', 'note impact 2 blue', 24, false);
			animation.addByPrefix('note2-1', 'note impact 2 green', 24, false);
			animation.addByPrefix('note0-1', 'note impact 2 purple', 24, false);
			animation.addByPrefix('note3-1', 'note impact 2 red', 24, false);

			antialiasing = true;
		}

		setupNoteSplash(x, y, noteData);
	}

	public function setupNoteSplash(x:Float, y:Float, noteData:Int = 0)
	{
		setPosition(x, y);

		alpha = 0.6;

		animation.play('note' + noteData + '-' + FlxG.random.int(0, 1), true);
		updateHitbox();

		offset.set(width * 0.3, height * 0.3);
	}

	override function update(elapsed:Float)
	{
		if (animation.curAnim.finished)
			kill();

		super.update(elapsed);
	}
}

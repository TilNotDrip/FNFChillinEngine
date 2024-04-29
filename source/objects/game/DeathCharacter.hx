package objects.game;

class DeathCharacter extends FlxSprite
{
    public var curCharacter:String = 'bf-dead';

    public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

    public var startedDeath:Bool = false;

    public var isPixel(default, set):Bool = false;

    public function new(x:Float, y:Float, ?character:String = 'bf-dead')
    {
        super(x, y);

        animOffsets = new Map<String, Array<Dynamic>>();
        curCharacter = character;

        switch (curCharacter)
        {
            case 'bf-dead':
				frames = Paths.getSparrowAtlas('characters/BF_Dead');

                quickAnimDeathAdd(['BF dies', 'BF Dead Loop', 'BF Dead confirm']);

            case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');

                quickAnimDeathAdd(['BF Dies pixel', 'Retry Loop', 'RETRY CONFIRM']);

				isPixel = true;

            case 'bf-holding-gf-dead':
				frames = Paths.getSparrowAtlas('characters/bfHoldingGF-DEAD');

                quickAnimDeathAdd(['BF Dies with GF', 'BF Dead with GF Loop', 'RETRY confirm holding gf']);
        }

        playAnim('firstDeath');

        loadOffsetFile(curCharacter);

        if (!curCharacter.startsWith('bf'))
		{
			var oldRight = animation.getByName('singRIGHT').frames;
			animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
			animation.getByName('singLEFT').frames = oldRight;

			if (animation.getByName('singRIGHTmiss') != null)
			{
				var oldMiss = animation.getByName('singRIGHTmiss').frames;
				animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
				animation.getByName('singLEFTmiss').frames = oldMiss;
			}
		}
    }

    override public function update(elapsed:Float)
    {
        if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished && startedDeath)
            playAnim('deathLoop');

        super.update(elapsed);
    }

    private function quickAnimAdd(name:String, prefix:String)
	{
		animation.addByPrefix(name, prefix, 24, false);
	}

    private function quickAnimDeathAdd(prefixes:Array<String>)
	{
		animation.addByPrefix('firstDeath', prefixes[0], 24, false);
        animation.addByPrefix('deathLoop', prefixes[1], 24, true);
        animation.addByPrefix('deathConfirm', prefixes[2], 24, false);
	}

	private function loadOffsetFile(offsetCharacter:String)
	{
		var daFile:Array<String> = CoolUtil.coolTextFile(Paths.file("images/characters/" + offsetCharacter + "Offsets.txt", TEXT));

		for (i in daFile)
		{
			var splitWords:Array<String> = i.split(" ");
			addOffset(splitWords[0], Std.parseInt(splitWords[1]), Std.parseInt(splitWords[2]));
		}
	}

    public function addOffset(name:String, x:Float = 0, y:Float = 0)
		animOffsets[name] = [x, y];

    public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
			offset.set(daOffset[0], daOffset[1]);
		else
			offset.set(0, 0);
	}

    private function set_isPixel(value:Bool):Bool
	{
		if (value)
		{
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			updateHitbox();

			antialiasing = false;
		}

		isPixel = value;
		return isPixel;
	}
}
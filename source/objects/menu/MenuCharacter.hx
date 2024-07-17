package objects.menu;

class MenuCharacter extends FlxSprite
{
	public var character:String;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		charChange(character);
	}

	public function charChange(char:String)
	{
		if (char == null)
			char = '';
		if (char == this.character)
			return;

		this.character = char;

		var prefixes:Array<String> = [];

		setGraphicSize(width * 1);
		offset.set(100, 100);
		updateHitbox();

		visible = true;
		antialiasing = true;
		flipX = false;
		flipY = false;

		if (char == '')
			visible = false;
		else
		{
			switch (char)
			{
				case 'bf':
					prefixes = ['BF idle dance white', 'BF HEY!!'];
				case 'gf':
					prefixes = ['GF Dancing Beat WHITE'];
				case 'dad':
					prefixes = ['Dad idle dance BLACK LINE'];
				case 'spooky':
					prefixes = ['spooky dance idle BLACK LINES'];
				case 'pico':
					prefixes = ['Pico Idle Dance'];
				case 'mom':
					prefixes = ['Mom Idle BLACK LINES'];
				case 'parents-christmas':
					prefixes = ['Parent Christmas Idle Black Lines'];
				case 'senpai':
					prefixes = ['SENPAI idle Black Lines'];
				case 'tankman':
					prefixes = ['Tankman Menu BLACK'];
			}

			frames = Paths.content.sparrowAtlas('storyMenu/characters/' + char);

			animation.addByPrefix('idle', prefixes[0], 24, false);

			if (prefixes[1] != null)
				animation.addByPrefix('confirm', prefixes[1], 24, false);

			animation.play('idle');
		}
	}
}

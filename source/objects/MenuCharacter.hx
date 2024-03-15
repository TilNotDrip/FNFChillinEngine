package objects;

class MenuCharacter extends FlxSprite
{
	public var character(default, set):String;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		this.character = character;
	}

	function set_character(value:String)
	{
		frames = Paths.getSparrowAtlas('storyMenu/characters/' + value);

		switch (value)
		{
			case 'bf': quickAnimAdd('bf', 'BF idle dance white', 'BF HEY!!');
			case 'gf': quickAnimAdd('gf', 'GF Dancing Beat WHITE');
			case 'dad': quickAnimAdd('dad', 'Dad idle dance BLACK LINE');
			case 'spooky': quickAnimAdd('spooky', 'spooky dance idle BLACK LINES');
			case 'pico': quickAnimAdd('pico', 'Pico Idle Dance');
			case 'mom': quickAnimAdd('mom', 'Mom Idle BLACK LINES');
			case 'parents-christmas': quickAnimAdd('parents-christmas', 'Parent Christmas Idle Black Lines');
			case 'senpai': quickAnimAdd('senpai', 'SENPAI idle Black Lines');
			case 'tankman': quickAnimAdd('tankman', 'Tankman Menu BLACK');
		}

		updateHitbox();

		return this.character = value;
	}

	function quickAnimAdd(name:String, prefix:String = '', ?confirmPrefix:String = '')
	{
		animation.addByPrefix(name, prefix, 24, false);

		if (confirmPrefix != null)
			animation.addByPrefix(name + 'Confirm', confirmPrefix, 24, false);
	}
}

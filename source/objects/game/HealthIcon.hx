package objects.game;

class HealthIcon extends TrackedSprite
{
	public static var healthBarColors:Map<String, FlxColor> = [
		'bf' => 0xFF31B0D1,
		'bf-old' => 0xFFE9FF48,
		'bf-pixel' => 0xFF7BD6F6,
		'bf-old-pixel' => 0xFFFFF97A,
		'dad' => 0xFFAF66CE,
		'face' => 0xFFA1A1A1,
		'gf' => 0xFFA5004D,
		'mom' => 0xFFD8558E,
		'monster' => 0xFFF3FF6E,
		'parents' => 0xFFAF66CE,
		'pico' => 0xFFB7D855,
		'senpai' => 0xFFFFAA6F,
		'spirit' => 0xFFFF3C6E,
		'spooky' => 0xFFB4B4B4,
		'tankman' => 0xFFE1E1E1
	];

	public var curHealthBarColor:FlxColor;

	public var char:String = '';
	public var isPlayer:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		this.isPlayer = isPlayer;

		sprOffsetX = 10;
		sprOffsetY = -30;

		changeIcon(char);
		scrollFactor.set();
	}

	public var isOldIcon:Bool = false;

	public function swapOldIcon():Void
	{
		if (FlxG.state != PlayState.game) return;

		isOldIcon = !isOldIcon;

		if (isOldIcon)
			(PlayState.game.boyfriend.isPixel ? changeIcon('bf-old-pixel') : changeIcon('bf-old'));
		else
			changeIcon(PlayState.SONG.player1);
	}

	public function changeIcon(newChar:String):Void
	{
		if (newChar != 'bf-pixel' && newChar != 'bf-old' && newChar != 'bf-old-pixel')
			newChar = newChar.split('-')[0].trim();

		curHealthBarColor = healthBarColors.get(newChar);

		if(['bf-pixel', 'bf-old-pixel', 'senpai', 'spirit'].contains(newChar))
			antialiasing = false;

		if (newChar != char)
		{
			if (animation.getByName(newChar) == null)
			{
				loadGraphic(Paths.image('icons/' + newChar), true, 150, 150);
				animation.add(newChar, [0, 1], 0, false, isPlayer);
			}
			animation.play(newChar);
			char = newChar;
		}
	}

	public dynamic function bop()
	{
		FlxTween.tween(scale, {x: 1.3, y: 1.3}, (Conductor.crochet / 1000) * 0.1, {ease: FlxEase.cubeIn});
		FlxTween.tween(scale, {x: 1, y: 1}, (Conductor.crochet / 1000) * 0.9, {ease: FlxEase.cubeOut, startDelay: (Conductor.crochet / 1000) * 0.1});
	}
}

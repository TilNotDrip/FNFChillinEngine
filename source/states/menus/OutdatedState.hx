package states.menus;

class OutdatedState extends MusicBeatState
{
	override public function create()
	{
		changeWindowName('Outdated!');

		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Woah! You are currently running an outdated version of Chillin' Engine
			You are on version " + Application.current.meta.get('version') + " while the current version is vardontexist
			\n
			Press ENTER to update
			Press ESC to exit anyways
			\n
			Thank you for playing/using this engine!",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override public function update(elapsed:Float)
	{
		if (controls.ACCEPT)
			FlxG.openURL("https://ninja-muffin24.itch.io/funkin");

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());

		super.update(elapsed);
	}
}

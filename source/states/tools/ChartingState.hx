package states.tools;

class ChartingState extends MusicBeatState
{
	override function create():Void
	{
		var bg:FlxSprite = new FlxSprite(Paths.content.image('menuUI/menuBG'));
		bg.screenCenter();
		add(bg);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}
}

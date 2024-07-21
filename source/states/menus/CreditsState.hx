package states.menus;

class CreditsState extends MusicBeatState
{
	override function create():Void
	{
		quickMakeBG();

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

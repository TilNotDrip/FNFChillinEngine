package objects;

import flixel.group.FlxSpriteGroup;

class WeekItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var week:FlxSprite;
	public var flashingInt:Int = 0;

	public function new(x:Float, y:Float, weekName:String)
	{
		super(x, y);
		week = new FlxSprite().loadGraphic(Paths.image('storyMenu/weeks/' + weekName));
		add(week);
	}

	private var isFlashing:Bool = false;

	public function startFlashing():Void
	{
		isFlashing = true;
	}

	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		y = CoolUtil.coolLerp(y, (targetY * 120) + 480, 0.17);

		if (isFlashing)
			flashingInt += 1;

		if (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2))
			week.color = 0xFF33ffff;
		else
			week.color = FlxColor.WHITE;
	}
}
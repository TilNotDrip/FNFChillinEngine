package funkin.objects.game;

import flixel.group.FlxSpriteGroup;

class Strumline extends FlxSpriteGroup
{
	// Static Variables
	public static var STATIC_COLORS:Array<FlxColor> = [0xFF87A3AD, 0xFFFFFFFF, 0xFF000000];
	public static var STATIC_COLORS_PIXEL:Array<FlxColor> = [0xFFA2BAC8, 0xFFFFF5FC, 0xFF404047];
	public static var CONFIRM_HOLD_TIME:Float = 0.1;

	public function new(ui:String = 'funkin')
	{
		super();
	}
}

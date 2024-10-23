package funkin.objects.game;

import flixel.ui.FlxBar;
import flixel.group.FlxSpriteGroup;

class HealthBar extends FlxSpriteGroup
{
	public var health:Float = Constants.HEALTH_STARTING;

	public var ui(default, set):String = 'funkin';
	public var iconP1(default, set):String = 'face';
	public var iconP2(default, set):String = 'face';
	public var downScroll(default, set):Bool = false;

	var bg:FlxSprite;
	var bar:FlxBar;

	var iconP1Spr:HealthIcon;
	var iconP2Spr:HealthIcon;

	public function new(?params:HealthBarParams)
	{
		if (params == null)
		{
			params = {
				ui: 'funkin',
				iconP1: 'face',
				iconP2: 'face',
				downScroll: FunkinOptions.get('downScroll')
			};
		}

		iconP1 = params.iconP1;
		iconP2 = params.iconP2;
		ui = params.ui;
		downScroll = params.downScroll;

		super(0, 0, 0);
	}

	override public function create():Void
	{
		bg = new FlxSprite().loadGraphic(Paths.content.imageGraphic('gameplay-ui/$ui/healthBar'));
		add(bg);

		/*bar = new FlxBar();
			add(bar); */

		super.create();
	}

	function set_iconP1(value:String):String
	{
		iconP1 = value;

		if (iconP1Spr != null)
			iconP1Spr.changeIcon(iconP1);

		return iconP1;
	}

	function set_iconP2(value:String):String
	{
		iconP2 = value;

		if (iconP2Spr != null)
			iconP2Spr.changeIcon(iconP2);

		return iconP2;
	}

	function set_ui(value:String):String
	{
		ui = value;
		return ui;
	}

	function set_downScroll(value:Bool):Bool
	{
		downScroll = value;
		y = (downScroll) ? FlxG.height * 0.85 : 20;
		return downScroll;
	}
}

typedef HealthBarParams =
{
	var ?ui:String;
	var ?iconP1:String;
	var ?iconP2:String;
	var ?downScroll:Bool;
}

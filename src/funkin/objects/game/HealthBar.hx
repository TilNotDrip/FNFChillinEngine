package funkin.objects.game;

import flixel.ui.FlxBar;
import flixel.group.FlxSpriteGroup;

class HealthBar extends FlxSpriteGroup
{
	/**
	 * The health to display on the health bar.
	 *
	 * There already is a health variable but that's because of FlxObject.
	 *
	 * Make sure to use this variable not that one.
	 */
	public var _health(default, set):Float;

	public var ui(default, set):String = 'funkin';
	public var iconP1(default, set):String = null;
	public var iconP2(default, set):String = null;
	public var downScroll(default, set):Bool = FunkinOptions.get('downScroll');

	/**
	 * This toggles the easter egg whether the player can hit 9 during a song and iconP1 switches to their old icon.
	 */
	public var easterEgg:Bool = false;

	var bg:FlxSprite;
	var bar:FlxBar;

	var iconP1Spr:HealthIcon;
	var iconP2Spr:HealthIcon;

	var initialized:Bool = false;

	public function new(?params:HealthBarParams)
	{
		if (params == null)
		{
			params = {
				ui: 'funkin',
				downScroll: FunkinOptions.get('downScroll')
			};
		}

		ui = params.ui;
		downScroll = params.downScroll;
		easterEgg = params.easterEgg;

		if (params.iconP1 != null)
			iconP1 = params.iconP1;

		if (params.iconP2 != null)
			iconP2 = params.iconP2;

		super(0, 0, 0);

		bg = new FlxSprite().loadGraphic(Paths.content.imageGraphic('gameplay/play/ui/$ui/healthBar'));
		add(bg);

		bar = new FlxBar(4, 4, RIGHT_TO_LEFT, Std.int(bg.width - 8), Std.int(bg.height - 8), this, "_health", 0, 2, false);
		bar.createFilledBar(0xFFFF0000, 0xFF00FF00);
		add(bar);

		if (iconP1 != null)
			initIcon(iconP1, iconP1Spr, true);

		if (iconP2 != null)
			initIcon(iconP2, iconP2Spr, false);

		_health = Constants.HEALTH_STARTING;

		initialized = true;
	}

	override public function update(elapsed:Float):Void
	{
		if (easterEgg)
		{
			if (iconP1Spr != null && FlxG.keys.justPressed.NINE)
				iconP1Spr.swapOldIcon();
		}

		if (iconP1Spr != null)
			iconP1Spr.x = bar.x + (bar.width * (FlxMath.remapToRange(bar.percent, 0, 2, 100, 0) * 0.01) - 26);

		if (iconP2Spr != null)
			iconP2Spr.x = bar.x + (bar.width * (FlxMath.remapToRange(bar.percent, 0, 2, 100, 0) * 0.01)) - (iconP2Spr.width - 26);

		super.update(elapsed);
	}

	function initIcon(icon:String, spr:HealthIcon, isPlayer:Bool):Void
	{
		spr = new HealthIcon(icon, isPlayer);
		spr.y = bar.y - (spr.height / 2);
		insert((isPlayer) ? 2 : 3, spr);
	}

	function setIcon(icon:String, spr:HealthIcon, isPlayer:Bool):Void
	{
		if (icon == null && spr != null)
			remove(spr);
		else if (icon != null)
		{
			if (spr != null)
				spr.changeIcon(icon);
			else
				initIcon(icon, spr, isPlayer);
		}
	}

	function set__health(value:Float):Float
	{
		_health = value;

		for (spr in [iconP1Spr, iconP2Spr])
		{
			if (spr != null)
				spr.updateIconAnimation(_health);
		}

		return _health;
	}

	function set_iconP1(value:String):String
	{
		iconP1 = value;

		if (initialized)
			setIcon(iconP1, iconP1Spr, true);

		return iconP1;
	}

	function set_iconP2(value:String):String
	{
		iconP2 = value;

		if (initialized)
			setIcon(iconP2, iconP2Spr, false);

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
		y = (downScroll) ? FlxG.height * 0.1 : FlxG.height * 0.9;
		return downScroll;
	}
}

typedef HealthBarParams =
{
	var ui:String;
	var ?iconP1:String;
	var ?iconP2:String;
	var downScroll:Bool;
	var ?easterEgg:Bool;
}

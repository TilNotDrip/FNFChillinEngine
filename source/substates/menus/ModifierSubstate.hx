package substates.menus;

import objects.menu.Checkbox;
import objects.menu.MenuAlphabet;
import utils.Modifiers;

class ModifierSubstate extends MusicBeatSubstate
{
	private var grpMenuShit:FlxTypedGroup<MenuAlphabet>;
	private var grpCheckShit:FlxTypedGroup<Checkbox>;

	var daModifiers:Array<ModifierData>;
	private var curSelected:Int = 0;

	override public function create()
	{
		daModifiers = Modifiers.modifiers;

		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		grpMenuShit = new FlxTypedGroup<MenuAlphabet>();
		add(grpMenuShit);

		grpCheckShit = new FlxTypedGroup<Checkbox>();
		add(grpCheckShit);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

		regenMenu();
	}

	private function regenMenu():Void
	{
		while (grpMenuShit.members.length > 0)
		{
			grpMenuShit.remove(grpMenuShit.members[0], true);
		}

		while (grpCheckShit.members.length > 0)
		{
			grpCheckShit.remove(grpCheckShit.members[0], true);
		}

		for (i in 0...daModifiers.length)
		{
			var songText:MenuAlphabet = new MenuAlphabet(0, (70 * i) + 30, daModifiers[i].name, BOLD);
			songText.targetY = i;
			grpMenuShit.add(songText);

			var checkbox:Checkbox = new Checkbox();
			checkbox.check(Modifiers.hasModifierOn(daModifiers[i].nameID));
			checkbox.sprTracker = songText;
			checkbox.sprOffsetX = 50;
			checkbox.ID = i;
			grpCheckShit.add(checkbox);
		}

		curSelected = 0;
		changeSelection();
		changeCheck(true);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UI_UP_P)
			changeSelection(-1);

		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
			changeCheck();

		if (controls.BACK)
			close();
	}

	override public function close()
	{
		_parentState.persistentUpdate = true;
		super.close();
	}

	private function changeSelection(change:Int = 0):Void
	{
		FlxG.sound.play(Paths.location.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = daModifiers.length - 1;

		if (curSelected >= daModifiers.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}

	private function changeCheck(?dontUpdate:Bool = false)
	{
		for (item in grpCheckShit.members)
		{
			if (item.ID == curSelected)
			{
				if (!dontUpdate)
				{
					if (!Modifiers.hasModifierOn(daModifiers[curSelected].nameID))
						Modifiers.activeModifiers.push(daModifiers[curSelected]);
					else
						Modifiers.activeModifiers.remove(daModifiers[curSelected]);
				}

				item.check(Modifiers.hasModifierOn(daModifiers[curSelected].nameID));

				return;
			}
		}
	}
}

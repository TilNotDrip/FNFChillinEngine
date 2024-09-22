package funkin.states.menus;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.ui.FlxButton;
import funkin.objects.SwagCamera;
import funkin.objects.menu.MenuItem;

class MainMenuState extends MusicBeatState
{
	public static var funkinVer:String = '0.2.8';
	static var curSelected:Int = 0;

	var itemNames:Array<String> = ['storymode', 'freeplay', 'donate', 'options'];
	var menuItems:FlxTypedGroup<MenuItem>;

	var selected:Bool = false;

	var magenta:FlxSprite;

	var camFollow:FlxObject;

	override public function create()
	{
		changeWindowName('Main Menu');

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = 'Main Menu';
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.content.music('freakyMenu'));

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(Paths.content.imageGraphic('mainmenu/menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.17;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		if (FunkinOptions.get('flashingLights'))
		{
			magenta = new FlxSprite(Paths.content.imageGraphic('mainmenu/menuDesat'));
			magenta.x = bg.x;
			magenta.y = bg.y;
			magenta.scrollFactor.x = bg.scrollFactor.x;
			magenta.scrollFactor.y = bg.scrollFactor.y;
			magenta.setGraphicSize(bg.width);
			magenta.updateHitbox();
			magenta.visible = false;
			magenta.color = 0xFFfd719b;
			add(magenta);
		}

		menuItems = new FlxTypedGroup<MenuItem>();
		add(menuItems);

		for (i in 0...itemNames.length)
		{
			var spacing:Float = 160;
			var top:Float = (FlxG.height - (spacing * (itemNames.length - 1))) / 2;
			var menuItem:MenuItem = new MenuItem(top + spacing * i, itemNames[i]);
			menuItem.x = FlxG.width / 2;
			menuItem.scrollFactor.set(0, 0.4);

			switch (menuItem.name)
			{
				case 'storymode':
					menuItem.pressCallback = () ->
					{
						FlxG.switchState(new StoryMenuState());
					}

				case 'freeplay':
					menuItem.pressCallback = () ->
					{
						FlxG.switchState(new FreeplayState());
					}

				case 'credits':
					menuItem.pressCallback = () ->
					{
						FlxG.switchState(new CreditsState());
					}

				/*case 'merch':
					menuItem.pressCallback = () ->
					{
						CoolUtil.openURL(Constants.URL_MERCH);
						resetItems();
				}*/

				case 'options':
					menuItem.pressCallback = () ->
					{
						FlxG.switchState(new OptionsState());
					}
			}

			menuItem.ID = i;
			menuItems.add(menuItem);
		}

		changeItem();
		resetCamStuff();

		var verChillEngine:FlxText = new FlxText(-5, FlxG.height - 18, FlxG.width, "Chillin' Engine v" + Application.current.meta.get('version'), 12);
		verChillEngine.scrollFactor.set();
		verChillEngine.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(verChillEngine);

		var verFunkin:FlxText = new FlxText(5, FlxG.height - 18, 0, "Friday Night Funkin' v" + funkinVer, 12);
		verFunkin.scrollFactor.set();
		verFunkin.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(verFunkin);

		super.create();
	}

	function resetCamStuff():Void
	{
		FlxG.cameras.reset(new SwagCamera());
		FlxG.camera.follow(camFollow, null, 0.06);
		FlxG.camera.snapToTarget();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (controls.UI_UP_P && !selected)
			changeItem(-1);

		if (controls.UI_DOWN_P && !selected)
			changeItem(1);

		if (controls.ACCEPT && !selected)
		{
			selected = true;
			FlxG.sound.play(Paths.content.sound('mainmenu/confirmMenu'));

			menuItems.forEach(function(item:MenuItem)
			{
				if (item.ID == curSelected)
				{
					item.press();
				}
				else
				{
					item.disappear();
				}
			});

			if (FunkinOptions.get('flashingLights'))
			{
				FlxFlicker.flicker(magenta, 1, 0.1, false, false);
			}
		}

		if (controls.BACK && !selected)
		{
			FlxG.sound.play(Paths.content.sound('mainmenu/cancelMenu'));
			FlxG.switchState(new TitleState());
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		if (curSelected >= menuItems.length)
			curSelected = 0;

		menuItems.forEach(function(item:MenuItem)
		{
			if (item.ID == curSelected)
			{
				item.animation.play('selected', true);
				camFollow.setPosition(item.getGraphicMidpoint().x, item.getGraphicMidpoint().y);
			}
			else
				item.animation.play('idle', true);

			item.updateHitbox();
			item.centerOrigin();
			item.offset.copyFrom(item.origin);
		});
	}

	function resetItems():Void
	{
		menuItems.forEach(function(item:MenuItem)
		{
			menuItems.members[curSelected].visible = true;
			menuItems.members[curSelected].alpha = 0;

			FlxTween.tween(item, {alpha: 1}, item.waitTime / 0.5, {
				onComplete: function(twn:FlxTween)
				{
					selected = false;
				}
			});
		});
	}
}

package funkin.substates.game;

import funkin.util.Song;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var pauseOG:Array<String> = [
		'Resume',
		'Restart Song',
		'Change Difficulty',
		'Toggle Practice Mode',
		'Toggle Botplay',
		'Exit to menu'
	];

	var menuItems:Array<String> = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var practiceText:FlxText;
	var botplayText:FlxText;

	public function new(x:Float, y:Float)
	{
		Application.current.window.title += ' [Paused]';

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = PlayState.instance.rpcDetailsText + ' [Paused]';
		PlayState.instance.setRpcTimestamps(false);
		#end

		super();

		menuItems = pauseOG;

		pauseMusic = new FlxSound().loadEmbedded(Paths.location.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.location.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += PlayState.difficulty;
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.location.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var deathCounter:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		deathCounter.text = "Deaths: " + PlayState.deathCounter;
		deathCounter.scrollFactor.set();
		deathCounter.setFormat(Paths.location.font('vcr.ttf'), 32);
		deathCounter.updateHitbox();
		add(deathCounter);

		practiceText = new FlxText(20, 15 + 64 + 32, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.location.font('vcr.ttf'), 32);
		practiceText.updateHitbox();
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.visible = PlayState.practiceMode;
		add(practiceText);

		botplayText = new FlxText(20, 15 + 64 + 64, 0, "BOTPLAY", 32);
		botplayText.scrollFactor.set();
		botplayText.setFormat(Paths.location.font('vcr.ttf'), 32);
		botplayText.updateHitbox();
		botplayText.x = FlxG.width - (botplayText.width + 20);
		botplayText.visible = PlayState.botplay;
		add(botplayText);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		deathCounter.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		deathCounter.x = FlxG.width - (deathCounter.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(deathCounter, {alpha: 1, y: deathCounter.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		regenMenu();
	}

	function regenMenu():Void
	{
		while (grpMenuShit.members.length > 0)
		{
			grpMenuShit.remove(grpMenuShit.members[0], true);
		}

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], Bold);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		curSelected = 0;
		changeSelection();
	}

	var difficultyChoices:Array<String> = [];

	override public function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		if (controls.UI_UP_P)
			changeSelection(-1);

		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();

				case 'Toggle Practice Mode':
					PlayState.practiceMode = !PlayState.practiceMode;
					practiceText.visible = PlayState.practiceMode;

				case 'Toggle Botplay':
					PlayState.botplay = !PlayState.botplay;
					botplayText.visible = PlayState.botplay;

				case 'Change Difficulty':
					openDifficultyMenu();

				case "Restart Song":
					FlxG.resetState();

				case "Exit to menu":
					PlayState.seenCutscene = false;
					PlayState.seenEndCutscene = false;
					PlayState.deathCounter = 0;

					if (PlayState.isStoryMode)
						FlxG.switchState(new StoryMenuState());
					else
						FlxG.switchState(new FreeplayState());
			}

			if (difficultyChoices.contains(daSelected))
			{
				if (daSelected == 'BACK')
				{
					menuItems = pauseOG;
					regenMenu();
				}
				else
				{
					var difficulty:String = PlayState.storyWeek.difficulties[curSelected];

					for (i in PlayState.storyWeek.difficulties)
					{
						if (i.formatToPath() == daSelected.formatToPath())
						{
							difficulty = i;
							break;
						}
					}

					PlayState.SONG = Song.loadFromJson(difficulty.formatToPath(), PlayState.SONG.song.formatToPath());
					PlayState.difficulty = difficulty;
					FlxG.resetState();
				}
			}
		}
	}

	function openDifficultyMenu()
	{
		difficultyChoices = [];

		for (i in PlayState.storyWeek.difficulties)
			difficultyChoices.push(i.toUpperCase());

		difficultyChoices.push('BACK');

		menuItems = difficultyChoices;
		regenMenu();
	}

	override public function destroy()
	{
		pauseMusic.destroy();
		changeWindowName((!PlayState.isStoryMode ? 'Freeplay - ' : 'Story Mode - ') + PlayState.SONG.song + ' (' + PlayState.difficulty + ')');

		for (tween in PlayState.instance.bopTween)
			if (tween != null)
				tween.active = true;

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		FlxG.sound.play(Paths.location.sound('mainmenu/scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		if (curSelected >= menuItems.length)
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
}

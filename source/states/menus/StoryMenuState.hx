package states.menus;

import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.misc.ColorTween;
import objects.menu.MenuCharacter;
import objects.menu.WeekItem;
import openfl.Assets;

class StoryMenuState extends MusicBeatState
{
	private var curWeek:Int = 0;
	private var curDifficulty:Int = 1;

	private var scoreText:FlxText;
	private var txtWeekTitle:FlxText;

	private var daWeeks:Array<Week> = [];
	private var curWeekClass:Week;
	private var weekDifficulties:Array<Array<String>> = [];

	private var colorBG:FlxSprite;
	private var colorTween:ColorTween;
	private var txtTracklist:FlxText;

	private var grpWeekText:FlxTypedGroup<WeekItem>;
	private var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	private var grpLocks:FlxTypedGroup<FlxSprite>;

	private var difficultySelectors:FlxGroup;
	private var sprDifficulty:FlxSprite;
	private var leftArrow:FlxSprite;
	private var rightArrow:FlxSprite;

	override public function create()
	{
		changeWindowName('Story Menu');

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = 'Story Menu';
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.location.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: ", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: ';
		rankText.setFormat(Paths.location.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		colorBG = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFFFFFFF);

		grpWeekText = new FlxTypedGroup<WeekItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		Conductor.bpm = TitleState.introText.bpm;

		daWeeks = Week.weeks;
		curWeekClass = daWeeks[curWeek];

		for (i in 0...daWeeks.length)
		{
			var weekThing:WeekItem = new WeekItem(0, colorBG.y + colorBG.height + 10, daWeeks[i].nameData);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);

			if (daWeeks[i].lockMetadata.locked)
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x).loadGraphic(Paths.content.image('storyMenu/ui/lock'));
				lock.ID = i;
				grpLocks.add(lock);
			}

			for (song in daWeeks[i].songs)
			{
				for (difficulty in song.difficulties)
				{
					if (weekDifficulties[i] == null)
						weekDifficulties[i] = [];

					if (!weekDifficulties[i].contains(difficulty))
						weekDifficulties[i].push(difficulty);
				}
			}
		}

		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, curWeekClass.characters[char]);
			weekCharacterThing.y += 70;
			switch (weekCharacterThing.character)
			{
				case 'dad':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();

				case 'bf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
					weekCharacterThing.x -= 80;
				case 'gf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
				case 'pico':
					weekCharacterThing.flipX = true;
				case 'parents-christmas':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
			}

			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = Paths.content.sparrowAtlas('storyMenu/ui/arrowLeft');
		leftArrow.animation.addByPrefix('idle', 'idle');
		leftArrow.animation.addByPrefix('press', 'press');
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130,
			leftArrow.y).loadGraphic(Paths.content.image('storyMenu/difficulties/' + weekDifficulties[curWeek][curDifficulty].formatToPath()));
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(leftArrow.x + 380, leftArrow.y);
		rightArrow.frames = Paths.content.sparrowAtlas('storyMenu/ui/arrowRight');
		rightArrow.animation.addByPrefix('idle', 'idle');
		rightArrow.animation.addByPrefix('press', 'press');
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		add(colorBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, colorBG.x + colorBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		super.create();
	}

	override public function beatHit()
	{
		for (i in 0...3)
		{
			if (Conductor.curBeat % 2 == 0)
				grpWeekCharacters.members[i].animation.play('idle');
		}

		super.beatHit();
	}

	override public function update(elapsed:Float)
	{
		lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.5);

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		FlxG.watch.addQuick("sectionShit", Conductor.curSection);
		FlxG.watch.addQuick("beatShit", Conductor.curBeat);
		FlxG.watch.addQuick("stepShit", Conductor.curStep);

		scoreText.text = "WEEK SCORE:" + Math.round(lerpScore);

		txtWeekTitle.text = curWeekClass.motto.toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		difficultySelectors.visible = !curWeekClass.lockMetadata.locked;

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (FlxG.mouse.wheel != 0)
					changeWeek(-FlxG.mouse.wheel);

				if (controls.UI_UP_P)
				{
					changeWeek(-1);
					changeDifficulty();
				}

				if (controls.UI_DOWN_P)
				{
					changeWeek(1);
					changeDifficulty();
				}

				if (controls.UI_RIGHT)
				{
					rightArrow.animation.play('press');
					rightArrow.offset.y = -5;
				}
				else
				{
					rightArrow.animation.play('idle');
					rightArrow.offset.y = 0;
				}

				if (controls.UI_LEFT)
				{
					leftArrow.animation.play('press');
					leftArrow.offset.y = -5;
				}
				else
				{
					leftArrow.animation.play('idle');
					leftArrow.offset.y = 0;
				}

				if (controls.UI_RIGHT_P)
					changeDifficulty(1);

				if (controls.UI_LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
				selectWeek();
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.location.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	private var movedBack:Bool = false;
	private var selectedWeek:Bool = false;
	private var stopspamming:Bool = false;

	private function selectWeek()
	{
		if (!curWeekClass.lockMetadata.locked)
		{
			if (!stopspamming)
			{
				FlxG.sound.play(Paths.location.sound('confirmMenu'));

				if (ChillSettings.get('flashingLights'))
					grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('confirm');
				stopspamming = true;
			}

			PlayState.isStoryMode = true;
			selectedWeek = true;

			PlayState.difficulty = weekDifficulties[curWeek][curDifficulty];

			var whatToLoad:String = PlayState.difficulty.formatToPath();
			PlayState.SONG = Song.autoSelectJson(curWeekClass.songs[0].song.formatToPath(), whatToLoad);
			PlayState.songEvents = SongEvent.loadFromJson(curWeekClass.songs[0].song.formatToPath());
			if (PlayState.songEvents == null)
				PlayState.songEvents = [];
			PlayState.storyWeek = curWeekClass;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	private function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = weekDifficulties[curWeek].length - 1;

		if (curDifficulty >= weekDifficulties[curWeek].length)
			curDifficulty = 0;

		var difficulty:String = weekDifficulties[curWeek][curDifficulty];

		sprDifficulty.offset.x = 0;
		sprDifficulty.offset.y = 0;

		switch (difficulty.formatToPath())
		{
			case 'easy':
				sprDifficulty.offset.x = 20;

			case 'normal':
				sprDifficulty.offset.x = 70;

			case 'hard':
				sprDifficulty.offset.x = 20;

			case 'erect':
				sprDifficulty.offset.x = 35;

			case 'nightmare':
				sprDifficulty.offset.x = 80;
				sprDifficulty.offset.y = 10;
		}

		if (Paths.location.exists('images/storyMenu/difficulties/' + difficulty.formatToPath() + '.xml', null, TEXT))
		{
			sprDifficulty.frames = Paths.content.sparrowAtlas('storyMenu/difficulties/' + difficulty.formatToPath());
			sprDifficulty.animation.addByPrefix('idle', 'idle', 24);
			sprDifficulty.animation.play('idle');
		}
		else
			sprDifficulty.loadGraphic(Paths.content.image('storyMenu/difficulties/' + difficulty.formatToPath()));

		sprDifficulty.alpha = 0;
		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);

		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeekClass.name, difficulty);
	}

	private var lerpScore:Float = 0;
	private var intendedScore:Int = 0;

	private function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= daWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = daWeeks.length - 1;

		curWeekClass = daWeeks[curWeek];

		if (!weekDifficulties[curWeek].contains(weekDifficulties[curWeek][curDifficulty]))
			changeDifficulty();

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && !curWeekClass.lockMetadata.locked)
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.location.sound('scrollMenu'));

		updateText();
	}

	private function updateText()
	{
		if (colorTween != null)
			colorTween.cancel();
		colorTween = FlxTween.color(colorBG, 0.3, colorBG.color, curWeekClass.color);

		txtTracklist.text = "Tracks:\n";

		for (i in 0...3)
		{
			grpWeekCharacters.members[i].charChange(curWeekClass.characters[i]);
		}

		if (grpWeekCharacters.members[0].animation.curAnim.name != null)
		{
			switch (grpWeekCharacters.members[0].character)
			{
				case 'parents-christmas':
					grpWeekCharacters.members[0].offset.set(200, 200);
					grpWeekCharacters.members[0].setGraphicSize(grpWeekCharacters.members[0].width * 0.9);

				case 'senpai':
					grpWeekCharacters.members[0].offset.set(130, 0);
					grpWeekCharacters.members[0].setGraphicSize(grpWeekCharacters.members[0].width * 1.4);
					grpWeekCharacters.members[0].antialiasing = false;

				case 'mom':
					grpWeekCharacters.members[0].offset.set(100, 200);
					grpWeekCharacters.members[0].setGraphicSize(grpWeekCharacters.members[0].width * 0.99);

				case 'dad':
					grpWeekCharacters.members[0].offset.set(120, 200);
					grpWeekCharacters.members[0].setGraphicSize(grpWeekCharacters.members[0].width * 0.5);

				case 'tankman':
					grpWeekCharacters.members[0].offset.set(60, -20);
					grpWeekCharacters.members[0].setGraphicSize(grpWeekCharacters.members[0].width * 0.99);

				case 'bf':
					grpWeekCharacters.members[0].flipX = true;
					grpWeekCharacters.members[0].offset.set(100, 100);
					grpWeekCharacters.members[0].setGraphicSize(grpWeekCharacters.members[0].width * 0.99);
				case 'pico':
					grpWeekCharacters.members[0].flipX = true;
			}
			grpWeekCharacters.members[0].updateHitbox();
		}

		for (i in curWeekClass.songs)
		{
			var stringThing:Array<String> = [i.song];

			for (i in stringThing)
				txtTracklist.text += "\n" + i;
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		intendedScore = Highscore.getWeekScore(curWeekClass.name, weekDifficulties[curWeek][curDifficulty]);
	}
}

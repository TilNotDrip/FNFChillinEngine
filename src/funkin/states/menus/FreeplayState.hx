package funkin.states.menus;

#if FUNKIN_MOD_SUPPORT
import funkin.modding.FunkinModLoader;
#end
import flixel.tweens.misc.ColorTween;
import funkin.objects.game.HealthIcon;
import funkin.objects.TrackedSprite;
import funkin.util.Song;
import funkin.util.SongEvent;
import funkin.util.Week;

class FreeplayState extends MusicBeatState
{
	public var songs:Array<
		{
			song:String,
			week:Week
		}> = [];

	static var curSelected:Int = 0;
	static var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Float = 0;
	var intendedScore:Int = 0;

	var grpSongs:FlxTypedGroup<Alphabet>;
	var curPlaying:Bool = false;

	var iconArray:Array<HealthIcon> = [];
	var explicitSpr:FlxTypedGroup<TrackedSprite>;

	var bg:FlxSprite;
	var colorTween:ColorTween;
	var scoreBG:FlxSprite;

	override public function create()
	{
		changeWindowName('Freeplay Menu');

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = 'Freeplay Menu';
		#end

		if (FlxG.sound.music != null && !FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.content.music('freakyMenu'));

		bg = new FlxSprite().loadGraphic(Paths.content.imageGraphic('mainmenu/menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		explicitSpr = new FlxTypedGroup<TrackedSprite>();

		for (week in Week.weeks)
		{
			for (i in 0...week.songs.length)
			{
				songs.push({song: week.songs[i][0], week: week});

				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, week.songs[i][0], Bold);
				songText.isMenuItem = true;
				songText.targetY = i;
				grpSongs.add(songText);

				var icon:HealthIcon = new HealthIcon(week.icons[i]);
				icon.sprTracker = songText;

				iconArray.push(icon);
				add(icon);

				if (week.songs[i][1] == true)
				{
					var explicit:TrackedSprite = new TrackedSprite();
					explicit.frames = Paths.content.sparrowAtlas('freeplay/explicit');
					explicit.animation.addByPrefix('idle', 'Idle', 24, true);
					explicit.animation.play('idle');
					explicit.sprOffsetY + 70;
					explicit.sprTracker = icon;
					explicit.ID = iconArray.indexOf(icon);
					explicitSpr.add(explicit);
				}
			}
		}

		add(explicitSpr);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.location.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0x99000000);
		scoreBG.antialiasing = false;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		super.create();

		changeSelection();
		changeDifficulty();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.volume < 0.7)
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.4);

		scoreText.text = "PERSONAL BEST:" + Math.round(lerpScore);

		positionHighscore();

		if (controls.UI_UP_P)
			changeSelection(-1);
		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (FlxG.mouse.wheel != 0)
			changeSelection(-FlxG.mouse.wheel);

		if (controls.UI_LEFT_P)
			changeDifficulty(-1);

		if (controls.UI_RIGHT_P)
			changeDifficulty(1);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.content.sound('mainmenu/cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			var poop:String = songs[curSelected].week.difficulties[curDifficulty].formatToPath();
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].song.formatToPath());
			PlayState.songEvents = SongEvent.loadFromJson(songs[curSelected].song.formatToPath());

			if (PlayState.songEvents == null)
				PlayState.songEvents = [];

			PlayState.isStoryMode = false;
			PlayState.difficulty = songs[curSelected].week.difficulties[curDifficulty];

			PlayState.storyWeek = songs[curSelected].week;
			trace('Week: ' + PlayState.storyWeek.name);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDifficulty(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = songs[curSelected].week.difficulties.length - 1;

		if (curDifficulty >= songs[curSelected].week.difficulties.length)
			curDifficulty = 0;

		var daDiff:String = songs[curSelected].week.difficulties[curDifficulty];

		intendedScore = FunkinHighscore.getScore(songs[curSelected].song, daDiff);

		PlayState.difficulty = songs[curSelected].week.difficulties[curDifficulty];

		diffText.text = "< " + daDiff.toUpperCase() + " >";
		positionHighscore();
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

		#if FUNKIN_MOD_SUPPORT
		FunkinModLoader.rebuildCurrentMods(songs[curSelected].week.mod);
		#end

		FlxG.sound.play(Paths.content.sound('mainmenu/scrollMenu'), 0.4);

		if (!songs[curSelected].week.difficulties.contains(songs[curSelected].week.difficulties[curDifficulty]))
			changeDifficulty();

		intendedScore = FunkinHighscore.getScore(songs[curSelected].song, songs[curSelected].week.difficulties[curDifficulty]);

		if (colorTween != null)
			colorTween.cancel();
		colorTween = FlxTween.color(bg, 0.6, bg.color, songs[curSelected].week.color);

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
			iconArray[i].alpha = 0.6;

		iconArray[curSelected].alpha = 1;

		explicitSpr.forEach(function(explicit:TrackedSprite)
		{
			explicit.alpha = 0.6;

			if (explicit.ID != curSelected)
				explicit.alpha = 0.6;
			else
				explicit.alpha = 1;
		});

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}

	function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - scoreBG.scale.x / 2;

		diffText.x = Std.int(scoreBG.x + scoreBG.width / 2);
		diffText.x -= (diffText.width / 2);
	}
}

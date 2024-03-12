package states;

import flixel.tweens.misc.ColorTween;
import flash.text.TextField;

import flixel.addons.display.FlxGridOverlay;

import lime.utils.Assets;

class FreeplayState extends MusicBeatState
{
	var songs:Array<{
		song:String, 
		difficulties:Array<String>, 
		week:String, 
		color:FlxColor
	}>;

	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Float = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<objects.HealthIcon> = [];
	var bg:FlxSprite;
	var colorTween:ColorTween;
	var scoreBG:FlxSprite;

	override function create()
	{
		#if discord_rpc
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		bg = new FlxSprite().loadGraphic(Paths.image('menuUI/menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for(week in Week.weeks)
		{
			for (i in 0...week.songs.length)
			{
				songs.push({song: week.songs[i], difficulties: week.difficulties, week: week.name, color: week.color});

				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, week.songs[i], true, false);
				songText.isMenuItem = true;
				songText.targetY = i;
				grpSongs.add(songText);
		
				var icon:objects.HealthIcon = new objects.HealthIcon(week.icons[i]);
				icon.sprTracker = songText;
		
				iconArray.push(icon);
				add(icon);
			}
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0x99000000);
		scoreBG.antialiasing = false;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.volume < 0.7)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
		}

		lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.4);

		scoreText.text = "PERSONAL BEST:" + Math.round(lerpScore);

		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);

		if (FlxG.mouse.wheel != 0)
			changeSelection(-Math.round(FlxG.mouse.wheel / 4));

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].song, songs[curSelected].difficulties[curDifficulty]);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].song.formatToPath());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = songs[curSelected].difficulties[curDifficulty];

			PlayState.storyWeek = songs[curSelected];
			trace('CUR WEEK: ' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	var lastDifficulty:String;
	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		var daDiff:String = songs[curSelected].difficulties[curDifficulty];

		if(lastDifficulty != daDiff) {
			curDifficulty = Std.int((songs[curSelected].difficulties.length / 2) - 1);
			daDiff = songs[curSelected].difficulties[curDifficulty];
		}

		intendedScore = Highscore.getScore(songs[curSelected].song, daDiff);

		PlayState.storyDifficulty = songs[curSelected].difficulties[curDifficulty];

		diffText.text = "< " + daDiff.toUpperCase() + " >";
		positionHighscore();

		lastDifficulty = daDiff;
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		intendedScore = Highscore.getScore(songs[curSelected].song, songs[curSelected].difficulties[curDifficulty]);

		/*#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].song), 0);
		#end*/

		colorTween.cancel();
		colorTween = FlxTween.color(bg, 3, bg.color, songs[curSelected].color);

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

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

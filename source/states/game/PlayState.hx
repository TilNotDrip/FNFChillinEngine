package states.game;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.addons.text.FlxTypeText;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.Section.SwagSection;
import addons.SongEvent.SwagEvent;
import addons.Song.SwagSong;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.addons.effects.FlxTrail;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.ui.FlxBar;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
#if hxvlc
import hxvlc.flixel.FlxVideo;
#end
import objects.game.*;
import stages.StageBackend;
import stages.bgs.*;
import states.tools.*;
import substates.*;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var songEvents:Array<SwagEvent>;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Week = null;
	public static var storyPlaylist:Array<String> = [];
	public static var difficulty:String = 'Normal';

	public static var deathCounter:Int = 0;

	public static var practiceMode:Bool = false;
	public static var botplay:Bool = false;
	public static var botplayDad:Bool = true;

	// public var inst:FlxSound;
	public var vocals:FlxSound;
	public var vocalsFinished:Bool = false;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Character;

	public var dadGroup:FlxTypedSpriteGroup<Character>;
	public var gfGroup:FlxTypedSpriteGroup<Character>;
	public var boyfriendGroup:FlxTypedSpriteGroup<Character>;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;

	public var camFollow:FlxObject;

	public static var prevCamFollow:FlxObject;

	public var strumLineNotes:FlxTypedGroup<Strums>;

	public var playerStrums:Strums;
	public var playerSplashes:FlxTypedGroup<NoteSplash>;

	public var opponentStrums:Strums;
	public var opponentSplashes:FlxTypedGroup<NoteSplash>;

	public var health:Float = 1;
	public var minHealth:Float = 0;
	public var maxHealth:Float = 2;

	public var combo:Int = 0;

	public var songScore:Int = 0;
	public var songMisses:Int = 0;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;

	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;

	public var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;

	public var generatedMusic:Bool = false;
	public var startingSong:Bool = false;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var bopTween:Array<FlxTween> = [null, null];

	public var camGAME:FlxCamera;
	public var camHUD:FlxCamera;
	public var camDIALOGUE:FlxCamera;

	public var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	public var songTxt:FlxText;
	public var ratingCounterTxt:FlxText;
	public var healthOppTxt:FlxText;
	public var healthPlayerTxt:FlxText;
	public var scoreTxt:FlxText;

	public var possibleScore:Int = 0;
	public var songAccuracy:Float = 0;

	public static var daPixelZoom:Float = 6;
	public static var isPixel:Bool = false;

	public var inCutscene(default, set):Bool = false;

	public static var seenCutscene:Bool = false;
	public static var seenEndCutscene:Bool = false;

	public var isEnding:Bool = false;

	public var singArray:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var lyricText:FlxTypeText;

	#if DISCORD
	public var rpcDetailsText:String = PlayState.SONG.song;
	public var rpcStateText:String = '[$difficulty] [Week: ${storyWeek.name}] ' + (!isStoryMode ? '[Freeplay]' : '[Story Mode]');
	#end

	public static var game:PlayState;

	override public function create()
	{
		game = this;

		changeWindowName((!isStoryMode ? 'Freeplay - ' : 'Story Mode - ') + SONG.song + ' (' + difficulty + ')');

		#if DISCORD
		DiscordRPC.details = rpcDetailsText;
		DiscordRPC.state = rpcStateText;
		#end

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.sound.cache(Paths.inst(SONG.song));
		FlxG.sound.cache(Paths.voices(SONG.song));

		camGAME = new SwagCamera();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		camDIALOGUE = new FlxCamera();
		camDIALOGUE.bgColor.alpha = 0;

		FlxG.cameras.add(camGAME, true);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camDIALOGUE, false);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('normal', 'test');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.formatToPath())
		{
			case 'tutorial':
				dialogue = [
					":gf:Hey you're pretty cute.",
					':gf:Use the arrow keys to keep up \nwith me singing.'
				];
			case 'bopeebo':
				dialogue = [
					':dad:HEY!',
					":dad:You think you can just sing\nwith my daughter like that?",
					":dad:If you want to date her...",
					":dad:You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = [":dad:Not too shabby boy.", ":bf:idfk lol"];
			case 'dad-battle':
				dialogue = [
					":dad:gah you think you're hot stuff?",
					":dad:If you can beat me here...",
					":dad:Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}

		HScript.loadAllScriptsAtPath('scripts/PlayState', [
			'camGAME' => camGAME, 'camHUD' => camHUD, 'camDIALOGUE' => camDIALOGUE, 'isPixel' => isPixel, 'inCutscene' => inCutscene, 'dialogue' => dialogue,
			'gf' => gf, 'opponent' => dad, 'player' => boyfriend, 'dad' => dad, 'boyfriend' => boyfriend, 'camFollow' => camFollow, 'game' => game
		]);

		curStage = SONG.stage;

		switch (curStage)
		{
			case 'stage':
				new FunkinStage();
			case 'spooky':
				new Spooky();
			case 'philly':
				new Philly();
			case 'limo':
				new Limo();
			case 'mall':
				new Mall();
			case 'mallEvil':
				new MallEvil();
			case 'school':
				new School();
			case 'schoolEvil':
				new SchoolEvil();
			case 'tank':
				new Tank();
		}

		HScript.runFunction('create');

		isPixel = StageBackend.stage.pixel;

		gfGroup = new FlxTypedSpriteGroup<Character>(400, 130);
		dadGroup = new FlxTypedSpriteGroup<Character>(100, 100);
		boyfriendGroup = new FlxTypedSpriteGroup<Character>(770, 450);

		addCharacterToList(SONG.player3, 'gf');
		addCharacterToList(SONG.player2, 'dad');
		addCharacterToList(SONG.player1, 'bf');

		add(gfGroup);
		add(dadGroup);
		add(boyfriendGroup);

		gf = new Character(0, 0, SONG.player3);
		gfGroup.scrollFactor.set(0.95, 0.95);

		dad = new Character(0, 0, SONG.player2);

		if (dad.curCharacter == gf.curCharacter)
		{
			dadGroup.setPosition(gfGroup.x, gfGroup.y);
			gfGroup.visible = false;
			if (isStoryMode)
			{
				tweenCam(true);
			}
		}

		boyfriend = new Character(0, 0, SONG.player1, true);

		gfGroup.add(gf);
		dadGroup.add(dad);
		boyfriendGroup.add(boyfriend);

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);

		if (ChillSettings.get('downScroll', GAMEPLAY))
			strumLine.y = FlxG.height - 150;

		strumLine.scrollFactor.set();
		strumLineNotes = new FlxTypedGroup<Strums>();
		add(strumLineNotes);

		if (ChillSettings.get('noteSplashes', GAMEPLAY))
		{
			playerSplashes = new FlxTypedGroup<NoteSplash>(51);
			opponentSplashes = new FlxTypedGroup<NoteSplash>(51);

			var noteSplashPlayer:NoteSplash = new NoteSplash(100, 100,
				0); // I dont mean to add 2 of the same thing BUT it does double the speed for whatever reason
			playerSplashes.add(noteSplashPlayer);
			noteSplashPlayer.alpha = 0;

			var noteSplashOpponent:NoteSplash = new NoteSplash(100, 100, 0);
			opponentSplashes.add(noteSplashOpponent);
			noteSplashOpponent.alpha = 0;

			add(playerSplashes);
			add(opponentSplashes);
		}

		generateSong();

		camFollow = new FlxObject(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y - 100, 1, 1);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		camGAME.follow(camFollow, LOCKON, 0.04);
		camGAME.zoom = StageBackend.stage.zoom;
		camGAME.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('ui/healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		if (ChillSettings.get('downScroll', GAMEPLAY))
			healthBarBG.y = FlxG.height * 0.1;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', minHealth, maxHealth);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		add(healthBar);

		if (ChillSettings.get('hudType', GAMEPLAY) == 'Score / Rating Counter / Health')
		{
			songTxt = new FlxText(-5, 5, FlxG.width, "", 20);
			songTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songTxt.scrollFactor.set();
			add(songTxt);

			ratingCounterTxt = new FlxText(5, 0, FlxG.width, "", 20);
			ratingCounterTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			ratingCounterTxt.screenCenter(Y);
			ratingCounterTxt.scrollFactor.set();
			add(ratingCounterTxt);

			healthOppTxt = new FlxText((-healthBarBG.x + -healthBarBG.width) + -135, healthBarBG.y, FlxG.width, "", 20);
			healthOppTxt.setFormat(Paths.font("vcr.ttf"), 16, 0xFFFF0000, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			healthOppTxt.scrollFactor.set();
			add(healthOppTxt);

			healthPlayerTxt = new FlxText((healthBarBG.x + healthBarBG.width) + 135, healthBarBG.y, FlxG.width, "", 20);
			healthPlayerTxt.setFormat(Paths.font("vcr.ttf"), 16, 0xFF66FF33, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			healthPlayerTxt.scrollFactor.set();
			add(healthPlayerTxt);

			changeHealthText();
		}

		scoreTxt = new FlxText(0, healthBarBG.y + 30, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.screenCenter(X);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		changeScoreText();

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		updateHealthBar();

		lyricText = new FlxTypeText(0, 0, FlxG.width, "", 36);
		lyricText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(lyricText);

		if (ChillSettings.get('hudType', GAMEPLAY) == 'Score / Rating Counter / Health')
		{
			healthOppTxt.color = iconP2.curHealthBarColor;
			healthPlayerTxt.color = iconP1.curHealthBarColor;
		}

		if (ChillSettings.get('noteSplashes', GAMEPLAY))
		{
			playerSplashes.cameras = [camHUD];
			opponentSplashes.cameras = [camHUD];
		}

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];

		if (ChillSettings.get('hudType', GAMEPLAY) == 'Score / Rating Counter / Health')
		{
			songTxt.cameras = [camHUD];
			ratingCounterTxt.cameras = [camHUD];
			healthOppTxt.cameras = [camHUD];
			healthPlayerTxt.cameras = [camHUD];
		}

		scoreTxt.cameras = [camHUD];
		lyricText.cameras = [camHUD];

		startingSong = true;

		super.create();

		StageBackend.stage.createPost();

		HScript.runFunction('createPost');

		if (!seenCutscene && ChillSettings.get('cutscenes', GAMEPLAY))
		{
			if (StageBackend.stage.startCallback != null)
				StageBackend.stage.startCallback();
			else
				startCountdown();
		}
		else
			startCountdown();
	}

	public function playVideo(videoFile:String)
	{
		#if VIDEOS
		inCutscene = true;

		#if hxvlc
		var video:FlxVideo = new FlxVideo();
		video.onEndReached.add(function()
		{
			video.dispose();
			videoCallback();
		});
		video.load(Paths.video(videoFile));
		video.play();
		#else
		var video:FlxVideo = new FlxVideo(Paths.video(videoFile));
		video.finishCallback = videoCallback;
		#end
		#end
	}

	private function videoCallback()
	{
		StageBackend.stage.endingVideo();
		HScript.runFunction('endingVideo');

		startCountdown();
		if (generatedMusic && SONG.notes[curSection] != null)
		{
			if (SONG.notes[curSection].mustHitSection)
				cameraMovement(boyfriend);
			else
				cameraMovement(dad);
		}
	}

	private var startTimer:FlxTimer = new FlxTimer();
	private var perfectMode:Bool = false;

	public function startCountdown()
	{
		seenCutscene = true;
		inCutscene = false;

		var daFunction:Array<Dynamic> = HScript.runFunction('startCountdown');

		if (daFunction.contains(HScript.StopFunction))
			return;

		startedCountdown = true;

		generateStaticArrows(0);
		generateStaticArrows(1);

		Conductor.songPosition = -(Conductor.crochet * 5);

		var swagCounter:Int = 0;

		startTimer.start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			cameraMovement((SONG.notes[0].mustHitSection) ? boyfriend : dad);

			for (char in [dad, gf, boyfriend])
			{
				if (!char.animation.curAnim.name.startsWith("sing") && swagCounter % char.bopDance == 0)
					char.dance();
			}

			if (generatedMusic)
				notes.sort(sortNotes, FlxSort.DESCENDING);

			var altSuffix:String = "";
			if (isPixel)
				altSuffix = 'pixel';

			var introSprPaths:Array<String> = [altSuffix + "ui/ready", altSuffix + "ui/set", altSuffix + "ui/go"];

			var altSuffix2:String = "";
			if (isPixel)
				altSuffix2 = '-pixel';
			var introSndPaths:Array<String> = [
				"intro3" + altSuffix2,
				"intro2" + altSuffix2,
				"intro1" + altSuffix2,
				"introGo" + altSuffix2
			];

			if (swagCounter > 0)
				readySetGo(introSprPaths[swagCounter - 1]);
			FlxG.sound.play(Paths.sound(introSndPaths[swagCounter]), 0.6);

			swagCounter += 1;
		}, 4);
	}

	private function readySetGo(path:String):Void
	{
		var spr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(path));
		spr.scrollFactor.set();

		if (isPixel)
		{
			spr.setGraphicSize(Std.int(spr.width * daPixelZoom));
			spr.antialiasing = false;
		}

		spr.updateHitbox();
		spr.screenCenter();
		add(spr);
		FlxTween.tween(spr, {y: spr.y += 100, alpha: 0}, Conductor.crochet / 1000, {
			ease: FlxEase.cubeInOut,
			onComplete: function(twn:FlxTween)
			{
				spr.destroy();
			}
		});
	}

	var previousFrameTime:Int = 0;
	var songTime:Float = 0;

	public function startSong():Void
	{
		startingSong = false;

		canEnd = true;

		previousFrameTime = FlxG.game.ticks;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(SONG.song), 1, false);

		vocals.play();

		#if DISCORD
		setRpcTimestamps(true);
		#end

		FlxG.sound.music.onComplete = function()
		{
			endSong();
		};

		HScript.runFunction('startSong');
	}

	public function generateSong():Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(SONG.song));
		else
			vocals = new FlxSound();

		vocals.onComplete = function()
		{
			vocalsFinished = true;
		};

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		noteData = songData.notes;

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
					gottaHitNote = !section.mustHitSection;

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, (gottaHitNote) ? boyfriend.isPixel : dad.isPixel, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.altNote = songNotes[3];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData,
						(gottaHitNote) ? boyfriend.isPixel : dad.isPixel, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
						sustainNote.x += FlxG.width / 2;
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
					swagNote.x += FlxG.width / 2;
			}
		}

		unspawnNotes.sort(sortByShit);

		for (event in songEvents)
		{
			preloadEvent(event.name, event.value, event.strumTime);
		}

		generatedMusic = true;
	}

	private function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return sortNotes(FlxSort.ASCENDING, Obj1, Obj2);
	}

	private function sortNotes(order:Int = FlxSort.ASCENDING, Obj1:Note, Obj2:Note)
	{
		return FlxSort.byValues(order, Obj1.strumTime, Obj2.strumTime);
	}

	public function generateStaticArrows(player:Int):Void
	{
		var arrows:Strums = new Strums(0, strumLine.y, 4, (player == 1) ? boyfriend.isPixel : dad.isPixel);
		for (i in 0...arrows.notes)
		{
			var babyArrow:FlxSprite = arrows.getNote(i);
			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
		}

		arrows.updateHitbox();
		arrows.scrollFactor.set();

		arrows.x = ((FlxG.width / 2) * player) + ((FlxG.width / 2 - arrows.width) / 2);

		if (ChillSettings.get('middleScroll', GAMEPLAY))
			arrows.screenCenter(X);

		var dummyNotes:Array<Note> = [];
		for (i in 0...arrows.notes)
			dummyNotes.push(new Note(0, i, (player == 1) ? boyfriend.isPixel : dad.isPixel));

		if (player == 1)
		{
			playerStrums = arrows;

			playerStrums.pressNoteLeft.rgb = dummyNotes[0].returnColors(0);
			playerStrums.pressNoteDown.rgb = dummyNotes[1].returnColors(1);
			playerStrums.pressNoteUp.rgb = dummyNotes[2].returnColors(2);
			playerStrums.pressNoteRight.rgb = dummyNotes[3].returnColors(3);
		}
		else
		{
			opponentStrums = arrows;

			if (ChillSettings.get('middleScroll', GAMEPLAY))
				arrows.visible = false;

			opponentStrums.pressNoteLeft.rgb = dummyNotes[0].returnColors(0);
			opponentStrums.pressNoteDown.rgb = dummyNotes[1].returnColors(1);
			opponentStrums.pressNoteUp.rgb = dummyNotes[2].returnColors(2);
			opponentStrums.pressNoteRight.rgb = dummyNotes[3].returnColors(3);
		}

		strumLineNotes.add(arrows);
	}

	private function tweenCam(goingIn:Bool):Void
	{
		if (goingIn)
		{
			FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {
				ease: FlxEase.elasticInOut,
				onUpdate: function(twn:FlxTween)
				{
					StageBackend.stage.zoom = camGAME.zoom;
				}
			});
		}
		else
		{
			FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {
				ease: FlxEase.elasticInOut,
				onUpdate: function(twn:FlxTween)
				{
					StageBackend.stage.zoom = camGAME.zoom;
				}
			});
		}
	}

	override public function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		SubState.camera = camHUD;
		super.openSubState(SubState);
	}

	override public function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
				resyncVocals();

			if (!startTimer.finished)
				startTimer.active = true;

			paused = false;
		}

		super.closeSubState();

		#if DISCORD
		DiscordRPC.details = rpcDetailsText;
		DiscordRPC.state = rpcStateText;
		setRpcTimestamps(true);
		#end
	}

	override public function onFocus():Void
	{
		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		if (!paused)
			pauseGame();

		super.onFocusLost();
	}

	private function resyncVocals():Void
	{
		if (_exiting)
			return;

		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time + Conductor.offset;

		if (vocalsFinished)
			return;

		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	public var paused:Bool = false;
	public var startedCountdown:Bool = false;
	public var canPause:Bool = false;
	public var canEnd:Bool = false;

	public var eventsCalled:Array<SwagEvent> = [];

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition = FlxG.sound.music.time + Conductor.offset;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}
		}

		StageBackend.stage.update(elapsed);
		HScript.runFunction('update', [elapsed]);

		super.update(elapsed);

		lyricText.updateHitbox();
		lyricText.screenCenter(X);
		lyricText.y = healthBarBG.y - ((100 - lyricText.height) * ((ChillSettings.get('downScroll', GAMEPLAY)) ? -1 : 1));

		if (ChillSettings.get('hudType', GAMEPLAY) == 'Score / Rating Counter / Health')
			songTxt.text = '['
				+ FlxStringUtil.formatTime(FlxG.sound.music.time / 1000, false)
				+ ' / '
				+ FlxStringUtil.formatTime(FlxG.sound.music.length / 1000, false)
				+ '] ['
				+ FlxMath.roundDecimal((FlxG.sound.music.time / FlxG.sound.music.length) * 100, 0)
				+ '%] '
				+ SONG.song
				+ ' - '
				+ difficulty;

		if (controls.PAUSE)
			pauseGame();

		if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
			updateHealthBar();
		}

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > maxHealth && !Main.aprilFools)
			health = maxHealth;

		if (health < minHealth && !Main.aprilFools)
			health = minHealth;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (ChillSettings.get('devMode', OTHER))
		{
			if (FlxG.keys.justPressed.SEVEN && !isEnding)
				FlxG.switchState(new ChartingState());

			if (FlxG.keys.justPressed.EIGHT && !isEnding)
			{
				if (FlxG.keys.pressed.SHIFT)
					if (FlxG.keys.pressed.CONTROL)
						FlxG.switchState(new AnimationDebug(SONG.player3, false));
					else
						FlxG.switchState(new AnimationDebug(SONG.player1, true));
				else
					FlxG.switchState(new AnimationDebug(SONG.player2, false));
			}

			if (FlxG.keys.justPressed.ONE && !isEnding && canEnd)
			{
				FlxG.sound.music.stop();
				vocals.stop();
				endSong();
			}

			if (FlxG.keys.justPressed.PAGEUP && !isEnding)
				changeSection(1);
			if (FlxG.keys.justPressed.PAGEDOWN && !isEnding)
				changeSection(1);

			if (FlxG.keys.justPressed.L && !isEnding)
				botplayDad = !botplayDad;
		}

		if (!inCutscene)
		{
			camGAME.zoom = FlxMath.lerp(StageBackend.stage.zoom, camGAME.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("sectionShit", curSection);
		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (SONG.song.formatToPath() == 'fresh')
		{
			switch (curBeat)
			{
				case 16:
					gf.bopDance = 2;
				case 48:
					gf.bopDance = 1;
				case 80:
					gf.bopDance = 2;
				case 112:
					gf.bopDance = 1;
				case 163:
			}
		}

		if (SONG.song.formatToPath() == 'bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
			}
		}

		if (!inCutscene && !_exiting)
		{
			if (controls.RESET)
				health = minHealth;

			#if CAN_CHEAT
			if (controls.CHEAT)
			{
				health += 1;
				trace("User is cheating!");
			}
			#end

			if (((health <= minHealth && !botplay) || (health >= maxHealth && !botplayDad)) && !practiceMode)
			{
				if ((botplay && botplayDad) || (!botplay && !botplayDad))
					return;

				deathCounter += 1;

				FlxG.sound.music.stop();
				vocals.stop();

				if (FlxG.random.bool(0.1))
					FlxG.switchState(new GameOverState(boyfriend.deathCharacter));
				else
				{
					persistentUpdate = false;
					persistentDraw = false;

					paused = true;

					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, boyfriend.deathCharacter, camGAME));
				}
			}
		}

		while (unspawnNotes[0] != null && unspawnNotes[0].strumTime - Conductor.songPosition < 1800 / SONG.speed)
		{
			var dunceNote:Note = unspawnNotes[0];
			notes.add(dunceNote);

			var index:Int = unspawnNotes.indexOf(dunceNote);
			unspawnNotes.shift();
		}

		for (event in songEvents)
		{
			if (Conductor.songPosition >= event.strumTime && !eventsCalled.contains(event))
			{
				onEvent(event.name, event.value);
				eventsCalled.push(event);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				var whatStrum:Strums = (daNote.mustPress) ? playerStrums : opponentStrums;

				daNote.visible = whatStrum.visible;

				if ((ChillSettings.get('downScroll', GAMEPLAY) && daNote.y < -daNote.height)
					|| (!ChillSettings.get('downScroll', GAMEPLAY) && daNote.y > FlxG.height))
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				var strumLineMid = whatStrum.y + Note.swagWidth / 2;

				if (ChillSettings.get('downScroll', GAMEPLAY))
				{
					daNote.y = (whatStrum.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

					if (daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith("end") && daNote.prevNote != null)
							daNote.y += daNote.prevNote.height;
						else
							daNote.y += daNote.height / 2;

						if (((!daNote.mustPress || daNote.mustPress && botplay)
							|| (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))
							&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= strumLineMid)
						{
							var swagRect:FlxRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);

							swagRect.height = (strumLineMid - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;
							daNote.clipRect = swagRect;
						}
					}
				}
				else
				{
					daNote.y = (whatStrum.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

					if (daNote.isSustainNote
						&& ((!daNote.mustPress || daNote.mustPress && botplay)
							|| (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))
						&& daNote.y + daNote.offset.y * daNote.scale.y <= strumLineMid)
					{
						var swagRect:FlxRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);

						swagRect.y = (strumLineMid - daNote.y) / daNote.scale.y;
						swagRect.height -= swagRect.y;
						daNote.clipRect = swagRect;
					}
				}

				daNote.x = whatStrum.x + (Note.swagWidth * daNote.noteData);
				if (daNote.isSustainNote)
					daNote.x += ((Note.swagWidth - daNote.width) / 2);

				if (!daNote.mustPress && daNote.strumTime <= Conductor.songPosition && botplayDad)
					opponentNoteHit(daNote);

				if (daNote.mustPress && daNote.strumTime <= Conductor.songPosition && botplay)
					goodNoteHit(daNote);

				if (daNote.isSustainNote && daNote.wasGoodHit)
				{
					if ((!ChillSettings.get('downScroll', GAMEPLAY) && daNote.y < -daNote.height)
						|| (ChillSettings.get('downScroll', GAMEPLAY) && daNote.y > FlxG.height))
					{
						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
				else if (daNote.tooLate || daNote.wasGoodHit)
				{
					if (daNote.tooLate && !botplay) // little behind-the-scenes trick!
					{
						noteMiss(daNote);
						vocals.volume = 0;
						killCombo();
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if (!inCutscene && !botplay)
			keyShitPlayer();

		if (!inCutscene && !botplayDad)
			keyShitOpponent();

		if (!inCutscene)
		{
			if (botplayDad)
			{
				for (i in 0...opponentStrums.notes)
				{
					if (opponentStrums.getNote(i).animation.finished && opponentStrums.getNote(i).animation.name == 'confirm')
						opponentStrums.playNoteAnim(i, 'static');
				}
			}

			if (botplay)
			{
				for (i in 0...playerStrums.notes)
				{
					if (playerStrums.getNote(i).animation.finished && playerStrums.getNote(i).animation.name == 'confirm')
						playerStrums.playNoteAnim(i, 'static');
				}

				if (boyfriend.animation.finished && boyfriend.animation.name != 'idle')
					boyfriend.playAnim('idle');
			}
		}
	}

	private function killCombo():Void
	{
		if (combo > 5 && gf.animOffsets.exists('sad'))
			gf.playAnim('sad');
		if (combo != 0)
		{
			combo = 0;
			displayCombo();
		}
	}

	private function pauseGame()
	{
		if (canPause && !isEnding)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			for (tween in bopTween)
				if (tween != null)
					tween.active = false;

			if (FlxG.random.bool(0.1))
				FlxG.switchState(new GitarooPause());
			else
			{
				var boyfriendPos = boyfriend.getScreenPosition();
				openSubState(new PauseSubState(boyfriendPos.x, boyfriendPos.y));
				boyfriendPos.put();
			}
		}
	}

	public function camZoom(gameCamZoom:Float = 0.015, camHudZoom:Float = 0.03)
	{
		if (ChillSettings.get('camZoom', GAMEPLAY))
		{
			camGAME.zoom += gameCamZoom;
			camHUD.zoom += camHudZoom;
		}
	}

	private function changeSection(sec:Int):Void
	{
		FlxG.sound.music.pause();
		vocals.pause();

		var daBPM:Float = SONG.bpm;
		var daPos:Float = 0;

		for (i in 0...(curSection + sec))
		{
			if (SONG.notes[i].changeBPM)
				daBPM = SONG.notes[i].bpm;

			daPos += 4 * (1000 * 60 / daBPM);
		}

		Conductor.songPosition = FlxG.sound.music.time = daPos;

		updateStep();
		resyncVocals();

		#if DISCORD
		setRpcTimestamps(true);
		#end
	}

	public var endScreen:Bool = true;

	public function endSong()
	{
		var daFunction:Array<Dynamic> = HScript.runFunction('endSong');

		if (daFunction.contains(HScript.StopFunction))
			return;

		if (endScreen)
		{
			openSubState(new EndSubState());
			endScreen = false;
			return;
		}

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		seenEndCutscene = false;
		seenCutscene = false;
		deathCounter = 0;

		isEnding = true;

		HScript.destroyAllScripts();

		if (!practiceMode && !botplay)
			Highscore.saveScore(SONG.song, songScore, difficulty);

		if (isStoryMode)
			finishSongStory();
		else
			FlxG.switchState(new FreeplayState());
	}

	public function finishSongStory()
	{
		campaignScore += songScore;

		storyPlaylist.remove(storyPlaylist[0]);

		if (storyPlaylist.length <= 0)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			FlxG.switchState(new StoryMenuState());

			storyWeek.locked = false;

			Highscore.saveWeekScore(storyWeek.name, campaignScore, difficulty);
		}
		else
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;

			FlxG.sound.music.stop();
			vocals.stop();

			prevCamFollow = camFollow;
			SONG = Song.loadFromJson(difficulty.formatToPath(), storyPlaylist[0]);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	private function set_inCutscene(inCutscene:Bool)
	{
		if (inCutscene)
		{
			camHUD.visible = false;
			canPause = false;
			canEnd = false;
		}
		else
		{
			camHUD.visible = true;
			canPause = true;
		}

		return this.inCutscene = inCutscene;
	}

	public function changeScoreText(miss:Bool = false)
	{
		var score:String = '[Score: $songScore]';
		var misses:String = '[Misses: $songMisses]';
		var accuracy:String = '[Accuracy: $songAccuracy%]';

		scoreTxt.text = '$score $misses $accuracy';

		if (miss)
		{
			scoreTxt.color = FlxColor.RED;
			new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				scoreTxt.color = FlxColor.WHITE;
			});
		}

		changeHealthText();
		changeJudgementText();
	}

	public function changeHealthText()
	{
		if (ChillSettings.get('hudType', GAMEPLAY) == 'Score / Rating Counter / Health')
		{
			var healthPlayer:Dynamic = FlxMath.roundDecimal(health * 50, 2);
			var healthOpp:Dynamic = FlxMath.roundDecimal((maxHealth * 50) - (health * 50), 2);

			healthPlayerTxt.text = '[Health: $healthPlayer%]';
			healthOppTxt.text = '[Health: $healthOpp%]';
		}
	}

	public function changeJudgementText()
	{
		if (ChillSettings.get('hudType', GAMEPLAY) == 'Score / Rating Counter / Health')
		{
			var sickTxt = '[Sicks: $sicks]';
			var goodTxt = '[Goods: $goods]';
			var badTxt = '[Bads: $bads]';
			var shitTxt = '[Shits: $shits]';
			ratingCounterTxt.text = '$sickTxt\n$goodTxt\n$badTxt\n$shitTxt';
		}
	}

	public function updateHealthBar()
	{
		iconP1.changeIcon(PlayState.game.boyfriend.curCharacter);
		iconP2.changeIcon(PlayState.game.dad.curCharacter);

		healthBar.createFilledBar(iconP2.curHealthBarColor, iconP1.curHealthBarColor);
		healthBar.updateFilledBar();

		healthOppTxt.color = iconP2.curHealthBarColor;
		healthPlayerTxt.color = iconP1.curHealthBarColor;

		#if DISCORD
		DiscordRPC.smallImageKey = 'icon-${iconP2.char}';
		DiscordRPC.smallImageText = PlayState.game.dad.curCharacter;
		#end
	}

	public function popUpScore(strumtime:Float, daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		vocals.volume = 1;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		var isSick:Bool = true;

		if (!botplay) // behind the scenes trick!! part 3
		{
			if (noteDiff > Conductor.safeZoneOffset * 0.9)
			{
				shits++;

				daRating = 'shit';
				score = 50;
				isSick = false;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.75)
			{
				bads++;

				daRating = 'bad';
				score = 100;
				isSick = false;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.2)
			{
				goods++;

				daRating = 'good';
				score = 200;
				isSick = false;
			}
		}

		if (isSick)
		{
			sicks++;

			if (ChillSettings.get('noteSplashes', GAMEPLAY))
			{
				var noteSplashPlayer:NoteSplash = playerSplashes.recycle(NoteSplash);
				noteSplashPlayer.setupNoteSplash(daNote.x, daNote.y, daNote.noteData, boyfriend.isPixel);
				noteSplashPlayer.setColors(daNote.returnColors(daNote.noteData));
				playerSplashes.add(noteSplashPlayer);
			}
		}

		songScore += score;
		possibleScore += 350;

		var ratingPath:String = "ui/" + daRating;

		if (isPixel)
			ratingPath = "pixel" + ratingPath;

		rating.loadGraphic(Paths.image(ratingPath));
		rating.x = gfGroup.x + 200 - 40;

		rating.y = gfGroup.y + 200 - 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		if (isPixel)
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			rating.antialiasing = false;
		}
		else
			rating.setGraphicSize(Std.int(rating.width * 0.7));

		rating.updateHitbox();

		add(rating);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		if (combo >= 10 || combo == 0)
			displayCombo();
	}

	private function displayCombo():Void
	{
		var pixelShitPart1:String = "";

		if (isPixel)
			pixelShitPart1 = 'pixel';

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'ui/combo'));
		comboSpr.y = gfGroup.y + 200 + 80;
		comboSpr.x = gfGroup.x + 200;

		if (comboSpr.x < camGAME.scroll.x + 194)
			comboSpr.x = camGAME.scroll.x + 194;
		else if (comboSpr.x > camGAME.scroll.x + camGAME.width - comboSpr.width)
			comboSpr.x = camGAME.scroll.x + camGAME.width - comboSpr.width;

		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.velocity.x += FlxG.random.int(1, 10);

		add(comboSpr);

		if (isPixel)
		{
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			comboSpr.antialiasing = false;
		}
		else
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));

		comboSpr.updateHitbox();

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				comboSpr.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		var seperatedScore:Array<Int> = [];
		var tempCombo:Int = combo;

		while (tempCombo != 0)
		{
			seperatedScore.push(tempCombo % 10);
			tempCombo = Std.int(tempCombo / 10);
		}

		while (seperatedScore.length < 3)
			seperatedScore.push(0);

		var daLoop:Int = 1;

		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'ui/num' + Std.int(i)));
			numScore.y = comboSpr.y;

			if (isPixel)
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				numScore.antialiasing = false;
			}
			else
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));

			numScore.updateHitbox();

			numScore.x = comboSpr.x - (43 * daLoop);
			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
	}

	public function cameraMovement(char:Character)
	{
		if (char == dad)
		{
			if (camFollow.x != dad.getMidpoint().x + 150)
			{
				camFollow.setPosition(dad.getMidpoint().x + (150 + dad.cameraOffsets.x), dad.getMidpoint().y - (100 + dad.cameraOffsets.y));

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				switch (dad.curCharacter)
				{
					case 'senpai' | 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				StageBackend.stage.cameraMovement(dad);
				HScript.runFunction('cameraMovement', [dad]);
			}
		}
		else if (char == boyfriend)
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			StageBackend.stage.cameraMovement(boyfriend);
			HScript.runFunction('cameraMovement', [boyfriend]);
		}

		if (SONG.song.formatToPath() == 'tutorial')
			tweenCam(char != boyfriend);
	}

	public function keyShitPlayer():Void
	{
		var canIdle:Bool = true;

		var holdArray:Array<Bool> = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.NOTE_UP, controls.NOTE_RIGHT];

		var pressArray:Array<Bool> = [
			controls.NOTE_LEFT_P,
			controls.NOTE_DOWN_P,
			controls.NOTE_UP_P,
			controls.NOTE_RIGHT_P
		];

		if (holdArray.contains(true) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
				{
					goodNoteHit(daNote);
					calculateAccuracy();
				}
			});
		}

		if (pressArray.contains(true) && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];
			var directionList:Array<Int> = [];
			var dumbNotes:Array<Note> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});

			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			calculateAccuracy();

			if (perfectMode)
				goodNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0)
			{
				for (shit in 0...pressArray.length)
				{
					if (pressArray[shit] && !directionList.contains(shit))
						noteMiss(possibleNotes[0]);
				}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
						goodNoteHit(coolNote);
				}
			}
			else if (!ChillSettings.get('ghostTapping', GAMEPLAY))
				ghostHit();
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) && canIdle))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		canIdle = true;

		for (i in 0...playerStrums.notes)
		{
			if (pressArray[i] && playerStrums.getNote(i).animation.curAnim.name != 'confirm')
				playerStrums.playNoteAnim(i, 'pressed');

			if (!holdArray[i])
				playerStrums.playNoteAnim(i, 'static');

			if (playerStrums.getNote(i).animation.curAnim.name != 'static')
				canIdle = false;
		}
	}

	public function keyShitOpponent():Void
	{
		var canIdle:Bool = true;

		var holdArray:Array<Bool> = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.NOTE_UP, controls.NOTE_RIGHT];

		var pressArray:Array<Bool> = [
			controls.NOTE_LEFT_P,
			controls.NOTE_DOWN_P,
			controls.NOTE_UP_P,
			controls.NOTE_RIGHT_P
		];

		if (holdArray.contains(true) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && !daNote.mustPress && holdArray[daNote.noteData])
				{
					opponentNoteHit(daNote);
					calculateAccuracy();
				}
			});
		}

		if (pressArray.contains(true) && generatedMusic)
		{
			dad.holdTimer = 0;

			var possibleNotes:Array<Note> = [];
			var directionList:Array<Int> = [];
			var dumbNotes:Array<Note> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && !daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});

			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			calculateAccuracy();

			if (perfectMode)
				opponentNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0)
			{
				for (shit in 0...pressArray.length)
				{
					if (pressArray[shit] && !directionList.contains(shit))
						noteMiss(possibleNotes[0]);
				}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
						opponentNoteHit(coolNote);
				}
			}
			else if (!ChillSettings.get('ghostTapping', GAMEPLAY))
				ghostHit();
		}

		if (dad.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) && canIdle))
		{
			if (dad.animation.curAnim.name.startsWith('sing') && !dad.animation.curAnim.name.endsWith('miss'))
			{
				dad.dance();
			}
		}

		for (i in 0...opponentStrums.notes)
		{
			if (pressArray[i] && opponentStrums.getNote(i).animation.curAnim.name != 'confirm')
				opponentStrums.playNoteAnim(i, 'pressed');

			if (!holdArray[i])
				opponentStrums.playNoteAnim(i, 'static');

			if (opponentStrums.getNote(i).animation.curAnim.name != 'static')
				canIdle = false;
		}
	}

	function missThing()
	{
		health -= 0.04;
		songMisses++;
		killCombo();

		if (!practiceMode)
		{
			songScore -= 10;
			possibleScore += 350;
		}

		vocals.volume = 0;
		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
	}

	private function ghostHit()
	{
		missThing();

		var direction:Int = 0;

		if (controls.NOTE_LEFT_P)
			direction = 0;

		if (controls.NOTE_DOWN_P)
			direction = 1;

		if (controls.NOTE_UP_P)
			direction = 2;

		if (controls.NOTE_RIGHT_P)
			direction = 3;

		boyfriend.playAnim(singArray[direction] + 'miss', true);
	}

	private function noteMiss(note:Note):Void
	{
		missThing();

		changeScoreText(true);
		boyfriend.playAnim(singArray[note.noteData] + 'miss', true);
	}

	public function goodNoteHit(note:Note):Void
	{
		changeScoreText();

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note.strumTime, note);
			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

			boyfriend.playAnim(singArray[note.noteData], true);

			playerStrums.playNoteAnim(note.noteData, 'confirm', true);

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			HScript.runFunction('goodNoteHit', [note]);
		}
	}

	public function opponentNoteHit(daNote:Note):Void
	{
		changeScoreText();

		if (!daNote.wasGoodHit)
		{
			var altAnim:String = "";

			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim)
					altAnim = '-alt';
			}

			if (!botplayDad)
			{
				if (daNote.noteData >= 0)
					health -= 0.023;
				else
					health -= 0.004;
			}

			if (daNote.altNote)
				altAnim = '-alt';

			dad.playAnim(singArray[Std.int(Math.abs(daNote.noteData))] + altAnim, true);

			dad.holdTimer = 0;

			if (SONG.needsVoices)
				vocals.volume = 1;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();

			daNote.wasGoodHit = true;

			opponentStrums.playNoteAnim(daNote.noteData, 'confirm', true);

			if (!daNote.isSustainNote && ChillSettings.get('noteSplashes', GAMEPLAY))
			{
				var noteSplashOpponent:NoteSplash = opponentSplashes.recycle(NoteSplash);
				noteSplashOpponent.setupNoteSplash(daNote.x, daNote.y, daNote.noteData, dad.isPixel);
				noteSplashOpponent.setColors(daNote.returnColors(daNote.noteData));
				opponentSplashes.add(noteSplashOpponent);
			}

			HScript.runFunction('opponentNoteHit', [daNote]);
		}
	}

	private function calculateAccuracy()
	{
		songAccuracy = FlxMath.roundDecimal((songScore / possibleScore) * 100, 2);
		if (Math.isNaN(songAccuracy))
			songAccuracy = 0;
	}

	override public function stepHit()
	{
		super.stepHit();

		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
			resyncVocals();

		StageBackend.stage.curStep = curStep;
		StageBackend.stage.stepHit();

		HScript.runFunction('stepHit');
	}

	override public function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
			notes.sort(sortNotes, FlxSort.DESCENDING);

		iconP1.bop();
		iconP2.bop();

		for (char in [dad, gf, boyfriend])
		{
			if (!char.animation.curAnim.name.startsWith("sing") && curBeat % char.bopDance == 0)
				char.dance();
		}

		StageBackend.stage.curBeat = curBeat;
		StageBackend.stage.beatHit();

		HScript.runFunction('beatHit');
	}

	override public function sectionHit()
	{
		super.sectionHit();

		if (SONG.notes[curSection] != null)
		{
			if (generatedMusic)
			{
				if (SONG.notes[curSection].mustHitSection)
					cameraMovement(boyfriend);
				else
					cameraMovement(dad);
			}

			if (SONG.notes[curSection].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[curSection].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			camZoom();
		}

		StageBackend.stage.curSection = curSection;
		StageBackend.stage.sectionHit();

		HScript.runFunction('sectionHit');
	}

	public function addCharacterToList(name:String, type:String)
	{
		switch (type)
		{
			case 'dad':
				dadGroup.forEach(function(chr:Character)
				{
					if (chr.curCharacter == name)
						return;
				});

				var yay:Character = new Character(0, 0, name, false);
				yay.alpha = 0.00001;
				dadGroup.add(yay);
			case 'gf':
				gfGroup.forEach(function(chr:Character)
				{
					if (chr.curCharacter == name)
						return;
				});

				var yay:Character = new Character(0, 0, name, false);
				yay.alpha = 0.00001;
				gfGroup.add(yay);
			default:
				boyfriendGroup.forEach(function(chr:Character)
				{
					if (chr.curCharacter == name)
						return;
				});

				var yay:Character = new Character(0, 0, name, true);
				yay.alpha = 0.00001;
				boyfriendGroup.add(yay);
		}
	}

	public function preloadEvent(name:String, value:String, strumTime:Float)
	{
		switch (name)
		{
			case 'Pico Animation':
				var daDirection:Null<Int> = 1;

				if (value == 'left')
					daDirection = 0;
				if (value == 'right')
					daDirection = 3;

				stages.objects.TankmenBG.animationNotes.push([strumTime, daDirection, 0]);

			case 'Change Character':
				var params:Array<String> = value.split(', ');
				addCharacterToList(params[1], params[0]);
		}
	}

	public function onEvent(name:String, value:String)
	{
		switch (name)
		{
			case 'Camera Zoom':
				var daZoomGame:Float = 0.015;
				var daZoomHUD:Float = 0.03;

				var params:Array<String> = value.split(', ');
				if (params[0] != null
					&& params[1] != null
					&& !Math.isNaN(Std.parseFloat(params[0]))
					&& !Math.isNaN(Std.parseFloat(params[1])))
				{
					daZoomGame = Std.parseFloat(params[0]);
					daZoomHUD = Std.parseFloat(params[1]);
				}

				camZoom(daZoomGame, daZoomHUD);

			case 'Hey!':
				if (value.contains('bf'))
					boyfriend.playAnim('hey', true);

				if (value.contains('gf'))
					gf.playAnim('cheer', true);

				if (value.contains('dad'))
					dad.playAnim('hey', true);

			case 'Pico Animation':
				if (value == 'left')
					gf.playAnim('shoot' + FlxG.random.int(1, 2), true);
				if (value == 'right')
					gf.playAnim('shoot' + FlxG.random.int(3, 4), true);

			case 'Lyrics':
				if (value != '')
				{
					lyricText.skip();

					if (value.startsWith(lyricText.text))
					{
						lyricText.prefix = lyricText.text;
						lyricText.resetText(value.substring(lyricText.text.length));
					}
					else
					{
						lyricText.prefix = '';
						lyricText.resetText(value);
					}

					lyricText.start(0.005, true);
				}
				else
				{
					lyricText.resetText(lyricText.text);
					lyricText.prefix = '';
					lyricText.skip();
					lyricText.erase(0.005, true);
				}

			case 'Change Character':
				var params:Array<String> = value.split(', ');
				updateHealthBar();

				switch (params[0])
				{
					case 'dad':
						dadGroup.forEach(function(char:Character)
						{
							if (dad == char)
							{
								char.alpha = 0.00001;
							}

							if (char.curCharacter == params[1])
							{
								char.alpha = 1;
								dad = char;
							}
						});

					case 'gf':
						gfGroup.forEach(function(char:Character)
						{
							if (gf == char)
							{
								char.alpha = 0.00001;
							}

							if (char.curCharacter == params[1])
							{
								char.alpha = 1;
								gf = char;
							}
						});

					default:
						boyfriendGroup.forEach(function(char:Character)
						{
							if (boyfriend == char)
							{
								char.alpha = 0.00001;
							}

							if (char.curCharacter == params[1])
							{
								char.alpha = 1;
								boyfriend = char;
							}
						});
				}
		}
	}

	#if DISCORD
	public function setRpcTimestamps(hasTimestamps:Bool = true)
	{
		if (hasTimestamps && FlxG.sound.music.playing)
		{
			DiscordRPC.startTimestamp = Date.now().getTime();
			DiscordRPC.endTimestamp = (Date.now().getTime() + FlxG.sound.music.length) - FlxG.sound.music.time;
		}
		else
		{
			DiscordRPC.startTimestamp = 0;
			DiscordRPC.endTimestamp = 0;
		}
	}
	#end
}

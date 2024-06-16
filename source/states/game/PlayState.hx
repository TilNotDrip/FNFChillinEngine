package states.game;

import openfl.events.KeyboardEvent;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.addons.text.FlxTypeText;
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
import hxvlc.flixel.FlxVideoSprite;
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
	public static var curSongIndex:Int = 0;
	public static var difficulty:String = 'Normal';

	public static var deathCounter:Int = 0;

	public static var practiceMode:Bool = false;
	public static var botplay:Bool = false;
	public static var botplayDad:Bool = true;

	//public var inst:FlxSound;
	public var vocals:Array<FlxSound> = [];
	public var vocalsFinished:Bool = false;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Character;

	public var dadGroup:FlxTypedSpriteGroup<Character>;
	public var gfGroup:FlxTypedSpriteGroup<Character>;
	public var boyfriendGroup:FlxTypedSpriteGroup<Character>;

	public var notes:FlxTypedGroup<Note>;

	public var strumLine:FlxSprite;

	public var cameraZoom:Float;

	public var camFollow:FlxObject;
	public var camFollowPos:FlxObject;

	public static var prevCamFollow:FlxObject;
	public var strumLineNotes:FlxTypedGroup<Strums>;

	public var playerStrums:Strums;
	public var playerSplashes:FlxTypedGroup<NoteSplash>;

	public var opponentStrums:Strums;
	public var opponentSplashes:FlxTypedGroup<NoteSplash>;

	public var holdCovers:FlxTypedGroup<NoteHoldCover>;

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

	public var camGAME:FlxCamera;
	public var camHUD:FlxCamera;
	public var camDIALOGUE:FlxCamera;

	public var dialogue:Array<String> = [];

	public var songTxt:FlxText;
	public var ratingCounterTxt:FlxText;
	public var healthOppTxt:FlxText;
	public var healthPlayerTxt:FlxText;
	public var scoreTxt:FlxText;

	public var accuracyNum:Float = 0;
	public var accuracyDen:Float = 0;
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
	public var rpcDetailsText:String = '';
	public var rpcStateText:String = '';
	#end

	public var seperateVocals:Bool = false;

	public static var game:PlayState;

	override public function create()
	{
		Paths.clearImageCache();

		if (SONG == null)
			SONG = Song.autoSelectJson('test', 'normal');

		game = this;

		for(event in SONG.events)
		{
			songEvents.push(event);
		}

		changeWindowName((!isStoryMode ? 'Freeplay - ' : 'Story Mode - ') + SONG.metadata.song + ' (' + difficulty + ')');

		#if DISCORD
		rpcDetailsText = SONG.metadata.song;
		rpcStateText = '[$difficulty] [Week: ${storyWeek?.name ?? 'null'}] ' + (!isStoryMode ? '[Freeplay]' : '[Story Mode]');
		#end

		#if DISCORD
		DiscordRPC.details = rpcDetailsText;
		DiscordRPC.state = rpcStateText;
		#end

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		seperateVocals = !Paths.exists('${SONG.metadata.song.formatToPath()}/Voices.${Paths.SOUND_EXT}', MUSIC, 'songs');

		FlxG.sound.cache(Paths.inst(SONG.metadata.song));

		if(seperateVocals)
		{
			FlxG.sound.cache(Paths.voices(SONG.metadata.song, SONG.metadata.player.split('-')[0].trim()));
			FlxG.sound.cache(Paths.voices(SONG.metadata.song, SONG.metadata.opponent.split('-')[0].trim()));
		}
		else
			FlxG.sound.cache(Paths.voices(SONG.metadata.song));

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

		Conductor.mapBPMChanges(SONG.metadata.bpmArray);

		switch (SONG.metadata.song.formatToPath())
		{
			case 'tutorial':
				dialogue = [":gf:Hey you're pretty cute.", 
				':gf:Use the arrow keys to keep up \nwith me singing.'];
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

		#if MOD_SUPPORT
		/*funnyScript = new HScript('scripts/PlayState', [
            'camGAME' => camGAME,
            'camHUD' => camHUD,
            'camDIALOGUE' => camDIALOGUE,
            'isPixel' => isPixel,
            'inCutscene' => inCutscene,
            'dialogue' => dialogue,
            'gf' => gf,
            'opponent' => dad,
            'player' => boyfriend,
            'dad' => dad,
            'boyfriend' => boyfriend,
            'camFollow' => camFollow,
            'game' => game
        ]);*/
		#end

		curStage = SONG.metadata.stage;

		switch (curStage)
		{
			case 'spooky': new Spooky();
			case 'philly': new Philly();
			case 'limo': new Limo();
			case 'mall': new Mall();
			case 'mallEvil': new MallEvil();
			case 'school': new School();
			case 'schoolEvil': new SchoolEvil();
			case 'tank': new Tank();
			case 'streets': new Streets();
			default: new FunkinStage();
		}

		add(StageBackend.stage);

		cameraZoom = StageBackend.stage.zoom;

		isPixel = StageBackend.stage.pixel;

		gfGroup = new FlxTypedSpriteGroup<Character>(400, 130);
		dadGroup = new FlxTypedSpriteGroup<Character>(100, 100);
		boyfriendGroup = new FlxTypedSpriteGroup<Character>(770, 450);

		addCharacterToList(SONG.metadata.gf, 'gf');
		addCharacterToList(SONG.metadata.opponent, 'dad');
		addCharacterToList(SONG.metadata.player, 'bf');

		add(gfGroup);
		add(dadGroup);
		add(boyfriendGroup);

		gf = new Character(0, 0, SONG.metadata.gf);
		// gfGroup.scrollFactor.set(0.95, 0.95); // for now

		dad = new Character(0, 0, SONG.metadata.opponent);

		if (dad.curCharacter == gf.curCharacter)
		{
			dadGroup.setPosition(gfGroup.x, gfGroup.y);
			gfGroup.visible = false;
			if (isStoryMode)
			{
				tweenCam(true);
			}
		}

		boyfriend = new Character(0, 0, SONG.metadata.player, true);

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

		generateStaticArrows('Opponent');
		generateStaticArrows('Player');

		if (ChillSettings.get('noteSplashes', GAMEPLAY))
		{
			playerSplashes = new FlxTypedGroup<NoteSplash>(51);
			opponentSplashes = new FlxTypedGroup<NoteSplash>(51);

			var noteSplashPlayer:NoteSplash = new NoteSplash(100, 100, 0); // I dont mean to add 2 of the same thing BUT it does double the speed for whatever reason
			playerSplashes.add(noteSplashPlayer);
			noteSplashPlayer.alpha = 0;

			var noteSplashOpponent:NoteSplash = new NoteSplash(100, 100, 0);
			opponentSplashes.add(noteSplashOpponent);
			noteSplashOpponent.alpha = 0;
	
			add(playerSplashes);
			add(opponentSplashes);
		}

		if(true) // change it when a note cover option exists
		{
			holdCovers = new FlxTypedGroup<NoteHoldCover>();

			for(i in 0...4)
			{
				var holdCover:NoteHoldCover = new NoteHoldCover();
				holdCovers.add(holdCover);
				holdCover.kill();
			}

			add(holdCovers);
		}

		generateSong();

		//camFollowPos = new FlxObject(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y - 100, 1, 1);
		camFollow = new FlxObject(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y - 100, 1, 1);

		if (prevCamFollow != null)
		{
			//camFollowPos.setPosition(prevCamFollow.x, prevCamFollow.y);
			camFollow.setPosition(prevCamFollow.x, prevCamFollow.y);
			prevCamFollow = null;
		}

		//add(camFollowPos);
		add(camFollow);

		//camGAME.follow(camFollowPos, LOCKON);
		camGAME.zoom = cameraZoom;
		//camGAME.focusOn(camFollowPos.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).makeGraphic(600, 20, FlxColor.BLACK);
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

		iconP1 = new HealthIcon(SONG.metadata.player, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.metadata.opponent, false);
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

		if(true)
		{
			holdCovers.cameras = [camHUD];
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

		add(StageBackend.stage.frontGrp);
		StageBackend.stage.addInFront = true;
		StageBackend.stage.createPost();

		/*#if MOD_SUPPORT
		funnyScript.runFunction('createPost');
		#end*/

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

		#if MOD_SUPPORT
		HScript.runForAllScripts(function(name:String, script:Dynamic) {
			if(script.endingVideo != null) script.endingVideo();
		});
		#end

		startCountdown();
		/*if (generatedMusic && SONG.notes[Conductor.curSection] != null)
		{
			if(SONG.notes[Conductor.curSection].mustHitSection)
				cameraMovement(boyfriend);
			else
				cameraMovement(dad);
		}*/
	}

	private var startTimer:FlxTimer = new FlxTimer();
	private var perfectMode:Bool = false;

	public function startCountdown()
	{
		seenCutscene = true;
		inCutscene = false;

		#if MOD_SUPPORT
		var stoppedFunction:Bool = false;

		HScript.runForAllScripts(function(name:String, script:Dynamic) {
			var daFunction:Dynamic = null;
			
			if(script.startCountdown != null) 
				daFunction = script.startCountdown();

			if(daFunction == HScript.StopFunction) stoppedFunction = true;
		});

		if(stoppedFunction)
			return;
		#end

		startedCountdown = true;

		playerStrums.tweenInNotes();
		opponentStrums.tweenInNotes();

		Conductor.songPosition = -(Conductor.crochet * 5);

		var swagCounter:Int = 0;

		startTimer.start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if(swagCounter > 3)
				return;

			if(!persistentUpdate)
				tmr.reset(Conductor.crochet / 1000);

			// cameraMovement((SONG.notes[0].mustHitSection) ? boyfriend : dad);

			for(char in [dad, gf, boyfriend])
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
			var introSndPaths:Array<String> = ["intro3" + altSuffix2, "intro2" + altSuffix2, "intro1" + altSuffix2, "introGo" + altSuffix2];

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

		#if debug
		canEnd = true;
		#end

		previousFrameTime = FlxG.game.ticks;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(SONG.metadata.song), 1, false);

		for(song in vocals) song.play();

		#if DISCORD
		setRpcTimestamps(true);
		#end

		FlxG.sound.music.onComplete = function() {
			endSong();
		};

		#if MOD_SUPPORT
		HScript.runForAllScripts(function(name:String, script:Dynamic) {
			if(script.startSong != null) script.startSong();
		});
		#end
	}

	public function generateSong():Void
	{

		if(seperateVocals)
		{
			for(char in [SONG.metadata.player, SONG.metadata.opponent])
			{
				var newChar:String = char.split('-')[0].trim();

				var musicData = new FlxSound().loadEmbedded(Paths.voices(SONG.metadata.song, newChar));
		
				musicData.onComplete = function()
				{
					vocalsFinished = true;
				};
		
				FlxG.sound.list.add(musicData);
				vocals.push(musicData);
			}
		}
		else
		{
			var musicData = new FlxSound().loadEmbedded(Paths.voices(SONG.metadata.song));
		
			musicData.onComplete = function()
			{
				vocalsFinished = true;
			};
		
			FlxG.sound.list.add(musicData);
			vocals.push(musicData);
		}

		notes = new FlxTypedGroup<Note>();
		add(notes);

		for (songNotes in SONG.notes)
		{
			var daStrumTime:Float = songNotes.time;
			var daNoteData:Int = songNotes.direction;

			var gottaHitNote:Bool = (songNotes.strum == 'Player');

			var oldNote:Note;
			if (members.length > 0)
				oldNote = notes.members[Std.int(notes.length - 1)];
			else
				oldNote = null;

			var swagNote:Note = new Note(daStrumTime, daNoteData, (gottaHitNote) ? boyfriend.isPixel : dad.isPixel, oldNote);
			swagNote.sustainLength = songNotes.length;
			swagNote.type = songNotes.type;
			swagNote.scrollFactor.set(0, 0);

			var susLength:Float = swagNote.sustainLength;

			susLength = susLength / Conductor.stepCrochet;
			notes.add(swagNote);

			for (susNote in 0...Math.floor(susLength))
			{
				oldNote = notes.members[Std.int(notes.length - 1)];

				var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, (gottaHitNote) ? boyfriend.isPixel : dad.isPixel, oldNote, true);
				sustainNote.scrollFactor.set();
				swagNote.type = songNotes.type;
				notes.add(sustainNote);

				sustainNote.mustPress = gottaHitNote;
				sustainNote.kill();
			}

			swagNote.mustPress = gottaHitNote;
			swagNote.kill();
		}

		for(event in songEvents)
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

	public function generateStaticArrows(strumID:String):Void
	{
		var arrows:Strums = new Strums(strumID, 0, strumLine.y, 4, (strumID == 'Player') ? boyfriend.isPixel : dad.isPixel);

		arrows.screenCenter(X);

		if(!ChillSettings.get('middleScroll', GAMEPLAY))
		{
			if(strumID == 'Player')
				arrows.x += (FlxG.width / 4);
			else
				arrows.x -= (FlxG.width / 4);
		}
		else if(strumID == 'Opponent')
			arrows.visible = false;

		arrows.updateHitbox();
		arrows.scrollFactor.set();

		var dummyNote:Note = new Note(0, 0, (strumID == 'Player') ? boyfriend.isPixel : dad.isPixel);

		dummyNote.mustPress = (strumID == 'Player');
		
		for(i in 0...arrows.notes)
			arrows.pressNote[i].rgb = dummyNote.returnColors(i);

		if(strumID == 'Player')
			playerStrums = arrows;
		else
			opponentStrums = arrows;

		strumLineNotes.add(arrows);
	}

	private function tweenCam(goingIn:Bool):Void
	{
		if(goingIn)
		{
			FlxTween.tween(camGAME, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onUpdate: function(twn:FlxTween) {
				cameraZoom = camGAME.zoom;
			}});
		}
		else
		{
			FlxTween.tween(camGAME, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onUpdate: function(twn:FlxTween) {
				cameraZoom = camGAME.zoom;
			}});
		}
	}

	override public function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				for(song in vocals) song.pause();
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

			
			for(icon in [iconP1, iconP2])
				if(icon.daTween != null && !icon.daTween.finished) icon.daTween.active = true;

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
		if(!paused)
			pauseGame();

		super.onFocusLost();
	}

	private function resyncVocals():Void
	{
		if (_exiting)
			return;

		for(song in vocals) 
			song.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;

		if (vocalsFinished)
			return;

		for(song in vocals) 
		{
			song.time = Conductor.songPosition;
			song.play();
		}
	}

	override public function destroy()
	{
		super.destroy();
	}

	public var paused:Bool = false;
	public var startedCountdown:Bool = false;
	public var canPause:Bool = false;
	#if debug
	public var canEnd:Bool = false;
	#end

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
			Conductor.songPosition = FlxG.sound.music.time;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				/*if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}*/
			}
		}

		//StageBackend.stage.update(elapsed);

		super.update(elapsed);

		lyricText.updateHitbox();
		lyricText.screenCenter(X);
		lyricText.y = healthBarBG.y - ((100 - lyricText.height) * ((ChillSettings.get('downScroll', GAMEPLAY)) ? -1 : 1));

		if (ChillSettings.get('hudType', GAMEPLAY) == 'Score / Rating Counter / Health')
			songTxt.text = '[' + FlxStringUtil.formatTime(FlxG.sound.music.time / 1000, false) + ' / ' + FlxStringUtil.formatTime(FlxG.sound.music.length / 1000, false) + '] [' + FlxMath.roundDecimal((FlxG.sound.music.time / FlxG.sound.music.length) * 100, 2) + '%] ' + SONG.metadata.song + ' - ' + difficulty;

		if (controls.PAUSE)
			pauseGame();

		if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
			updateHealthBar();
		}

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

		if (ChillSettings.get('devMode', OTHER) && !isEnding)
		{
			if (FlxG.keys.justPressed.SEVEN)
				FlxG.sound.play(Paths.sound('cancelMenu')); // sorry fellas!
				//FlxG.switchState(new ChartingState());

			if (FlxG.keys.justPressed.EIGHT)
			{
				if (FlxG.keys.pressed.SHIFT)
					if (FlxG.keys.pressed.CONTROL)
						FlxG.switchState(new AnimationDebug(SONG.metadata.gf, false));
					else 
						FlxG.switchState(new AnimationDebug(SONG.metadata.player, true));
				else
					FlxG.switchState(new AnimationDebug(SONG.metadata.opponent, false));
			}

			if (FlxG.keys.justPressed.ONE && canEnd)
			{
				FlxG.sound.music.stop();
				for(song in vocals) song.stop();
				endSong();
			}

			if (FlxG.keys.justPressed.PAGEUP)
				changeSection(-1);
			if (FlxG.keys.justPressed.PAGEDOWN)
				changeSection(1);

			if (FlxG.keys.justPressed.L)
				botplayDad = !botplayDad;
		}

		if(!inCutscene)
		{
			camGAME.zoom = FlxMath.lerp(cameraZoom, camGAME.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("sectionShit", Conductor.curSection);
		FlxG.watch.addQuick("beatShit", Conductor.curBeat);
		FlxG.watch.addQuick("stepShit", Conductor.curStep);

		if (SONG.metadata.song.formatToPath() == 'fresh')
		{
			switch (Conductor.curBeat)
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

		if (SONG.metadata.song.formatToPath() == 'bopeebo')
		{
			switch (Conductor.curBeat)
			{
				case 128, 129, 130:
					for(song in vocals) song.volume = 0;
			}
		}

		if (!inCutscene && !_exiting)
		{
			if (controls.RESET)
				die();

			#if CAN_CHEAT
			if (controls.CHEAT)
			{
				health += 1;
				trace("User is cheating!");
			}
			#end

			if (((health <= minHealth && !botplay) || (health >= maxHealth && !botplayDad)) && !practiceMode)
			{
				if((botplay && botplayDad) || (!botplay && !botplayDad)) return;

				die();
			}
		}

		for(event in songEvents)
		{
			if(Conductor.songPosition >= event.strumTime && !eventsCalled.contains(event))
			{
				onEvent(event.name, event.value);
				eventsCalled.push(event);
			}
		}

		addPressesToQueue();
		processInputQueue();
		handleHoldNotes();

		if (!inCutscene && !botplayDad)
			keyShitOpponent();

		if (!inCutscene)
		{
			if(botplayDad)
			{
				for(i in 0...opponentStrums.notes)
				{
					if(opponentStrums.getNote(i).animation.finished && opponentStrums.getNote(i).animation.name == 'confirm') 
						opponentStrums.playNoteAnim(i, 'static');
				}
			}

			if(botplay)
			{
				for(i in 0...playerStrums.notes)
				{
					if(playerStrums.getNote(i).animation.finished && playerStrums.getNote(i).animation.name == 'confirm') 
						playerStrums.playNoteAnim(i, 'static');
				}
			}
		}
	}

	override public function draw()
	{
		super.draw();

		if(!generatedMusic)
			return;

		notes.forEachDead(function(daNote:Note) {
			if(daNote.strumTime - Conductor.songPosition < 1800 / SONG.metadata.speed && !daNote.wasHit)
				daNote.revive();
		});

		notes.forEachAlive(function(daNote:Note)
		{
			var whatStrum:Strums = (daNote.mustPress) ? playerStrums : opponentStrums;

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

			daNote.visible = whatStrum.visible;

			daNote.mayHit = (daNote.strumTime >= Conductor.songPosition - Scoring.PBOT1_MISS_THRESHOLD && daNote.strumTime <= Conductor.songPosition + Scoring.PBOT1_MISS_THRESHOLD);

			var strumLineMid = whatStrum.y + Note.swagWidth / 2;

			if (ChillSettings.get('downScroll', GAMEPLAY))
			{
				daNote.y = (whatStrum.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.metadata.speed, 2)));

				if (daNote.isSustainNote)
				{
					if (daNote.animation.curAnim.name.endsWith("end") && daNote.prevNote != null)
						daNote.y += daNote.prevNote.height;
					else
						daNote.y += daNote.height / 2;

					/*if ((daNote.wasHit || (daNote.prevNote.wasHit && !daNote.mayHit))
						&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= strumLineMid)
					{
						var swagRect:FlxRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);

						swagRect.height = (strumLineMid - daNote.y) / daNote.scale.y;
						swagRect.y = daNote.frameHeight - swagRect.height;
						daNote.clipRect = swagRect;
					}*/
				}
			}
			else
			{
				daNote.y = (whatStrum.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.metadata.speed, 2)));

				/*if (daNote.isSustainNote
					&& (daNote.wasHit || (daNote.prevNote.wasHit && !daNote.mayHit))
					&& daNote.y + daNote.offset.y * daNote.scale.y <= strumLineMid)
				{
					var swagRect:FlxRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);

					swagRect.y = (strumLineMid - daNote.y) / daNote.scale.y;
					swagRect.height -= swagRect.y;
					daNote.clipRect = swagRect;
				}*/
			}

			daNote.x = whatStrum.x + (Note.swagWidth * daNote.noteData);
			if(daNote.isSustainNote) daNote.x += ((Note.swagWidth - daNote.width) / 2);

			if (!daNote.mustPress && daNote.strumTime <= Conductor.songPosition && botplayDad)
				opponentNoteHit(daNote);

			if (daNote.mustPress && daNote.strumTime <= Conductor.songPosition && botplay)
				goodNoteHit(daNote);

			if (!daNote.isSustainNote && daNote.strumTime + Scoring.PBOT1_MISS_THRESHOLD <= Conductor.songPosition && !daNote.wasHit)
			{
				if(daNote.mustPress)
				{
					noteMiss(daNote);
					for(song in vocals) song.volume = 0;
					killCombo();
				}

				daNote.wasHit = true;
				daNote.kill();
			}
		});
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
		if(canPause && !isEnding)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;	

			for(icon in [iconP1, iconP2])
				if(icon.daTween != null) icon.daTween.active = false;

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

	public function die()
	{
		deathCounter += 1;

		FlxG.sound.music.stop();
		for(song in vocals) song.stop();

		if (FlxG.random.bool(0.1))
			FlxG.switchState(new GameOverState(boyfriend.deathCharacter));
		else
		{
			persistentUpdate = false;
			persistentDraw = false;

			paused = true;

			openSubState(new GameOverSubstate(boyfriendGroup.x, boyfriendGroup.y, boyfriend.deathCharacter, camGAME));
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

	#if debug
	private function changeSection(sec:Int):Void
	{
		FlxG.sound.music.pause();
		for(song in vocals) song.pause();

		var backwards:Bool = false;

		backwards = sec <= 0;

		for (i in 0...Std.int(Math.abs(sec)))
		{
			if(sec <= 0)
				Conductor.songPosition -= (Conductor.stepCrochet * Conductor.sectionSteps);
			else
				Conductor.songPosition += (Conductor.stepCrochet * Conductor.sectionSteps);
		}

		resyncVocals();

		#if DISCORD
		setRpcTimestamps(true);
		#end
	}
	#end


	public function restartSong()
	{
		startingSong = true;

		startCountdown();

		notes.forEachAlive(function(note:Note) {
			note.wasHit = false;
			note.kill();
			note.mayHit = false;
		});

		notes.forEachDead(function(note:Note) {
			note.wasHit = false;
			note.mayHit = false;
		});

		songScore = 0;
		songMisses = 0;
		songAccuracy = 0;
		accuracyNum = 0;
		accuracyDen = 0;
	}

	public var endScreen:Bool = true;

	public function endSong()
	{
		#if MOD_SUPPORT
		var stoppedFunction:Bool = false;

		HScript.runForAllScripts(function(name:String, script:Dynamic) {
			var daFunction:Dynamic = null;
			
			if(script.startCountdown != null) 
				daFunction = script.startCountdown();

			if(daFunction == HScript.StopFunction) stoppedFunction = true;
		});

		if(stoppedFunction)
			return;
		#end

		FlxG.sound.music.volume = 0;
		for(song in vocals) song.volume = 0;

		seenEndCutscene = false;
		seenCutscene = false;
		deathCounter = 0;

		isEnding = true;

		if(endScreen)
		{
			openSubState(new EndSubState());
			endScreen = false;
			return;
		}

		if (!practiceMode && !botplay)
			Highscore.saveScore(SONG.metadata.song, songScore, difficulty);

		if (isStoryMode)
			finishSongStory();
		else
			FlxG.switchState(new FreeplayState());
	}

    public function finishSongStory()
    {
        campaignScore += songScore;

		curSongIndex++;
		
		while(storyWeek.songs.length > curSongIndex && !storyWeek.songs[curSongIndex].difficulties.contains(difficulty))
			curSongIndex++;

        if (storyWeek.songs.length <= curSongIndex)
        {
            FlxG.sound.playMusic(Paths.music('freakyMenu'));

            transIn = FlxTransitionableState.defaultTransIn;
            transOut = FlxTransitionableState.defaultTransOut;

			curSongIndex = 0;

            FlxG.switchState(new StoryMenuState());

            storyWeek.lockMetadata.locked = false;

            Highscore.saveWeekScore(storyWeek.name, campaignScore, difficulty);
        }
        else
        {
            FlxTransitionableState.skipNextTransIn = true;
            FlxTransitionableState.skipNextTransOut = true;

            FlxG.sound.music.stop();
            for(song in vocals) song.stop();

            prevCamFollow = camFollow;
			SONG = Song.autoSelectJson(difficulty.formatToPath(), storyWeek.songs[curSongIndex].song);
			songEvents = SongEvent.loadFromJson(storyWeek.songs[curSongIndex].song);

			if (songEvents == null)
				songEvents = [];
			
			LoadingState.loadAndSwitchState(new PlayState());
        }
    }

	private function set_inCutscene(inCutscene:Bool)
	{
		if (inCutscene)
		{
			camHUD.visible = false;
			canPause = false;

			#if debug
			canEnd = false;
			#end
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
			new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer) {
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
		iconP1.changeIcon(boyfriend.curCharacter);
		iconP2.changeIcon(dad.curCharacter);

		healthBar.createFilledBar(iconP2.curHealthBarColor, iconP1.curHealthBarColor);
		healthBar.updateFilledBar();

		healthOppTxt.color = iconP2.curHealthBarColor;
		healthPlayerTxt.color = iconP1.curHealthBarColor;

		#if DISCORD
		DiscordRPC.smallImageKey = 'icon-${iconP2.char}';
		DiscordRPC.smallImageText = dad.curCharacter;
		#end
	}

	public function popUpScore(strumtime:Float, daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		for(song in vocals) song.volume = 1;

		var rating:FlxSprite = new FlxSprite();

		var score:Int = Scoring.scoreNote(noteDiff);
		var daRating:String = Scoring.judgeNote(noteDiff);

		accuracyNum += (1 - Math.min((noteDiff / 1000) * (1000 / Scoring.PBOT1_MISS_THRESHOLD), 1));
		accuracyDen++;

		calculateAccuracy();

		if (daRating == 'sick' && ChillSettings.get('noteSplashes', GAMEPLAY))
		{
			var noteSplashPlayer:NoteSplash = playerSplashes.recycle(NoteSplash);
			noteSplashPlayer.setupNoteSplash(daNote.x, daNote.y, daNote.noteData, boyfriend.isPixel);
			noteSplashPlayer.setColors(daNote.returnColors(daNote.noteData));
			playerSplashes.add(noteSplashPlayer);
		}

		songScore += score;

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
		if(!char.isPlayer)
		{
			
			camFollow.setPosition(char.getMidpoint().x + (150 + char.cameraOffsets.x), char.getMidpoint().y - (100 + char.cameraOffsets.y));

			if (char.curCharacter == 'mom')
				for(song in vocals) song.volume = 1;

			switch (char.curCharacter)
			{
				case 'senpai' | 'senpai-angry':
					camFollow.y = char.getMidpoint().y - 430;
					camFollow.x = char.getMidpoint().x - 100;
			}
		}
		else
		{
			camFollow.setPosition(char.getMidpoint().x + (-100 + char.cameraOffsets.x), char.getMidpoint().y + (-100 + char.cameraOffsets.y));
		}

		StageBackend.stage.cameraMovement(char);

		#if MOD_SUPPORT
		HScript.runForAllScripts(function(name:String, script:Dynamic) {
			if(script.cameraMovement != null) script.cameraMovement(char);
		});
		#end

		if (SONG.metadata.song.formatToPath() == 'tutorial')
			tweenCam(char != boyfriend);
	}
	

	var inputPressQueue:Array<Int> = [];
	var inputHoldQueue:Array<Int> = [];
	var inputReleaseQueue:Array<Int> = [];
	function processInputQueue():Void
  	{
    	if (inputPressQueue.length + inputHoldQueue.length + inputReleaseQueue.length == 0) return;

    	// Ignore inputs during cutscenes.
    	if (inCutscene || botplay)
    	{
    		inputPressQueue = [];
			inputHoldQueue = [];
      		inputReleaseQueue = [];
      		return;
    	}

		boyfriend.allowedToIdle = !(inputHoldQueue.length < 0 && inputPressQueue.length == 0);

    	// Generate a list of notes within range.
    	var notesInRange:Array<Note> = [];
		var holdNotesInRange:Array<Note> = [];

		notes.forEachAlive(function(note:Note) {
			if(note.mustPress && note.mayHit && !note.wasHit) 
			{
				if(!note.isSustainNote)
					notesInRange.push(note);
				else
					holdNotesInRange.push(note);
			}
				
		});

    	// If there are notes in range, pressing a key will cause a ghost miss.

    	var notesByDirection:Array<Array<Note>> = [[], [], [], []];
		var holdNotesByDirection:Array<Array<Note>> = [[], [], [], []];

    	for (note in notesInRange)
      		notesByDirection[note.noteData].push(note);

		for (note in holdNotesInRange)
			holdNotesByDirection[note.noteData].push(note);

    	while (inputPressQueue.length > 0)
    	{
      		var input:Int = inputPressQueue.shift();

      		//playerStrumline.pressKey(input.noteDirection);

      		var notesInDirection:Array<Note> = notesByDirection[input];

      		if (!ChillSettings.get('ghostTapping', GAMEPLAY) && notesInDirection.length == 0)
      		{
        		// Pressed a wrong key with no notes nearby.
        		// Perform a ghost miss (anti-spam).
        		ghostHit(input);
				
        		// Play the strumline animation.
        		playerStrums.playNoteAnim(input, 'pressed', true);
      		}
      		else if (!ChillSettings.get('ghostTapping', GAMEPLAY) && (holdNotesInRange.length + notesInRange.length > 0) && notesInDirection.length == 0)
      		{
        		// Pressed a wrong key with no notes nearby AND with notes in a different direction available.
        		// Perform a ghost miss (anti-spam).
        		ghostHit(input);

        		// Play the strumline animation.
        		playerStrums.playNoteAnim(input, 'pressed', true);
      		}
      		else if (notesInDirection.length > 0)
      		{
        		// Choose the first note, deprioritizing low priority notes.
        		var targetNote:Null<Note> = notesInDirection.find((note) -> !note.lowPriority);
        		if (targetNote == null) targetNote = notesInDirection[0];
        		if (targetNote == null) continue;

        		// Judge and hit the note.
        		// trace('Hit note! ${targetNote.noteData}');
        		goodNoteHit(targetNote);

        		notesInDirection.remove(targetNote);
      		}
      		else
      		{
      			// Play the strumline animation.
				playerStrums.playNoteAnim(input, 'pressed', true);
      		}
    	}

		while (inputHoldQueue.length > 0)
		{
			var input:Int = inputHoldQueue.shift();

			var holdNotesInDirection:Array<Note> = holdNotesByDirection[input];

			if (holdNotesInDirection.length > 0)
      		{
        		// Choose the first note, deprioritizing low priority notes.
        		var targetNote:Null<Note> = holdNotesInDirection.find((note) -> !note.lowPriority);
        		if (targetNote == null) targetNote = holdNotesInDirection[0];
        		if (targetNote == null) continue;

        		// Judge and hit the note.
        		//trace('Hit hold note! ${targetNote.noteData}');
        		goodNoteHit(targetNote);

        		holdNotesInDirection.remove(targetNote);
      		}
		}

    	while (inputReleaseQueue.length > 0)
    	{
      		var input:Int = inputReleaseQueue.shift();

      		// Play the strumline animation.
      		playerStrums.playNoteAnim(input, 'static', true);

			if(holdCovers.members[input].alive)
				holdCovers.members[input].playEnd();
    	}
  	}

	public function addPressesToQueue()
	{
		var pressArray:Array<Bool> = [
			controls.NOTE_LEFT_P,
			controls.NOTE_DOWN_P,
			controls.NOTE_UP_P,
			controls.NOTE_RIGHT_P
		];

		var releaseArray:Array<Bool> = [
			controls.NOTE_LEFT_R,
			controls.NOTE_DOWN_R,
			controls.NOTE_UP_R,
			controls.NOTE_RIGHT_R
		];


		for(i in 0...4)
		{
			if(pressArray[i])
				inputPressQueue.push(i);

			if(releaseArray[i])
				inputReleaseQueue.push(i);
		}
	}

	public function handleHoldNotes()
	{
		var holdArray:Array<Bool> = [
			controls.NOTE_LEFT,
			controls.NOTE_DOWN,
			controls.NOTE_UP,
			controls.NOTE_RIGHT
		];

		if(!holdArray.contains(true))
			return;

		var byDirection:Array<Array<Note>> = [[], [], [], []];

		notes.forEachAlive(function(note:Note) {
			if(note.mustPress && note.mayHit && note.isSustainNote) 
				byDirection[note.noteData].push(note);
		});

		var strumLineMid:Float = playerStrums.y + (playerStrums.height / 2);
		
		for(i in 0...byDirection.length)
		{
			if(!holdCovers.members[i].alive && byDirection[i][0] != null)
			{
				holdCovers.members[i].setColors(byDirection[i][0].returnColors(byDirection[i][0].noteData));
				holdCovers.members[i].revive();
				holdCovers.members[i].setPosition(playerStrums.x + (Note.swagWidth * byDirection[i][0].noteData) - 20, playerStrums.y - 10);
				holdCovers.members[i].playStart();
			}
			
			while (byDirection[i].length > 0)
			{
				var daNote:Null<Note> = byDirection[i].find((note) -> !note.lowPriority);
				if (daNote == null) daNote = byDirection[i][0];
        		if (daNote == null) continue;

				if(!daNote.wasHit)
					daNote.wasHit = true;

				if ((daNote.wasHit || (daNote.prevNote.wasHit && !daNote.mayHit))
					&& daNote.y + daNote.offset.y * daNote.scale.y <= strumLineMid)
				{
					var swagRect:FlxRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);

					swagRect.y = (strumLineMid - daNote.y) / daNote.scale.y;
					swagRect.height -= swagRect.y;
					daNote.clipRect = swagRect;
				}

				if (daNote.wasHit)
				{
					if ((!ChillSettings.get('downScroll', GAMEPLAY) && daNote.y < -daNote.height)
						|| (ChillSettings.get('downScroll', GAMEPLAY) && daNote.y > FlxG.height))
					{
						if(daNote.animation.curAnim.name.endsWith("end"))
							holdCovers.members[i].playEnd();

						daNote.kill();
					}
				}

				byDirection[i].remove(daNote);
			}

		}
	}

	public function keyShitOpponent():Void
	{
		/*var holdArray:Array<Bool> = [
			controls.NOTE_LEFT,
			controls.NOTE_DOWN,
			controls.NOTE_UP,
			controls.NOTE_RIGHT
		];

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
				if (daNote.isSustainNote && daNote.canBeHit && !daNote.mustPress && holdArray[daNote.noteData]) {
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
				ghostHit(holdArray.indexOf(true));
		}

		dad.allowedToIdle = !holdArray.contains(true);

		for(i in 0...opponentStrums.notes)
		{
			if (pressArray[i] && opponentStrums.getNote(i).animation.curAnim.name != 'confirm')
				opponentStrums.playNoteAnim(i, 'pressed');

			if (!holdArray[i])
				opponentStrums.playNoteAnim(i, 'static');
		}*/
	}

	function missThing()
	{
		health -= 0.04;
		songMisses++;
		killCombo();

		if(Modifiers.hasModifierOn('instakill'))
			die();

		if (!practiceMode)
		{
			songScore -= 10;
		}

		accuracyNum++;
		calculateAccuracy();


		for(song in vocals) song.volume = 0;
		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
	}

	private function ghostHit(direction:Int)
	{
		missThing();

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

		if (!note.wasHit)
		{
			note.wasHit = true;

			for(song in vocals) song.volume = 1;

			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note.strumTime, note);

				if (note.noteData >= 0)
					health += 0.023;
				else
					health += 0.004;

				var altAnim:String = "";

				if (note.suffix != '')
					altAnim = '-' + note.suffix;
	
				boyfriend.playAnim(singArray[note.noteData] + altAnim, true);

				playerStrums.pressNote[note.noteData].rgb = note.returnColors(note.noteData);
	
				note.kill();
			}
			
			boyfriend.holdTimer = 0;

			if(playerStrums.getNote(note.noteData).animation.curAnim.name != 'confirm')
				playerStrums.playNoteAnim(note.noteData, 'confirm', true);

			#if MOD_SUPPORT
			HScript.runForAllScripts(function(name:String, script:Dynamic) {
				if(script.goodNoteHit != null) script.goodNoteHit(note);
			});
			#end
		}
	}

	public function opponentNoteHit(daNote:Note):Void
	{
		changeScoreText();

		if (!daNote.wasHit)
		{
			daNote.wasHit = true;

			if(!daNote.isSustainNote)
			{
				var altAnim:String = "";

				if (daNote.suffix != '')
					altAnim = '-' + daNote.suffix;

				if (!botplayDad)
				{
					if (daNote.noteData >= 0)
						health -= 0.023;
					else
						health -= 0.004;
				}

				dad.playAnim(singArray[daNote.noteData] + altAnim, true);

				daNote.kill();

				for(song in vocals) song.volume = 1;

				if(!opponentStrums.visible) 
					return;

				if (ChillSettings.get('noteSplashes', GAMEPLAY))
				{
					var noteSplashOpponent:NoteSplash = opponentSplashes.recycle(NoteSplash);
					noteSplashOpponent.setupNoteSplash(daNote.x, daNote.y, daNote.noteData, dad.isPixel);
					noteSplashOpponent.setColors(daNote.returnColors(daNote.noteData));
					opponentSplashes.add(noteSplashOpponent);
				}

				opponentStrums.pressNote[daNote.noteData].rgb = daNote.returnColors(daNote.noteData);
			}

			if(opponentStrums.getNote(daNote.noteData).animation.curAnim.name != 'confirm')
				opponentStrums.playNoteAnim(daNote.noteData, 'confirm');

			dad.holdTimer = 0;

			#if MOD_SUPPORT
			HScript.runForAllScripts(function(name:String, script:Dynamic) {
				if(script.opponentNoteHit != null) script.opponentNoteHit(daNote);
			});
			#end
		}
	}

	private function calculateAccuracy()
	{
		songAccuracy = FlxMath.roundDecimal((accuracyNum / accuracyDen) * 100, 2);
		if(Math.isNaN(songAccuracy)) songAccuracy = 0;
	}

	override public function stepHit()
	{
		super.stepHit();

		var didIt:Bool = false;
		for(song in vocals) 
		{
			if (!didIt && Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20 || (Math.abs(song.time - (Conductor.songPosition - Conductor.offset)) > 20))
			{
				resyncVocals();	
				didIt = true;
			}	
		}
		StageBackend.stage.stepHit();

		/*#if MOD_SUPPORT
		funnyScript.runFunction('stepHit');
		#end*/
	}

	override public function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
			notes.sort(sortNotes, FlxSort.DESCENDING);

		iconP1.bop();
		iconP2.bop();

		StageBackend.stage.beatHit();

		/*#if MOD_SUPPORT
		funnyScript.runFunction('beatHit');
		#end*/
	}

	override public function sectionHit()
	{
		super.sectionHit();

		if (SONG.notes[Conductor.curSection] != null)
		{
			if (generatedMusic)
			{
				/*if(SONG.notes[Conductor.curSection].mustHitSection)
					cameraMovement(boyfriend);
				else
					cameraMovement(dad);*/
			}

			camZoom();
		}

		StageBackend.stage.sectionHit();

		/*#if MOD_SUPPORT
		funnyScript.runFunction('sectionHit');
		#end*/
	}

	public function addCharacterToList(name:String, type:String)
	{
		switch(type)
		{
			case 'dad':
				dadGroup.forEach(function(chr:Character) 
				{
					if(chr.curCharacter == name)
						return;
				});

				var yay:Character = new Character(0, 0, name, false);
				yay.alpha = 0.00001;
				dadGroup.add(yay);
			case 'gf':
				gfGroup.forEach(function(chr:Character) 
				{
					if(chr.curCharacter == name)
						return;
				});

				var yay:Character = new Character(0, 0, name, false);
				yay.alpha = 0.00001;
				gfGroup.add(yay);
			default:
				boyfriendGroup.forEach(function(chr:Character) 
				{
					if(chr.curCharacter == name)
						return;
				});
				
				var yay:Character = new Character(0, 0, name, true);
				yay.alpha = 0.00001;
				boyfriendGroup.add(yay);
		}
	}

	public function preloadEvent(name:String, value:String, strumTime:Float)
	{
		switch(name)
		{
			case 'Pico Animation':
				var daDirection:Null<Int> = 1;

				if(value == 'left') 
					daDirection = 0;
				if(value == 'right')
					daDirection = 3;

				stages.objects.TankmenBG.animationNotes.push([strumTime, daDirection, 0]);

			case 'Change Character':
				var params:Array<String> = value.split(', ');
				addCharacterToList(params[1], params[0]);
		}
	}

	public function onEvent(name:String, value:String)
	{
		switch(name)
		{
			case 'Camera Zoom':
				var daZoomGame:Float = 0.015;
				var daZoomHUD:Float = 0.03;

				var params:Array<String> = value.split(', ');
				if(params[0] != null && params[1] != null && !Math.isNaN(Std.parseFloat(params[0])) && !Math.isNaN(Std.parseFloat(params[1]))) 
				{
					daZoomGame = Std.parseFloat(params[0]);
					daZoomHUD = Std.parseFloat(params[1]);
				}

				camZoom(daZoomGame, daZoomHUD);

			case 'Hey!':
				if(value.contains('bf'))
					boyfriend.playAnim('hey', true);

				if(value.contains('gf'))
					gf.playAnim('cheer', true);

				if(value.contains('dad'))
					dad.playAnim('hey', true);

			case 'Pico Animation':
				if(value == 'left')
					gf.playAnim('shoot' + FlxG.random.int(1, 2), true);
				if(value == 'right')
					gf.playAnim('shoot' + FlxG.random.int(3, 4), true);

			case 'Lyrics':
				if(value != '')
				{
					lyricText.skip();

					if(value.startsWith(lyricText.text))
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

				switch(params[0])
				{
					case 'dad':
						dadGroup.forEach(function(char:Character) {
							if(dad == char)
							{
								char.alpha = 0.00001;
							}

							if(char.curCharacter == params[1])
							{
								char.alpha = 1;
								dad = char;
							}
						});

					case 'gf':
						gfGroup.forEach(function(char:Character) {
							if(gf == char)
							{
								char.alpha = 0.00001;
							}

							if(char.curCharacter == params[1])
							{
								char.alpha = 1;
								gf = char;
							}
						});

					default:
						boyfriendGroup.forEach(function(char:Character) {
							if(boyfriend == char)
							{
								char.alpha = 0.00001;
							}

							if(char.curCharacter == params[1])
							{
								char.alpha = 1;
								boyfriend = char;
							}
						});

					updateHealthBar();
					
				}

			case 'Focus Camera':
				var params:Array<String> = value.split(', ');
				var paramsUpdate:Int = 0;
				switch(params[paramsUpdate])
				{
					case 'bf':
						cameraMovement(boyfriend);
					
					case 'dad':
						cameraMovement(dad);

					case 'gf':
						cameraMovement(gf);

					default:
						camFollow.setPosition(0, 0);
						paramsUpdate = -1;

				}

				paramsUpdate++;

				var tweenEase:String = params[paramsUpdate+1] ?? 'lerp';
				var tweenTime:Float = Std.parseFloat(params[paramsUpdate+2]);

				if(Math.isNaN(tweenTime))
					tweenTime = 0.26;

				if(value.contains('[') && value.contains(']'))
				{
					var cordy:String = value.substring(value.indexOf('[') + 1, value.indexOf(']'));
					var daCoords:Array<String> = cordy.split(', ');
					camFollow.x += Std.parseFloat(daCoords[0]);
					camFollow.y += Std.parseFloat(daCoords[1]);

					for(param in params)
					{
						if(cordy.contains(param))
							params.remove(param);
					}
				}

				runFollowTween(tweenEase, tweenTime);

			case 'Zoom Camera':
				cameraZoom = Std.parseFloat(value);
		}

		trace('New Event! Name: ' + name + ', Value: ' + value);
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

	function runFollowTween(?ease:String = 'lerp', ?time:Float = 0.26) 
	{
		var followPos:FlxPoint = camFollow.getPosition() - FlxPoint.weak(camGAME.width * 0.5, camGAME.height * 0.5);

		if(ease != 'lerp')
			FlxTween.tween(camGAME.scroll, {x: followPos.x, y: followPos.y}, time, {ease: Reflect.field(FlxEase, ease) ?? FlxEase.linear});
		else
		{
			new LerpTween(function(value:Float) {
				camGAME.scroll.x = value;
			}, camGAME.scroll.x, followPos.x); 
	
			new LerpTween(function(value:Float) {
				camGAME.scroll.y = value;
			}, camGAME.scroll.y, followPos.y); 
		}
	}
}
package states.game;

import addons.Section.SwagSection;
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

#if cpp
import hxcodec.flixel.FlxVideo;
#end

import objects.game.*;

import stages.StageBackend;
import stages.bgs.*;

import states.tools.*;

import substates.*;

class PlayState extends BaseGame
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Week = null;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:String = 'Normal';

	public static var deathCounter:Int = 0;

	public static var practiceMode:Bool = false;
	public static var botplay:Bool = false;

	//public var inst:FlxSound;
	public var vocals:FlxSound;
	public var vocalsFinished:Bool = false;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Character;

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

	public var gfSpeed:Int = 1;

	public var health:Float = 1;
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
	public var isEnding:Bool = false;

	#if discord_rpc
	public var iconRPC:String = "";
	public var songLength:Float = 0;
	public var detailsText:String = "";
	public var detailsPausedText:String = "";
	#end

	public var camPos:FlxPoint;

	public var singArray:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public static var game:PlayState;

	override public function create()
	{
		game = this;

		changeWindowName((!isStoryMode ? 'Freeplay - ' : 'Story Mode - ') + SONG.song + ' (' + storyDifficulty + ')');

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
			case 'dadbattle':
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

		#if discord_rpc
		initDiscord();
		#end

		curStage = SONG.stage;

		switch (curStage)
		{
			case 'stage': new FunkinStage();
			case 'spooky': new Spooky();
			case 'philly': new Philly();
			case 'limo': new Limo();
			case 'mall': new Mall();
			case 'mallEvil': new MallEvil();
			case 'school': new School();
			case 'schoolEvil': new SchoolEvil();
			case 'tank': new Tank();
		}

		isPixel = StageBackend.stage.pixel;

		gf = new Character(400, 130, SONG.player3);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai' | 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tankman':
				dad.y += 180;
		}

		if (SONG.player2 == SONG.player3)
		{
			dad.setPosition(gf.x, gf.y);
			gf.visible = false;
			if (isStoryMode)
			{
				camPos.x += 600;
				tweenCam(true);
			}
		}

		boyfriend = new Character(770, 450, SONG.player1, true);

		add(gf);

		add(dad);
		add(boyfriend);

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);

		if (ChillSettings.get('downScroll', 'gameplay'))
			strumLine.y = FlxG.height - 150;

		strumLine.scrollFactor.set();
		strumLineNotes = new FlxTypedGroup<Strums>();
		add(strumLineNotes);

		if (ChillSettings.get('noteSplashes', 'gameplay'))
		{
			playerSplashes = new FlxTypedGroup<NoteSplash>();
			opponentSplashes = new FlxTypedGroup<NoteSplash>();

			var noteSplashPlayer:NoteSplash = new NoteSplash(100, 100, 0); // I dont mean to add 2 of the same thing BUT it does double the speed for whatever reason
			playerSplashes.add(noteSplashPlayer);
			noteSplashPlayer.alpha = 0;

			var noteSplashOpponent:NoteSplash = new NoteSplash(100, 100, 0);
			opponentSplashes.add(noteSplashOpponent);
			noteSplashOpponent.alpha = 0;
	
			add(playerSplashes);
			add(opponentSplashes);
		}

		generateSong();

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);

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

		if (ChillSettings.get('downScroll', 'gameplay'))
			healthBarBG.y = FlxG.height * 0.1;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		add(healthBar);

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

		scoreTxt = new FlxText(0, healthBarBG.y + 30, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.screenCenter(X);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		healthBar.createFilledBar(iconP2.curHealthBarColor, iconP1.curHealthBarColor);
		healthOppTxt.color = iconP2.curHealthBarColor;
		healthPlayerTxt.color = iconP1.curHealthBarColor;

		if (ChillSettings.get('noteSplashes', 'gameplay'))
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
		songTxt.cameras = [camHUD];
		ratingCounterTxt.cameras = [camHUD];
		healthOppTxt.cameras = [camHUD];
		healthPlayerTxt.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];

		startingSong = true;

		if (!seenCutscene && StageBackend.stage.hasCutscene) {}
		else
			startCountdown();

		super.create();

		StageBackend.stage.createPost();
	}

	function initDiscord():Void
	{
		#if discord_rpc
		iconRPC = SONG.player2;

		if (iconRPC != 'bf-pixel' && iconRPC != 'bf-old' && iconRPC != 'bf-old-pixel')
			iconRPC = iconRPC.split('-')[0].trim();

		detailsText = isStoryMode ? "Story Mode: " + storyWeek.name : "Freeplay";
		detailsPausedText = "Paused - " + detailsText;

		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficulty + ")", iconRPC);
		#end
	}

	public function playVideo(videoFile:String)
	{
		inCutscene = true;

		#if hxCodec
		var video:FlxVideo = new FlxVideo();
		video.play(Paths.video(videoFile));
		video.onEndReached.add(function()
		{
			video.dispose();

			StageBackend.stage.endingVideo();

			startCountdown();
			if (generatedMusic && SONG.notes[curSection] != null)
			{
				if(SONG.notes[curSection].mustHitSection)
					cameraMovement(boyfriend);
				else
					cameraMovement(dad);
			}
		});
		#else
		var video:FlxVideo = new FlxVideo(Paths.video(videoFile));
		video.finishCallback = function()
		{
			StageBackend.stage.endingVideo();

			startCountdown();
			if (generatedMusic && SONG.notes[curSection] != null)
			{
				if(SONG.notes[curSection].mustHitSection)
					cameraMovement(boyfriend);
				else
					cameraMovement(dad);
			}
		};
		#end
	}

	var startTimer:FlxTimer = new FlxTimer();
	var perfectMode:Bool = false;

	public function startCountdown()
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		startedCountdown = true;

		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer.start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (swagCounter % gfSpeed == 0)
				gf.dance();
			if (swagCounter % 2 == 0)
			{
				if (!boyfriend.animation.curAnim.name.startsWith("sing"))
					boyfriend.playAnim('idle');
				if (!dad.animation.curAnim.name.startsWith("sing"))
					dad.dance();
			}
			else if (dad.curCharacter == 'spooky' && !dad.animation.curAnim.name.startsWith("sing"))
				dad.dance();
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

	function readySetGo(path:String):Void
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

	function startSong():Void
	{
		startingSong = false;

		#if debug
		canEnd = true;
		#end

		previousFrameTime = FlxG.game.ticks;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(SONG.song), 1, false);

		vocals.play();

		FlxG.sound.music.onComplete = function() {
			endSong();
		};

		#if discord_rpc
		songLength = FlxG.sound.music.length;
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficulty + ")", iconRPC, true, songLength);
		#end
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

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, (gottaHitNote) ? boyfriend.isPixel : dad.isPixel, oldNote, true);
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

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return sortNotes(FlxSort.ASCENDING, Obj1, Obj2);
	}

	function sortNotes(order:Int = FlxSort.ASCENDING, Obj1:Note, Obj2:Note)
	{
		return FlxSort.byValues(order, Obj1.strumTime, Obj2.strumTime);
	}

	public function generateStaticArrows(player:Int):Void
	{
		var arrows:Strums = new Strums(0, strumLine.y, 4, (player == 1) ? boyfriend.isPixel : dad.isPixel);
		for(i in 0...arrows.notes)
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

		if (player == 1)
			playerStrums = arrows;
		else
			opponentStrums = arrows;

		strumLineNotes.add(arrows);
	}

	function tweenCam(goingIn:Bool):Void
	{
		if(goingIn) {
			FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onUpdate: function(twn:FlxTween) {
				StageBackend.stage.zoom = camGAME.zoom;
			}});
		} else {
			FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onUpdate: function(twn:FlxTween) {
				StageBackend.stage.zoom = camGAME.zoom;
			}});
		}
		
	}

	public override function openSubState(SubState:FlxSubState)
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

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
				resyncVocals();

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if discord_rpc
			if (startTimer.finished)
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficulty + ")", iconRPC, true, songLength - Conductor.songPosition);
			else
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficulty + ")", iconRPC);
			#end
		}

		super.closeSubState();
	}

	
	override public function onFocus():Void
	{	#if discord_rpc
		if (health > 0 && !paused && FlxG.autoPause)
		{
			if (Conductor.songPosition > 0.0)
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficulty + ")", iconRPC, true, songLength - Conductor.songPosition);
			else
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficulty + ")", iconRPC);
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if discord_rpc
		if (health > 0 && !paused && FlxG.autoPause)
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficulty + ")", iconRPC);
		#end

		pauseGame();

		super.onFocusLost();
	}

	function resyncVocals():Void
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
	#if debug
	public var canEnd:Bool = false;
	#end

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

		super.update(elapsed);

		songTxt.text = '[' + FlxStringUtil.formatTime(FlxG.sound.music.time / 1000, false) + ' / ' + FlxStringUtil.formatTime(FlxG.sound.music.length / 1000, false) + '] [' + FlxMath.roundDecimal((FlxG.sound.music.time / FlxG.sound.music.length) * 100, 2) + '%] ' + SONG.song + ' - ' + storyDifficulty;

		ratingCounterTxt.text =
		'Sicks: ' + sicks +
		'\nGoods: ' + goods +
		'\nBads: ' + bads +
		'\nShits: ' + shits;

		healthOppTxt.text = "[Health: " + FlxMath.roundDecimal(100 - (health * 50), 2) + "%]";
		healthPlayerTxt.text = "[Health: " + FlxMath.roundDecimal(health * 50, 2) + "%]";

		scoreTxt.text = "[Score: " + songScore + "] - " + "[Misses: " + songMisses + "] - " + "[Accuracy: " + songAccuracy + "%]";

		if (controls.PAUSE)
			pauseGame();

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if discord_rpc
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		if (FlxG.keys.justPressed.NINE) {
			iconP1.swapOldIcon();
			healthBar.createFilledBar(iconP2.curHealthBarColor, iconP1.curHealthBarColor);
			healthBar.updateFilledBar();
			healthOppTxt.color = iconP2.curHealthBarColor;
			healthPlayerTxt.color = iconP1.curHealthBarColor;
			health -= 0.01;
			health += 0.01;
		}

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		var curDate = Date.now();
		if (health > 2 && curDate.getDate() != 1 && curDate.getMonth() != 4) //April Fools Prank
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		#if debug
		if (FlxG.keys.justPressed.ONE && !isEnding && canEnd)
		{
			FlxG.sound.music.stop();
			vocals.stop();
			endSong();
		}

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

		if (FlxG.keys.justPressed.PAGEUP && !isEnding)
			changeSection(1);
		if (FlxG.keys.justPressed.PAGEDOWN && !isEnding)
			changeSection(-1);
		#end

		if(!inCutscene) {
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
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
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
			{
				health = 0;
				trace("RESET = True");
			}

			#if CAN_CHEAT
			if (controls.CHEAT)
			{
				health += 1;
				trace("User is cheating!");
			}
			#end

			if (health <= 0 && !practiceMode)
			{
				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				FlxG.sound.music.stop();
				vocals.stop();

				deathCounter += 1;

				if (FlxG.random.bool(0.1))
					FlxG.switchState(new GameOverState());
				else
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, camGAME));

				#if discord_rpc
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficulty + ")", iconRPC);
				#end
			}
		}

		while (unspawnNotes[0] != null && unspawnNotes[0].strumTime - Conductor.songPosition < 1800 / SONG.speed)
		{
			var dunceNote:Note = unspawnNotes[0];
			notes.add(dunceNote);

			var index:Int = unspawnNotes.indexOf(dunceNote);
			unspawnNotes.shift();
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if ((ChillSettings.get('downScroll', 'gameplay') && daNote.y < -daNote.height)
					|| (!ChillSettings.get('downScroll', 'gameplay') && daNote.y > FlxG.height))
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				var whatStrum:Strums = (daNote.mustPress) ? playerStrums : opponentStrums;
				var strumLineMid = whatStrum.y + Note.swagWidth / 2;

				if (ChillSettings.get('downScroll', 'gameplay'))
				{
					daNote.y = (whatStrum.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

					if (daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith("end") && daNote.prevNote != null)
							daNote.y += daNote.prevNote.height;
						else
							daNote.y += daNote.height / 2;

						if ((!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))
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
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))
						&& daNote.y + daNote.offset.y * daNote.scale.y <= strumLineMid)
					{
						var swagRect:FlxRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);

						swagRect.y = (strumLineMid - daNote.y) / daNote.scale.y;
						swagRect.height -= swagRect.y;
						daNote.clipRect = swagRect;
					}
				}

				daNote.x = whatStrum.x + (Note.swagWidth * daNote.noteData);
				if(daNote.isSustainNote) daNote.x += ((Note.swagWidth - daNote.width) / 2);

				if (!daNote.mustPress && daNote.wasGoodHit)
					opponentNoteHit(daNote);

				if (daNote.mustPress && daNote.strumTime <= Conductor.songPosition && botplay)
					goodNoteHit(daNote);

				if (daNote.isSustainNote && daNote.wasGoodHit)
				{
					if ((!ChillSettings.get('downScroll', 'gameplay') && daNote.y < -daNote.height)
						|| (ChillSettings.get('downScroll', 'gameplay') && daNote.y > FlxG.height))
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
			keyShit();

		if(botplay)
			songAccuracy = 100; // behind the scenes trick!! part 2

		if (!inCutscene)
		{
			for(i in 0...opponentStrums.notes)
			{
				if(opponentStrums.getNote(i).animation.finished && opponentStrums.getNote(i).animation.name == 'confirm') 
					opponentStrums.playNoteAnim(i, 'static');
			}

			if(botplay)
			{
				for(i in 0...playerStrums.notes)
				{
					if(playerStrums.getNote(i).animation.finished && playerStrums.getNote(i).animation.name == 'confirm') 
						playerStrums.playNoteAnim(i, 'static');
				}

				if (boyfriend.animation.finished && boyfriend.animation.name != 'idle')
					boyfriend.playAnim('idle');
			}
		}
	}

	function killCombo():Void
	{
		if (combo > 5 && gf.animOffsets.exists('sad'))
			gf.playAnim('sad');
		if (combo != 0)
		{
			combo = 0;
			displayCombo();
		}
	}

	function pauseGame()
	{
		if(canPause && !isEnding)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			if (FlxG.random.bool(0.1))
				FlxG.switchState(new GitarooPause());
			else
			{
				var boyfriendPos = boyfriend.getScreenPosition();
				openSubState(new PauseSubState(boyfriendPos.x, boyfriendPos.y));
				boyfriendPos.put();
			}

			#if discord_rpc
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficulty + ")", iconRPC);
			#end
		}
	}

	public function camZoom(gameCamZoom:Float = 0.015, camHudZoom:Float = 0.03)
	{
		if (ChillSettings.get('camZoom', 'gameplay'))
		{
			camGAME.zoom += gameCamZoom;
			camHUD.zoom += camHudZoom;
		}
	}

	#if debug
	function changeSection(sec:Int):Void
	{
		FlxG.sound.music.pause();
		vocals.pause();

		var daBPM:Float = SONG.bpm;
		var daPos:Float = 0;
		for (i in 0...(curSection + sec))
		{
			if (SONG.notes[i].changeBPM)
			{
				daBPM = SONG.notes[i].bpm;
			}
			daPos += 4 * (1000 * 60 / daBPM);
		}
		Conductor.songPosition = FlxG.sound.music.time = daPos;
		updateStep();
		resyncVocals();
	}
	#end

	public var endScreen:Bool = true;
	public function endSong()
	{
		/*if(isStoryMode)
			endScreen = false;*/

		if(endScreen)
		{
			openSubState(new EndSubState());
			endScreen = false;
			return;
		}

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		seenCutscene = false;
		deathCounter = 0;

		isEnding = true;

		if (SONG.validScore && !practiceMode && !botplay)
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);

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

            if (SONG.validScore)
                Highscore.saveWeekScore(storyWeek.name, campaignScore, storyDifficulty);
        }
        else
        {
            FlxTransitionableState.skipNextTransIn = true;
            FlxTransitionableState.skipNextTransOut = true;

            FlxG.sound.music.stop();
            vocals.stop();

            prevCamFollow = camFollow;
			SONG = Song.loadFromJson(storyDifficulty.formatToPath(), storyPlaylist[0]);
			LoadingState.loadAndSwitchState(new PlayState());
        }
    }

	function set_inCutscene(inCutscene:Bool)
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

	public function popUpScore(strumtime:Float, daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		vocals.volume = 1;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		var isSick:Bool = true;

		if(!botplay) // behind the scenes trick!! part 3
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

			if (ChillSettings.get('noteSplashes', 'gameplay'))
			{
				var noteSplashPlayer:NoteSplash = playerSplashes.recycle(NoteSplash);
				noteSplashPlayer.setupNoteSplash(daNote.x, daNote.y, daNote.noteData, isPixel);
				playerSplashes.add(noteSplashPlayer);
			}
		}

		songScore += score;
		possibleScore += 350;

		var ratingPath:String = "ui/" + daRating;

		if (isPixel)
			ratingPath = "pixel" + ratingPath;

		rating.loadGraphic(Paths.image(ratingPath));
		rating.x = gf.x + 200 - 40;

		rating.y = gf.y + 200 - 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		add(rating);

		if (isPixel)
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			rating.antialiasing = false;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
		}
		rating.updateHitbox();

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

	function displayCombo():Void
	{
		var pixelShitPart1:String = "";

		if (isPixel)
			pixelShitPart1 = 'pixel';

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'ui/combo'));
		comboSpr.y = gf.y + 200 + 80;
		comboSpr.x = gf.x + 200;
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
		{
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		}
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
			{
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
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
		if(char == dad)
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
			}
		}
		else if (char == boyfriend)
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			StageBackend.stage.cameraMovement(boyfriend);
		}

		if (SONG.song.formatToPath() == 'tutorial') tweenCam(char != boyfriend);
	}

	public function keyShit():Void
	{
		var canIdle:Bool = true;

		var holdArray:Array<Bool> = [
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

		var releaseArray:Array<Bool> = [
			controls.NOTE_LEFT_R,
			controls.NOTE_DOWN_R,
			controls.NOTE_UP_R,
			controls.NOTE_RIGHT_R
		];

		if (holdArray.contains(true) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData]) {
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
			else if (!ChillSettings.get('ghostTapping', 'gameplay'))
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

		for(i in 0...playerStrums.notes)
		{
			if (pressArray[i] && playerStrums.getNote(i).animation.curAnim.name != 'confirm')
				playerStrums.playNoteAnim(i, 'pressed');

			if (!holdArray[i])
				playerStrums.playNoteAnim(i, 'static');

			if(playerStrums.getNote(i).animation.curAnim.name != 'static')
				canIdle = false;
		}
	}

	function missThing()
	{
		health -= 0.04;
		songMisses++;
		killCombo();

		if (!practiceMode) {
			songScore -= 10;
			possibleScore += 350;
		}

		vocals.volume = 0;
		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
	}

	function ghostHit()
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

	function noteMiss(note:Note):Void
	{
		missThing();

		boyfriend.playAnim(singArray[note.noteData] + 'miss', true);
	}

	function goodNoteHit(note:Note):Void
	{
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

			for(i in 0...playerStrums.notes)
			{
				var spr:FlxSprite = playerStrums.getNote(i);

				if (Math.abs(note.noteData) == i)
					spr.animation.play('confirm', true);
			}

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	function opponentNoteHit(daNote:Note):Void
	{
		var altAnim:String = "";

		if (SONG.notes[curSection] != null)
		{
			if (SONG.notes[curSection].altAnim)
				altAnim = '-alt';
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

		for(i in 0...opponentStrums.notes)
		{
			var spr:FlxSprite = opponentStrums.getNote(i);

			if (Math.abs(daNote.noteData) == i)
				opponentStrums.playNoteAnim(i, 'confirm', true);
		}

		if (!daNote.isSustainNote && ChillSettings.get('noteSplashes', 'gameplay'))
		{
			var noteSplashOpponent:NoteSplash = opponentSplashes.recycle(NoteSplash);
			noteSplashOpponent.setupNoteSplash(daNote.x, daNote.y, daNote.noteData, dad.isPixel);
			opponentSplashes.add(noteSplashOpponent);
		}
	}

	function calculateAccuracy()
	{
		songAccuracy = FlxMath.roundDecimal((songScore / possibleScore) * 100, 2);
		if(Math.isNaN(songAccuracy)) songAccuracy = 0;
	}

	override function stepHit()
	{
		super.stepHit();

		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}

		StageBackend.stage.curStep = curStep;
		StageBackend.stage.stepHit();
	}

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(sortNotes, FlxSort.DESCENDING);
		}

		for(i in 0...2)
		{
			var daThings:Array<HealthIcon> = [iconP1, iconP2];

			if(bopTween[i] != null) bopTween[i].cancel();
			daThings[i].scale.set(1.3, 1.3);
			bopTween[i] = FlxTween.tween(daThings[i].scale, {x: 1, y: 1}, 0.3, {ease: FlxEase.cubeInOut});
		}

		if (curBeat % gfSpeed == 0)
			gf.dance();

		if (curBeat % 2 == 0)
		{
			if (!boyfriend.animation.curAnim.name.startsWith("sing"))
				boyfriend.dance();
			if (!dad.animation.curAnim.name.startsWith("sing"))
				dad.dance();
		}
		else if (dad.curCharacter == 'spooky')
		{
			if (!dad.animation.curAnim.name.startsWith("sing"))
				dad.dance();
		}

		if (curBeat % 8 == 7 && SONG.song.formatToPath() == 'bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		StageBackend.stage.curBeat = curBeat;
		StageBackend.stage.beatHit();
	}

	override function sectionHit()
	{
		super.sectionHit();

		if (SONG.notes[curSection] != null)
		{
			if (generatedMusic)
			{
				if(SONG.notes[curSection].mustHitSection)
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
	}

	function onEvent(name:String, params:Array<Dynamic>)
	{
		switch(name)
		{
			case 'Camera Zoom':
				var daZoomGame:Float = 0.015;
				var daZoomHUD:Float = 0.03;
				if(params != null || !Math.isNaN(Std.parseFloat(params[0])) || !Math.isNaN(Std.parseFloat(params[1]))) {
					daZoomGame = Std.parseFloat(params[0]);
					daZoomHUD = Std.parseFloat(params[1]);
				}

				camZoom(daZoomGame, daZoomHUD);

			case 'Hey!':
				if(params[0] == true)
					boyfriend.playAnim('hey', true);

				if(params[1] == true)
					gf.playAnim('hey', true);

				if(params[2] == true)
					dad.playAnim('hey', true);

			case 'Change Character':
				if(params == null) return;
				trace(params[0]);
				trace(params[1]);
		}
	}
}
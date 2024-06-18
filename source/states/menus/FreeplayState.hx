package states.menus;

import addons.Week;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxAngle;
import shaders.*;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxSpriteUtil;
import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup;
import objects.menu.DJBoyfriend;
import objects.menu.SongMenuItem;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import objects.menu.FreeplayScore;
import flixel.math.FlxPoint;
import objects.Alphabet as AtlasText;
import substates.StickerSubState;
import objects.menu.BGScrollingText;
import openfl.utils.Assets;
import substates.ModifierSubstate;

/**
 * Parameters used to initialize the FreeplayState.
 */
 typedef FreeplayStateParams =
 {
   ?character:String,
 };
 
 /**
  * The state for the freeplay menu, allowing the player to select any song to play.
  */
 class FreeplayState extends MusicBeatState
 {
   //
   // Params
   //
 
   /**
	* The current character for this FreeplayState.
	* You can't change this without transitioning to a new FreeplayState.
	*/
   final currentCharacter:String;
 
   /**
	* For the audio preview, the duration of the fade-in effect.
	*/
   public static final FADE_IN_DURATION:Float = 0.5;
 
   /**
	* For the audio preview, the duration of the fade-out effect.
	*/
   public static final FADE_OUT_DURATION:Float = 0.25;
 
   /**
	* For the audio preview, the volume at which the fade-in starts.
	*/
   public static final FADE_IN_START_VOLUME:Float = 0.25;
 
   /**
	* For the audio preview, the volume at which the fade-in ends.
	*/
   public static final FADE_IN_END_VOLUME:Float = 1.0;
 
   /**
	* For the audio preview, the volume at which the fade-out starts.
	*/
   public static final FADE_OUT_END_VOLUME:Float = 0.0;
 
   var songs:Array<SongData> = [];
 
   var diffIdsCurrent:Array<String> = [];
   var diffIdsTotal:Array<String> = [];
 
   private static var curSelected:Int = 0;
   private static var currentDifficulty:String = 'Normal';
 
   var fp:FreeplayScore;
   var txtCompletion:AtlasText;
   var lerpCompletion:Float = 0;
   var intendedCompletion:Float = 0;
   var lerpScore:Float = 0;
   var intendedScore:Int = 0;
 
   var grpDifficulties:FlxTypedSpriteGroup<DifficultySprite>;
 
   var grpCapsules:FlxTypedGroup<SongMenuItem>;
   var curCapsule:SongMenuItem;
   var curPlaying:Bool = false;
 
   var displayedVariations:Array<String>;
 
   var dj:DJBoyfriend;
 
   var ostName:FlxText;
   //var albumRoll:AlbumRoll;
 
   var letterSort:LetterSort;
   var exitMovers:ExitMoverData = new Map();

   var randomSong:FlxSound;
 
   var stickerSubState:StickerSubState;
 
   public static var rememberedDifficulty:Null<String> = 'Normal';
   public static var rememberedSongId:Null<String> = 'tutorial';
 
   public function new(?params:FreeplayStateParams, ?stickers:StickerSubState)
   {
	 currentCharacter = (params != null) ? params.character : 'bf';
 
	 if (stickers != null)
	 {
	   stickerSubState = stickers;
	 }
 
	 super();
   }
 
   override function create():Void
   {
	 super.create();

	 FlxG.cameras.reset(new SwagCamera());
 
	 FlxTransitionableState.skipNextTransIn = true;

	 changeWindowName('Freeplay');

	 #if DISCORD
	 DiscordRPC.details = 'Freeplay';
	 #end

	 randomSong = new FlxSound().loadEmbedded(Paths.music('freeplayRandom'), true);
	 FlxG.sound.list.add(randomSong);
	 randomSong.stop();
	 
 
	 if (stickerSubState != null)
	 {
	   this.persistentUpdate = true;
	   this.persistentDraw = true;
 
	   openSubState(stickerSubState);
	   stickerSubState.degenStickers();
	 }
 
	 #if discord_rpc
	 // Updating Discord Rich Presence
	 DiscordClient.changePresence('In the Menus', null);
	 #end
 
	 var isDebug:Bool = false;
 
	 #if debug
	 isDebug = true;
	 #end
 
	 if(FlxG.sound.music != null) 
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
 
	 // Add a null entry that represents the RANDOM option
	 // songs.push(null);
 
	 // TODO: This makes custom variations disappear from Freeplay. Figure out a better solution later.
	 // Default character (BF) shows default and Erect variations. Pico shows only Pico variations.
	 displayedVariations = (currentCharacter == 'bf') ? ['default', 'erect'] : [currentCharacter];
 
	 for (week in Week.weeks)
	 {
	   for (song in week.songs)
	   {
		 // Only display songs which actually have available charts for the current character.
		 var availableDifficultiesForSong:Array<String> = song.difficulties;
		 if (availableDifficultiesForSong.length == 0) continue;
 
		 songs.push(song);

		 for (difficulty in song.difficulties)
		 {
		   if(!diffIdsTotal.contains(difficulty)) diffIdsTotal.push(difficulty);
		 }
	   }
	 }
 
	 // LOAD MUSIC
 
	 // LOAD CHARACTERS
 
	 trace(FlxG.width);
	 trace(FlxG.camera.zoom);
	 trace(FlxG.camera.initialZoom);
	 trace(FlxCamera.defaultZoom);
 
	 var pinkBack:FlxSprite = new FlxSprite(Paths.image('freeplay/pinkBack'));
	 pinkBack.color = 0xFFFFD4E9; // sets it to pink!
	 pinkBack.x -= pinkBack.width;
 
	 FlxTween.tween(pinkBack, {x: 0}, 0.6, {ease: FlxEase.quartOut});
	 add(pinkBack);
 
	 var orangeBackShit:FlxSprite = new FlxSprite(84, 440).makeGraphic(Std.int(pinkBack.width), 75, 0xFFFEDA00);
	 add(orangeBackShit);
 
	 var alsoOrangeLOL:FlxSprite = new FlxSprite(0, orangeBackShit.y).makeGraphic(100, Std.int(orangeBackShit.height), 0xFFFFD400);
	 add(alsoOrangeLOL);
 
	 exitMovers.set([pinkBack, orangeBackShit, alsoOrangeLOL],
	   {
		 x: -pinkBack.width,
		 y: pinkBack.y,
		 speed: 0.4,
		 wait: 0
	   });
 
	 FlxSpriteUtil.alphaMaskFlxSprite(orangeBackShit, pinkBack, orangeBackShit);
	 orangeBackShit.visible = false;
	 alsoOrangeLOL.visible = false;
 
	 var grpTxtScrolls:FlxGroup = new FlxGroup();
	 add(grpTxtScrolls);
	 grpTxtScrolls.visible = false;
 
	 FlxG.debugger.addTrackerProfile(new TrackerProfile(BGScrollingText, ['x', 'y', 'speed', 'size']));
 
	 var moreWays:BGScrollingText = new BGScrollingText(0, 160, 'HOT BLOODED IN MORE WAYS THAN ONE', FlxG.width, true, 43);
	 moreWays.funnyColor = 0xFFFFF383;
	 moreWays.speed = 6.8;
	 grpTxtScrolls.add(moreWays);
 
	 exitMovers.set([moreWays],
	   {
		 x: FlxG.width * 2,
		 speed: 0.4,
	   });
 
	 var funnyScroll:BGScrollingText = new BGScrollingText(0, 220, 'BOYFRIEND', FlxG.width / 2, false, 60);
	 funnyScroll.funnyColor = 0xFFFF9963;
	 funnyScroll.speed = -3.8;
	 grpTxtScrolls.add(funnyScroll);
 
	 exitMovers.set([funnyScroll],
	   {
		 x: -funnyScroll.width * 2,
		 y: funnyScroll.y,
		 speed: 0.4,
		 wait: 0
	   });
 
	 var txtNuts:BGScrollingText = new BGScrollingText(0, 285, 'PROTECT YO NUTS', FlxG.width / 2, true, 43);
	 txtNuts.speed = 3.5;
	 grpTxtScrolls.add(txtNuts);
	 exitMovers.set([txtNuts],
	   {
		 x: FlxG.width * 2,
		 speed: 0.4,
	   });
 
	 var funnyScroll2:BGScrollingText = new BGScrollingText(0, 335, 'BOYFRIEND', FlxG.width / 2, false, 60);
	 funnyScroll2.funnyColor = 0xFFFF9963;
	 funnyScroll2.speed = -3.8;
	 grpTxtScrolls.add(funnyScroll2);
 
	 exitMovers.set([funnyScroll2],
	   {
		 x: -funnyScroll2.width * 2,
		 speed: 0.5,
	   });
 
	 var moreWays2:BGScrollingText = new BGScrollingText(0, 397, 'HOT BLOODED IN MORE WAYS THAN ONE', FlxG.width, true, 43);
	 moreWays2.funnyColor = 0xFFFFF383;
	 moreWays2.speed = 6.8;
	 grpTxtScrolls.add(moreWays2);
 
	 exitMovers.set([moreWays2],
	   {
		 x: FlxG.width * 2,
		 speed: 0.4
	   });
 
	 var funnyScroll3:BGScrollingText = new BGScrollingText(0, orangeBackShit.y + 10, 'BOYFRIEND', FlxG.width / 2, 60);
	 funnyScroll3.funnyColor = 0xFFFEA400;
	 funnyScroll3.speed = -3.8;
	 grpTxtScrolls.add(funnyScroll3);
 
	 exitMovers.set([funnyScroll3],
	   {
		 x: -funnyScroll3.width * 2,
		 speed: 0.3
	   });
 
	 dj = new DJBoyfriend(640, 366);
	 dj.scrollFactor.set();
	 dj.updateHitbox();
	 exitMovers.set([dj],
	   {
		 x: -dj.width * 1.6,
		 speed: 0.5
	   });
 
	 // TODO: Replace this.
	 //if (currentCharacter == 'pico') dj.visible = false;
 
	 add(dj);

	 dj.visible = true;
	 dj.alpha = 1;
 
	 var bgDad:FlxSprite = new FlxSprite(pinkBack.width * 0.75, 0).loadGraphic(Paths.image('freeplay/freeplayBGdad'));
	 bgDad.setGraphicSize(0, FlxG.height);
	 bgDad.updateHitbox();
	 bgDad.shader = new AngleMask();
	 bgDad.visible = false;
 
	 var blackOverlayBullshitLOLXD:FlxSprite = new FlxSprite(FlxG.width).makeGraphic(Std.int(bgDad.width), Std.int(bgDad.height), FlxColor.BLACK);
	 add(blackOverlayBullshitLOLXD); // used to mask the text lol!
 
	 exitMovers.set([blackOverlayBullshitLOLXD, bgDad],
	   {
		 x: FlxG.width * 1.5,
		 speed: 0.4,
		 wait: 0
	   });
 
	 add(bgDad);
	 FlxTween.tween(blackOverlayBullshitLOLXD, {x: pinkBack.width * 0.75}, 0.7, {ease: FlxEase.quintOut});
 
	 blackOverlayBullshitLOLXD.shader = bgDad.shader;
 
	 grpCapsules = new FlxTypedGroup<SongMenuItem>();
	 add(grpCapsules);
 
	 grpDifficulties = new FlxTypedSpriteGroup<DifficultySprite>(-300, 80);
	 add(grpDifficulties);
 
	 exitMovers.set([grpDifficulties],
	   {
		 x: -300,
		 speed: 0.25,
		 wait: 0
	   });
 
	 for (diffId in diffIdsTotal)
	 {
	   var diffSprite:DifficultySprite = new DifficultySprite(diffId);
	   diffSprite.difficultyId = diffId;
	   grpDifficulties.add(diffSprite);
	 }
 
	 grpDifficulties.group.forEach(function(spr) {
	   spr.visible = false;
	 });
 
	 for (diffSprite in grpDifficulties.group.members)
	 {
	   if (diffSprite == null) continue;
	   if (diffSprite.difficultyId == currentDifficulty) diffSprite.visible = true;
	 }
 
	 /*albumRoll = new AlbumRoll();
	 albumRoll.albumId = null;
	 add(albumRoll);
 
	 albumRoll.applyExitMovers(exitMovers);*/
 
	 var overhangStuff:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 64, FlxColor.BLACK);
	 overhangStuff.y -= overhangStuff.height;
	 add(overhangStuff);
	 FlxTween.tween(overhangStuff, {y: 0}, 0.3, {ease: FlxEase.quartOut});
 
	 var fnfFreeplay:FlxText = new FlxText(8, 8, 0, 'FREEPLAY', 48);
	 fnfFreeplay.font = 'VCR OSD Mono';
	 fnfFreeplay.visible = false;
 
	 ostName = new FlxText(8, 8, FlxG.width - 8 - 8, 'OFFICIAL OST', 48);
	 ostName.font = 'VCR OSD Mono';
	 ostName.alignment = RIGHT;
	 ostName.visible = false;
 
	 exitMovers.set([overhangStuff, fnfFreeplay, ostName],
	   {
		 y: -overhangStuff.height,
		 x: 0,
		 speed: 0.2,
		 wait: 0
	   });
 
	 var sillyStroke:StrokeShader = new StrokeShader(0xFFFFFFFF, 2, 2);
	 fnfFreeplay.shader = sillyStroke;
	 ostName.shader = sillyStroke;
	 add(fnfFreeplay);
	 add(ostName);
 
	 var fnfHighscoreSpr:FlxSprite = new FlxSprite(860, 70);
	 fnfHighscoreSpr.frames = Paths.getSparrowAtlas('freeplay/highscore');
	 fnfHighscoreSpr.animation.addByPrefix('highscore', 'highscore small instance 1', 24, false);
	 fnfHighscoreSpr.visible = false;
	 fnfHighscoreSpr.setGraphicSize(0, Std.int(fnfHighscoreSpr.height * 1));
	 fnfHighscoreSpr.updateHitbox();
	 add(fnfHighscoreSpr);
 
	 new FlxTimer().start(FlxG.random.float(12, 50), function(tmr) {
	   fnfHighscoreSpr.animation.play('highscore');
	   tmr.time = FlxG.random.float(20, 60);
	 }, 0);
 
	 fp = new FreeplayScore(460, 60, 7, 100);
	 fp.visible = false;
	 add(fp);
 
	 var clearBoxSprite:FlxSprite = new FlxSprite(1165, 65).loadGraphic(Paths.image('freeplay/clearBox'));
	 clearBoxSprite.visible = false;
	 add(clearBoxSprite);
 
	 txtCompletion = new AtlasText(1185, 87, '69', FREEPLAY_CLEAR);
	 txtCompletion.visible = false;
	 add(txtCompletion);
 
	 letterSort = new LetterSort(400, 75);
	 add(letterSort);
	 letterSort.visible = false;
 
	 exitMovers.set([letterSort],
	   {
		 y: -100,
		 speed: 0.3
	   });
 
	 letterSort.changeSelectionCallback = (str) -> {
	   switch (str)
	   {
		 case 'ALL':
		   generateSongList(null, true);
		 default:
		   generateSongList({filterType: REGEXP, filterData: str}, true);
	   }
 
	   // We want to land on the first song of the group, rather than random song when changing letter sorts
	   // that is, only if there's more than one song in the group!
	   if (grpCapsules.members.length > 0)
	   {
		 curSelected = 1;
		 changeSelection();
	   }
	 };
 
	 exitMovers.set([fp, txtCompletion, fnfHighscoreSpr, txtCompletion, clearBoxSprite],
	   {
		 x: FlxG.width,
		 speed: 0.3
	   });
 
	 var diffSelLeft:DifficultySelector = new DifficultySelector(20, grpDifficulties.y - 10, false, controls);
	 var diffSelRight:DifficultySelector = new DifficultySelector(325, grpDifficulties.y - 10, true, controls);
	 diffSelLeft.visible = false;
	 diffSelRight.visible = false;
	 add(diffSelLeft);
	 add(diffSelRight);
 
	 // be careful not to "add()" things in here unless it's to a group that's already added to the state
	 // otherwise it won't be properly attatched to funnyCamera (relavent code should be at the bottom of create())
	 dj.onIntroDone.add(function() {
	   // when boyfriend hits dat shiii
 
	   //albumRoll.playIntro();
 
	   new FlxTimer().start(0.75, function(_) {
		 // albumRoll.showTitle();
	   });
 
	   FlxTween.tween(grpDifficulties, {x: 90}, 0.6, {ease: FlxEase.quartOut});
 
	   diffSelLeft.visible = true;
	   diffSelRight.visible = true;
	   letterSort.visible = true;
 
	   exitMovers.set([diffSelLeft, diffSelRight],
		 {
		   x: -diffSelLeft.width * 2,
		   speed: 0.26
		 });
 
	   new FlxTimer().start(1 / 24, function(handShit) {
		 fnfHighscoreSpr.visible = true;
		 fnfFreeplay.visible = true;
		 ostName.visible = true;
		 fp.visible = true;
		 fp.updateScore(0);
 
		 clearBoxSprite.visible = true;
		 txtCompletion.visible = true;
		 intendedCompletion = 0;
 
		 new FlxTimer().start(1.5 / 24, function(bold) {
		   sillyStroke.width = 0;
		   sillyStroke.height = 0;
		   changeSelection();
		 });
	   });
 
	   pinkBack.color = 0xFFFFD863;
	   bgDad.visible = true;
	   orangeBackShit.visible = true;
	   alsoOrangeLOL.visible = true;
	   grpTxtScrolls.visible = true;
	 });
 
	 generateSongList(null, false);
   }
 
   var currentFilter:SongFilter = null;
   var currentFilteredSongs:Array<SongData> = [];
 
   /**
	* Given the current filter, rebuild the current song list.
	*
	* @param filterStuff A filter to apply to the song list (regex, startswith, all, favorite)
	* @param force Whether the capsules should "jump" back in or not using their animation
	* @param onlyIfChanged Only apply the filter if the song list has changed
	*/
   public function generateSongList(filterStuff:Null<SongFilter>, force:Bool = false, onlyIfChanged:Bool = true):Void
   {
	 var tempSongs:Array<SongData> = songs;
 
	 // Remember just the difficulty because it's important for song sorting.
	 if (rememberedDifficulty != null)
	 {
	   currentDifficulty = rememberedDifficulty;
	 }
 
	 if (filterStuff != null) tempSongs = sortSongs(tempSongs, filterStuff);
 
	 // Filter further by current selected difficulty.
	 if (currentDifficulty != null)
	 {
	   tempSongs = tempSongs.filter(song -> {
		 if (song == null) return true; // Random
		 return song.difficulties.contains(currentDifficulty);
	   });
	 }
 
	 if (onlyIfChanged)
	 {
	   // == performs equality by reference
	   if (tempSongs.isEqualUnordered(currentFilteredSongs)) return;
	 }
 
	 // Only now do we know that the filter is actually changing.
 
	 // If curSelected is 0, the result will be null and fall back to the rememberedSongId.
	 rememberedSongId = (curSelected != 0 && grpCapsules.members[curSelected] != null && grpCapsules.members[curSelected].songData != null) ? grpCapsules.members[curSelected].songData.song.formatToPath() : rememberedSongId;
 
	 for (cap in grpCapsules.members)
	 {
	   cap.kill();
	 }
 
	 currentFilter = filterStuff;
 
	 currentFilteredSongs = tempSongs;
	 curSelected = 0;
 
	 var hsvShader:HSVShader = new HSVShader();
 
	 var randomCapsule:SongMenuItem = grpCapsules.recycle(SongMenuItem);
	 randomCapsule.init(FlxG.width, 0, null);
	 randomCapsule.onConfirm = function() {
	   capsuleOnConfirmRandom(randomCapsule);
	 };
	 randomCapsule.y = randomCapsule.intendedY(0) + 10;
	 randomCapsule.targetPos.x = randomCapsule.x;
	 randomCapsule.alpha = 0.5;
	 randomCapsule.songText.visible = false;
	 randomCapsule.favIcon.visible = false;
	 randomCapsule.initJumpIn(0, force);
	 randomCapsule.hsvShader = hsvShader;
	 grpCapsules.add(randomCapsule);
 
	 for (i in 0...tempSongs.length)
	 {
	   if (tempSongs[i] == null) continue;
 
	   var funnyMenu:SongMenuItem = grpCapsules.recycle(SongMenuItem);
 
	   funnyMenu.init(FlxG.width, 0, tempSongs[i]);
	   funnyMenu.onConfirm = function() {
		 capsuleOnConfirmDefault(funnyMenu);
	   };
	   funnyMenu.y = funnyMenu.intendedY(i + 1) + 10;
	   funnyMenu.targetPos.x = funnyMenu.x;
	   funnyMenu.ID = i;
	   funnyMenu.capsule.alpha = 0.5;
	   funnyMenu.songText.visible = false;
	   //funnyMenu.favIcon.visible = tempSongs[i].isFav;
	   funnyMenu.hsvShader = hsvShader;
 
	   funnyMenu.forcePosition();
 
	   grpCapsules.add(funnyMenu);
	 }
 
	 FlxG.console.registerFunction('changeSelection', changeSelection);
 
	 rememberSelection();
 
	 changeSelection();
	 changeDiff(0, true);
   }
 
   /**
	* Filters an array of songs based on a filter
	* @param songsToFilter What data to use when filtering
	* @param songFilter The filter to apply
	* @return Array<SongData>
	*/
   public function sortSongs(songsToFilter:Array<SongData>, songFilter:SongFilter):Array<SongData>
   {
	 switch (songFilter.filterType)
	 {
	   case REGEXP:
		 // filterStuff.filterData has a string with the first letter of the sorting range, and the second one
		 // this creates a filter to return all the songs that start with a letter between those two
 
		 // if filterData looks like "A-C", the regex should look something like this: ^[A-C].*
		 // to get every song that starts between A and C
		 var filterRegexp:EReg = new EReg('^[' + songFilter.filterData + '].*', 'i');
		 songsToFilter = songsToFilter.filter(str -> {
		   if (str == null) return true; // Random
		   return filterRegexp.match(str.song);
		 });
 
	   case STARTSWITH:
		 // extra note: this is essentially a "search"
 
		 songsToFilter = songsToFilter.filter(str -> {
		   if (str == null) return true; // Random
		   return str.song.formatToPath().startsWith(songFilter.filterData);
		 });
	   case ALL:
	   // no filter!
	   default:
	   	 sortSongs(songsToFilter, {filterType: ALL, filterData: songFilter.filterData});
	 }
	 return songsToFilter;
   }
 
   var touchY:Float = 0;
   var touchX:Float = 0;
   var dxTouch:Float = 0;
   var dyTouch:Float = 0;
   var velTouch:Float = 0;
 
   var veloctiyLoopShit:Float = 0;
   var touchTimer:Float = 0;
 
   var initTouchPos:FlxPoint = new FlxPoint();
 
   var spamTimer:Float = 0;
   var spamming:Bool = false;
 
   var busy:Bool = false; // Set to true once the user has pressed enter to select a song.
 
   override function update(elapsed:Float):Void
   {
	 super.update(elapsed);
 
	 /*if (FlxG.keys.justPressed.F)
	 {
	   var targetSong = (grpCapsules.members[curSelected] != null) ? grpCapsules.members[curSelected].songData : null;
	   if (targetSong != null)
	   {
		 var realShit:Int = curSelected;
		 targetSong.isFav = !targetSong.isFav;
		 if (targetSong.isFav)
		 {
		   FlxTween.tween(grpCapsules.members[realShit], {angle: 360}, 0.4,
			 {
			   ease: FlxEase.elasticOut,
			   onComplete: _ -> {
				 grpCapsules.members[realShit].favIcon.visible = true;
				 grpCapsules.members[realShit].favIcon.animation.play('fav');
			   }
			 });
		 }
		 else
		 {
		   grpCapsules.members[realShit].favIcon.animation.play('fav', false, true);
		   new FlxTimer().start((1 / 24) * 14, _ -> {
			 grpCapsules.members[realShit].favIcon.visible = false;
		   });
		   new FlxTimer().start((1 / 24) * 24, _ -> {
			 FlxTween.tween(grpCapsules.members[realShit], {angle: 0}, 0.4, {ease: FlxEase.elasticOut});
		   });
		 }
	   }
	 }*/
 
	 lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.2);
	 lerpCompletion = CoolUtil.coolLerp(lerpCompletion, intendedCompletion, 0.9);
 
	 if (Math.isNaN(lerpScore))
	 {
	   lerpScore = intendedScore;
	 }
 
	 if (Math.isNaN(lerpCompletion))
	 {
	   lerpCompletion = intendedCompletion;
	 }
 
	 fp.updateScore(Std.int(lerpScore));
 
	 txtCompletion.text = '${Math.floor(lerpCompletion * 100)}';
 
	 // Right align the completion percentage
	 switch (txtCompletion.text.length)
	 {
	   case 3:
		 txtCompletion.offset.x = 10;
	   case 2:
		 txtCompletion.offset.x = 0;
	   case 1:
		 txtCompletion.offset.x = -24;
	   default:
		 txtCompletion.offset.x = 0;
	 }

	 if(randomSong.playing)
		Conductor.songPosition = randomSong.time;
	 else
		Conductor.songPosition = FlxG.sound.music.time;
 
	 handleInputs(elapsed);
   }
 
   function handleInputs(elapsed:Float):Void
   {
	 if (busy) return;
 
	 var upP:Bool = controls.UI_UP_P && !FlxG.keys.pressed.CONTROL;
	 var downP:Bool = controls.UI_DOWN_P && !FlxG.keys.pressed.CONTROL;
	 var accepted:Bool = controls.ACCEPT && !FlxG.keys.pressed.CONTROL;
 
	 if (FlxG.onMobile)
	 {
	   for (touch in FlxG.touches.list)
	   {
		 if (touch.justPressed)
		 {
		   initTouchPos.set(touch.screenX, touch.screenY);
		 }
		 if (touch.pressed)
		 {
		   var dx:Float = initTouchPos.x - touch.screenX;
		   var dy:Float = initTouchPos.y - touch.screenY;
 
		   var angle:Float = Math.atan2(dy, dx);
		   var length:Float = Math.sqrt(dx * dx + dy * dy);
 
		   FlxG.watch.addQuick('LENGTH', length);
		   FlxG.watch.addQuick('ANGLE', Math.round(FlxAngle.asDegrees(angle)));
		 }
	   }
 
	   if (FlxG.touches.getFirst() != null)
	   {
		 if (touchTimer >= 1.5) accepted = true;
 
		 touchTimer += elapsed;
		 var touch:FlxTouch = FlxG.touches.getFirst();
 
		 velTouch = Math.abs((touch.screenY - dyTouch)) / 50;
 
		 dyTouch = touch.screenY - touchY;
		 dxTouch = touch.screenX - touchX;
 
		 if (touch.justPressed)
		 {
		   touchY = touch.screenY;
		   dyTouch = 0;
		   velTouch = 0;
 
		   touchX = touch.screenX;
		   dxTouch = 0;
		 }
 
		 if (Math.abs(dxTouch) >= 100)
		 {
		   touchX = touch.screenX;
		   if (dxTouch != 0) dxTouch < 0 ? changeDiff(1) : changeDiff(-1);
		 }
 
		 if (Math.abs(dyTouch) >= 100)
		 {
		   touchY = touch.screenY;
 
		   if (dyTouch != 0) dyTouch < 0 ? changeSelection(1) : changeSelection(-1);
		 }
	   }
	   else
	   {
		 touchTimer = 0;
	   }
	 }
 
	 #if mobile
	 for (touch in FlxG.touches.list)
	 {
	   if (touch.justPressed)
	   {
		 // accepted = true;
	   }
	 }
	 #end
 
	 if (!FlxG.keys.pressed.CONTROL && (controls.UI_UP || controls.UI_DOWN))
	 {
	   if (spamming)
	   {
		 if (spamTimer >= 0.07)
		 {
		   spamTimer = 0;
 
		   if (controls.UI_UP)
		   {
			 changeSelection(-1);
		   }
		   else
		   {
			 changeSelection(1);
		   }
		 }
	   }
	   else if (spamTimer >= 0.9)
	   {
		 spamming = true;
	   }
	   else if (spamTimer <= 0)
	   {
		 if (controls.UI_UP)
		 {
		   changeSelection(-1);
		 }
		 else
		 {
		   changeSelection(1);
		 }
	   }
 
	   spamTimer += elapsed;
	   dj.resetAFKTimer();
	 }
	 else
	 {
	   spamming = false;
	   spamTimer = 0;
	 }
 
	 if (FlxG.mouse.wheel != 0)
	 {
	   dj.resetAFKTimer();
	   changeSelection(-FlxG.mouse.wheel);
	 }
 
	 if (controls.UI_LEFT_P && !FlxG.keys.pressed.CONTROL)
	 {
	   dj.resetAFKTimer();
	   changeDiff(-1);
	   generateSongList(currentFilter, true);
	 }
	 if (controls.UI_RIGHT_P && !FlxG.keys.pressed.CONTROL)
	 {
	   dj.resetAFKTimer();
	   changeDiff(1);
	   generateSongList(currentFilter, true);
	 }
 
	 if (controls.BACK)
	 {
	   FlxTween.globalManager.clear();
	   FlxTimer.globalManager.clear();
	   dj.onIntroDone.removeAll();
 
	   FlxG.sound.play(Paths.sound('cancelMenu'));
 
	   var longestTimer:Float = 0;
 
	   for (grpSpr in exitMovers.keys())
	   {
		 var moveData:MoveData = exitMovers.get(grpSpr);
 
		 for (spr in grpSpr)
		 {
		   if (spr == null) continue;
 
		   var funnyMoveShit:MoveData = moveData;
 
		   if (moveData.x == null) funnyMoveShit.x = spr.x;
		   if (moveData.y == null) funnyMoveShit.y = spr.y;
		   if (moveData.speed == null) funnyMoveShit.speed = 0.2;
		   if (moveData.wait == null) funnyMoveShit.wait = 0;
 
		   FlxTween.tween(spr, {x: funnyMoveShit.x, y: funnyMoveShit.y}, funnyMoveShit.speed, {ease: FlxEase.expoIn});
 
		   longestTimer = Math.max(longestTimer, funnyMoveShit.speed + funnyMoveShit.wait);
		 }
	   }
 
	   for (caps in grpCapsules.members)
	   {
		 caps.doJumpIn = false;
		 caps.doLerp = false;
		 caps.doJumpOut = true;
	   }
 
	   new FlxTimer().start(longestTimer, (_) -> {
		 FlxTransitionableState.skipNextTransIn = true;
		 FlxTransitionableState.skipNextTransOut = true;
		 FlxG.switchState(new MainMenuState());
	   });
	 }
 
	 if (accepted)
	 {
	   grpCapsules.members[curSelected].onConfirm();
	 }

	 if(FlxG.keys.pressed.TAB)
	 {
		openSubState(new ModifierSubstate());
		persistentUpdate = false;
	 }
   }
 
   public override function destroy():Void
   {
	 super.destroy();
	 var daSong:Null<SongData> = currentFilteredSongs[curSelected];
	 if (daSong != null)
	 {
	   clearDaCache(daSong.song);
	 }
   }
 
   function changeDiff(change:Int = 0, force:Bool = false):Void
   {
	 touchTimer = 0;
 
	 var currentDifficultyIndex:Int = diffIdsCurrent.indexOf(currentDifficulty);
 
	 if (currentDifficultyIndex == -1) currentDifficultyIndex = diffIdsCurrent.indexOf('Normal');
 
	 currentDifficultyIndex += change;
 
	 if (currentDifficultyIndex < 0) currentDifficultyIndex = diffIdsCurrent.length - 1;
	 if (currentDifficultyIndex >= diffIdsCurrent.length) currentDifficultyIndex = 0;
 
	 currentDifficulty = diffIdsCurrent[currentDifficultyIndex];
 
	 var daSong:Null<SongData> = grpCapsules.members[curSelected].songData;
	 if (daSong != null)
	 {
	   var songScore:Null<Int> = Highscore.getScore(grpCapsules.members[curSelected].songData.song, currentDifficulty);
	   intendedScore = (songScore != null) ? songScore : 0;
	   //intendedCompletion = (songScore != null) ? songScore.accuracy : 0.0;
	   rememberedDifficulty = currentDifficulty;
	 }
	 else
	 {
	   intendedScore = 0;
	   intendedCompletion = 0.0;
	 }
 
	 if (intendedCompletion == Math.POSITIVE_INFINITY || intendedCompletion == Math.NEGATIVE_INFINITY || Math.isNaN(intendedCompletion))
	 {
	   intendedCompletion = 0;
	 }
 
	 grpDifficulties.group.forEach(function(diffSprite) {
	   diffSprite.visible = false;
	 });
 
	 for (diffSprite in grpDifficulties.group.members)
	 {
	   if (diffSprite == null) continue;
	   if (diffSprite.difficultyId == currentDifficulty)
	   {
		 if (change != 0)
		 {
		   diffSprite.visible = true;
		   diffSprite.offset.y += 5;
		   diffSprite.alpha = 0.5;
		   new FlxTimer().start(1 / 24, function(swag) {
			 diffSprite.alpha = 1;
			 diffSprite.updateHitbox();
		   });
		 }
		 else
		 {
		   diffSprite.visible = true;
		 }
	   }
	 }
 
	 if (change != 0 || force)
	 {
	   // Update the song capsules to reflect the new difficulty info.
	   for (songCapsule in grpCapsules.members)
	   {
		 if (songCapsule == null) continue;
		 if (songCapsule.songData != null)
		 {
		   //songCapsule.songData.currentDifficulty = currentDifficulty;
		   songCapsule.init(null, null, songCapsule.songData);
		 }
		 else
		 {
		   songCapsule.init(null, null, null);
		 }
	   }
	 }
 
	 // Set the album graphic and play the animation if relevant.
	 /*var newAlbumId:String = (daSong != null) ? daSong.albumId : null;
	 if (albumRoll.albumId != newAlbumId)
	 {
	   albumRoll.albumId = newAlbumId;
	   albumRoll.skipIntro();
	 }*/
   }
 
   // Clears the cache of songs, frees up memory, they' ll have to be loaded in later tho function clearDaCache(actualSongTho:String)
   function clearDaCache(actualSongTho:String):Void
   {
	 for (song in songs)
	 {
	   if (song == null) continue;
	   if (song.song != actualSongTho)
	   {
		 trace('trying to remove: ' + song.song);
		 // openfl.Assets.cache.clear(Paths.inst(song.songName));
	   }
	 }
   }
 
   function capsuleOnConfirmRandom(randomCapsule:SongMenuItem):Void
   {
	 trace('RANDOM SELECTED');
 
	 busy = true;
	 letterSort.inputEnabled = false;
 
	 var availableSongCapsules:Array<SongMenuItem> = grpCapsules.members.filter(function(cap:SongMenuItem) {
	   // Dead capsules are ones which were removed from the list when changing filters.
	   return cap.alive && cap.songData != null;
	 });
 
	 trace('Available songs: ${availableSongCapsules.map(function(cap) {
	   return cap.songData.song;
	 })}');
 
	 if (availableSongCapsules.length == 0)
	 {
	   trace('No songs available!');
	   busy = false;
	   letterSort.inputEnabled = true;
	   FlxG.sound.play(Paths.sound('cancelMenu'));
	   return;
	 }
 
	 var targetSong:SongMenuItem = FlxG.random.getObject(availableSongCapsules);
 
	 // Seeing if I can do an animation...
	 curSelected = grpCapsules.members.indexOf(targetSong);
	 changeSelection(0); // Trigger an update.
 
	 // Act like we hit Confirm on that song.
	 capsuleOnConfirmDefault(targetSong);
   }
 
   function capsuleOnConfirmDefault(cap:SongMenuItem):Void
   {
	 busy = true;
	 letterSort.inputEnabled = false;

	 // Visual and audio effects.
	 FlxG.sound.play(Paths.sound('confirmMenu'));
	 dj.confirm();
 
	 new FlxTimer().start(1, function(tmr:FlxTimer) {
		var poop:String = currentDifficulty.formatToPath();
		var song:String = cap.songData.song.formatToPath();
		PlayState.SONG = Song.autoSelectJson(song, poop);
		PlayState.songEvents = SongEvent.loadFromJson(song);

		if (PlayState.songEvents == null)
			PlayState.songEvents = [];

		PlayState.isStoryMode = false;
		PlayState.difficulty = currentDifficulty;

		PlayState.storyWeek = cap.songData.head;
		PlayState.curSongIndex = cap.songData.head.songs.indexOf(cap.songData);
		trace('Week: ' + PlayState.storyWeek.name);
	    LoadingState.loadAndSwitchState(new PlayState());
	 });
   }
 
   function rememberSelection():Void
   {
	 if (rememberedSongId != null)
	 {
		for(song in currentFilteredSongs)
		{
			if(song.song.formatToPath() == rememberedSongId)
			{
				curSelected = currentFilteredSongs.indexOf(song)+1;
				break;
			}
		}
 
	   if (curSelected == -1) curSelected = 0;
	 }
 
	 if (rememberedDifficulty != null)
	 {
	   currentDifficulty = rememberedDifficulty;
	 }
   }
 
   function changeSelection(change:Int = 0):Void
   {
	 FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
 
	 var prevSelected:Int = curSelected;
 
	 curSelected += change;
 
	 if (curSelected < 0) curSelected = grpCapsules.countLiving() - 1;
	 if (curSelected >= grpCapsules.countLiving()) curSelected = 0;
 
	 var daSongCapsule:SongMenuItem = grpCapsules.members[curSelected];
	 if (daSongCapsule.songData != null)
	 {
	   var songScore:Null<Int> = Highscore.getScore(daSongCapsule.songData.song, currentDifficulty);
	   intendedScore = (songScore != null) ? songScore : 0;
	   //intendedCompletion = (songScore != null) ? songScore.accuracy : 0.0;
	   diffIdsCurrent = daSongCapsule.songData.difficulties;
	   rememberedSongId = daSongCapsule.songData.song;
	   changeDiff();
	 }
	 else
	 {
	   intendedScore = 0;
	   intendedCompletion = 0.0;
	   diffIdsCurrent = diffIdsTotal;
	   rememberedSongId = null;
	   rememberedDifficulty = null;
	   // albumRoll.albumId = null;
	 }
 
	 for (index => capsule in grpCapsules.members)
	 {
	   index += 1;
 
	   capsule.selected = index == curSelected + 1;
 
	   capsule.targetPos.y = capsule.intendedY(index - curSelected);
	   capsule.targetPos.x = 270 + (60 * (Math.sin(index - curSelected)));
 
	   if (index < curSelected) capsule.targetPos.y -= 100; // another 100 for good measure
	 }
 
	 if (grpCapsules.countLiving() > 0)
	 {
	   if (curSelected == 0)
	   {
		if(FlxG.sound.music != null) 
			FlxG.sound.music.pause();

		 Conductor.bpm = 145;

		 randomSong.play();
		 randomSong.fadeIn(2, 0, 0.8);
	   }
	   else
	   {
		 if(randomSong.playing)
		 {
			FlxG.sound.music.resume();

			Conductor.bpm = TitleState.introText.bpm;

			randomSong.pause();
		 	FlxG.sound.music.fadeIn(2, 0, 0.8);
		 }
		 /*// TODO: Stream the instrumental of the selected song?
		 var didReplace:Bool = FunkinSound.playMusic('freakyMenu',
		   {
			 startingVolume: 0.0,
			 overrideExisting: true,
			 restartTrack: false
		   });
		 if (didReplace)
		 {
		   FunkinSound.playMusic('freakyMenu',
			 {
			   startingVolume: 0.0,
			   overrideExisting: true,
			   restartTrack: false
			 });
		   FlxG.sound.music.fadeIn(2, 0, 0.8);
		 }*/
	   }
	   grpCapsules.members[curSelected].selected = true;
	 }
   }

   override public function beatHit()
   {
   	dj.dance();
   }
 
   /**
	* Build an instance of `FreeplayState` that is above the `MainMenuState`.
	* @return The MainMenuState with the FreeplayState as a substate.
	*/
   /*public static function build(?params:FreeplayStateParams, ?stickers:StickerSubState):MusicBeatState
   {
	 var result = new MainMenuState();
 
	 result.openSubState(new FreeplayState(params, stickers));
	 result.persistentUpdate = false;
	 result.persistentDraw = true;
	 return result;
   }*/
 }
 
 /**
  * The difficulty selector arrows to the left and right of the difficulty.
  */
 class DifficultySelector extends FlxSprite
 {
   var controls:Controls;
   var whiteShader:PureColor;
 
   public function new(x:Float, y:Float, flipped:Bool, controls:Controls)
   {
	 super(x, y);
 
	 this.controls = controls;
 
	 frames = Paths.getSparrowAtlas('freeplay/freeplaySelector');
	 animation.addByPrefix('shine', 'arrow pointer loop', 24);
	 animation.play('shine');
 
	 whiteShader = new PureColor(FlxColor.WHITE);
 
	 shader = whiteShader;
 
	 flipX = flipped;
   }
 
   override function update(elapsed:Float):Void
   {
	 if (flipX && controls.UI_RIGHT_P && !FlxG.keys.pressed.CONTROL) moveShitDown();
	 if (!flipX && controls.UI_LEFT_P && !FlxG.keys.pressed.CONTROL) moveShitDown();
 
	 super.update(elapsed);
   }
 
   function moveShitDown():Void
   {
	 offset.y -= 5;
 
	 whiteShader.colorSet = true;
 
	 scale.x = scale.y = 0.5;
 
	 new FlxTimer().start(2 / 24, function(tmr) {
	   scale.x = scale.y = 1;
	   whiteShader.colorSet = false;
	   updateHitbox();
	 });
   }
 }
 
 /**
  * Structure for the current song filter.
  */
 typedef SongFilter =
 {
   var filterType:FilterType;
   var ?filterData:Dynamic;
 }
 
 /**
  * Possible types to use for the song filter.
  */
 enum abstract FilterType(String)
 {
   /**
	* Filter to songs which start with a string
	*/
   public var STARTSWITH;
 
   /**
	* Filter to songs which match a regular expression
	*/
   public var REGEXP;
 
   /**
	* Filter to all songs
	*/
   public var ALL;
 }
 
 /**
  * The map storing information about the exit movers.
  */
 typedef ExitMoverData = Map<Array<FlxSprite>, MoveData>;
 
 /**
  * The data for an exit mover.
  */
 typedef MoveData =
 {
   var ?x:Float;
   var ?y:Float;
   var ?speed:Float;
   var ?wait:Float;
 }
 
 /**
  * The sprite for the difficulty
  */
 class DifficultySprite extends FlxSprite
 {
   /**
	* The difficulty id which this sprite represents.
	*/
   public var difficultyId:String;
 
   public function new(diffId:String)
   {
	 super();
 
	 difficultyId = diffId;
 
	 if (Paths.exists('images/freeplay/freeplay${diffId.formatToPath()}.xml', TEXT))
	 {
	   this.frames = Paths.getSparrowAtlas('freeplay/freeplay${diffId.formatToPath()}');
	   this.animation.addByPrefix('idle', 'idle0', 24, true);
	   if (ChillSettings.get('flashingLights', DISPLAY)) this.animation.play('idle');
	 }
	 else
	 {
	   this.loadGraphic(Paths.image('freeplay/freeplay' + diffId.formatToPath()));
	 }
   }
}

class LetterSort extends FlxTypedSpriteGroup<FlxSprite>
{
  public var letters:Array<FreeplayLetter> = [];

  // starts at 2, cuz that's the middle letter on start (accounting for fav and #, it should begin at ALL filter)
  var curSelection:Int = 1;

  public var changeSelectionCallback:String->Void;

  var leftArrow:FlxSprite;
  var rightArrow:FlxSprite;
  var grpSeperators:Array<FlxSprite> = [];

  public var inputEnabled:Bool = true;

  public function new(x, y)
  {
    super(x, y);

    leftArrow = new FlxSprite(-20, 15).loadGraphic(Paths.image("freeplay/miniArrow"));
    // leftArrow.animation.play("arrow");
    leftArrow.flipX = true;
    add(leftArrow);

    for (i in 0...5)
    {
      var letter:FreeplayLetter = new FreeplayLetter(i * 80, 0, i);
      letter.x += 50;
      letter.y += 50;
      // letter.visible = false;
      add(letter);

      letters.push(letter);

      if (i != 2) letter.scale.x = letter.scale.y = 0.8;

      var darkness:Float = Math.abs(i - 2) / 6;

      letter.color = letter.color.getDarkened(darkness);

      // don't put the last seperator
      if (i == 4) continue;

      var sep:FlxSprite = new FlxSprite((i * 80) + 60, 20).loadGraphic(Paths.image("freeplay/seperator"));
      // sep.animation.play("seperator");
      sep.color = letter.color.getDarkened(darkness);
      add(sep);

      grpSeperators.push(sep);
    }

    rightArrow = new FlxSprite(380, 15).loadGraphic(Paths.image("freeplay/miniArrow"));

    // rightArrow.animation.play("arrow");
    add(rightArrow);

    changeSelection(0);
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (inputEnabled)
    {
      if (FlxG.keys.justPressed.E) changeSelection(1);
      if (FlxG.keys.justPressed.Q) changeSelection(-1);
    }
  }

  public function changeSelection(diff:Int = 0):Void
  {
    doLetterChangeAnims(diff);

    var multiPosOrNeg:Float = diff > 0 ? 1 : -1;

    // if we're moving left (diff < 0), we want control of the right arrow, and vice versa
    var arrowToMove:FlxSprite = diff < 0 ? leftArrow : rightArrow;
    arrowToMove.offset.x = 3 * multiPosOrNeg;

    new FlxTimer().start(2 / 24, function(_) {
      arrowToMove.offset.x = 0;
    });
  }

  /**
   * Buncho timers and stuff to move the letters and seperators
   * Seperated out so we can call it again on letters with songs within them
   * @param diff
   */
  function doLetterChangeAnims(diff:Int):Void
  {
    var ezTimer:Int->FlxSprite->Float->Void = function(frameNum:Int, spr:FlxSprite, offsetNum:Float) {
      new FlxTimer().start(frameNum / 24, function(_) {
        spr.offset.x = offsetNum;
      });
    };

    var positions:Array<Float> = [-10, -22, 2, 0];

    // if we're moving left, we want to move the positions the same amount, but negative direciton
    var multiPosOrNeg:Float = diff > 0 ? 1 : -1;

    for (sep in grpSeperators)
    {
      ezTimer(0, sep, positions[0] * multiPosOrNeg);
      ezTimer(1, sep, positions[1] * multiPosOrNeg);
      ezTimer(2, sep, positions[2] * multiPosOrNeg);
      ezTimer(3, sep, positions[3] * multiPosOrNeg);
    }

    for (index => letter in letters)
    {
      letter.offset.x = positions[0] * multiPosOrNeg;

      new FlxTimer().start(1 / 24, function(_) {
        letter.offset.x = positions[1] * multiPosOrNeg;
        if (index == 0) letter.visible = false;
      });

      new FlxTimer().start(2 / 24, function(_) {
        letter.offset.x = positions[2] * multiPosOrNeg;
        if (index == 0.) letter.visible = true;
      });

      if (index == 2)
      {
        ezTimer(3, letter, 0);
        // letter.offset.x = 0;
        continue;
      }

      ezTimer(3, letter, positions[3] * multiPosOrNeg);
    }

    curSelection += diff;
    if (curSelection < 0) curSelection = letters[0].regexLetters.length - 1;
    if (curSelection >= letters[0].regexLetters.length) curSelection = 0;

    for (letter in letters)
      letter.changeLetter(diff, curSelection+1);

    if (changeSelectionCallback != null) changeSelectionCallback(letters[2].regexLetters[letters[2].curLetter]); // bullshit and long lol!
  }
}

/**
 * The actual FlxAnimate for the letters, with their animation code stuff and regex stuff
 */
class FreeplayLetter extends flxanimate.FlxAnimate
{
  /**
   * A preformatted array of letter strings, for use when doing regex
   * ex: ['A-B', 'C-D', 'E-H', 'I-L' ...]
   */
  public var regexLetters:Array<String> = [];

  /**
   * A preformatted array of the letters, for use when accessing symbol animation info
   * ex: ['AB', 'CD', 'EH', 'IL' ...]
   */
  public var animLetters:Array<String> = [];

  /**
   * The current letter in the regexLetters array this FreeplayLetter is on
   */
  public var curLetter:Int = 0;

  public function new(x:Float, y:Float, ?letterInd:Int)
  {
    super(x, y, Paths.atlas("freeplay/sortedLetters", 'preload'));

    // this is used for the regex
    // /^[OR].*/gi doesn't work for showing the song Pico, so now it's
    // /^[O-R].*/gi ant it works for displaying Pico
    // https://regex101.com/r/bWFPfS/1
    // we split by underscores, simply for nice lil convinience
    var alphabet:String = 'A-B_C-D_E-H_I-L_M-N_O-R_S_T_U-Z';
    regexLetters = alphabet.split('_');
    regexLetters.insert(0, 'ALL');
    // regexLetters.insert(0, 'fav');
    regexLetters.insert(0, '#');

    // the symbols from flash don't have dashes, so we clean this up for use with animations
    // (we don't need to re-export, rule of thumb is to accomodate files named in flash from dave
    //    until we get him programming classes (and since i cant find the .fla file....))
    animLetters = regexLetters.map(animLetter -> animLetter.replace('-', ''));

    if (letterInd != null)
    {
      this.anim.play(animLetters[letterInd] + " move");
      this.anim.pause();
      curLetter = letterInd;
    }
  }

  /**
   * Changes the letter graphic/anim, used in the LetterSort class above
   * @param diff -1 or 1, to go left or right in the animation array
   * @param curSelection what the current letter selection is, to play the bouncing anim if it matches the current letter
   */
  public function changeLetter(diff:Int = 0, ?curSelection:Int):Void
  {
    curLetter += diff;

    if (curLetter < 0) curLetter = regexLetters.length - 1;
    if (curLetter >= regexLetters.length) curLetter = 0;

    var animName:String = animLetters[curLetter] + ' move';

    switch (animLetters[curLetter])
    {
      case "IL":
        animName = "IL move";
      case "s":
        animName = "S move";
      case "t":
        animName = "T move";
    }

    this.anim.play(animName);
    if (curSelection != curLetter)
    {
      this.anim.pause();
    }
    // updateHitbox();
  }
}

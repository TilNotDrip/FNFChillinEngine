package states;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;

import flixel.graphics.FlxGraphic;

import flixel.input.gamepad.FlxGamepad;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;

import haxe.Json;

import openfl.Assets;

import shaders.BuildingShaders;
import shaders.ColorSwap;

#if desktop
import sys.FileSystem;
import sys.io.File;
import sys.thread.Thread;
#end

typedef TitleNico = //heheheheehehehehehe
{
	var bpm:Float;
	var sprites:Array<{
		var id:String;
		var pos:Array<Float>;
		@:optional var scale:Array<Float>;
		var path:String;
		var animations:Array<{
			var name:String;
			var anim:String;
			var loop:Bool;
			@:optional var indices:Array<Int>;
			var fps:Int;
		}>;
		@:optional var titleSpr:Bool;
	}>;
	var titleText:Array<{
		var text:String;
		var beat:Int;
		@:optional var showSprite:String;
		@:optional var useIntroText:Bool;
		var removeSelected:Bool;
	}>;
	var introText:{path:String, lines:Int};
}

class TitleState extends MusicBeatState
{
	public static var initialized:Bool = false;
	var startedIntro:Bool;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var textGroup:FlxGroup;

	var curWacky:Array<String> = [];
	var wackyImage:FlxSprite;
	var lastBeat:Int = 0;
	var swagShader:ColorSwap;
	var alphaShader:BuildingShaders;
	var thingie:FlxSprite;

	var introText:TitleNico;
	var introTextSprites:Map<String, FlxSprite> = new Map();

	var idleBoppers:Array<FlxSprite> = [];
	var idleDancers:Array<FlxSprite> = [];
	var pressDancers:Array<FlxSprite> = [];
	
	var titleSprites:FlxTypedGroup<FlxSprite>;

	override public function create():Void
	{
		startedIntro = false;

		FlxG.game.focusLostFramerate = 60;

		swagShader = new ColorSwap();
		alphaShader = new BuildingShaders();

		FlxG.sound.muteKeys = [ZERO];

		introText = cast Json.parse(Assets.getText(Paths.json('title')).trim());

		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');
		PreferencesMenu.initPrefs();
		PlayerSettings.init();
		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});

		#if discord_rpc
		DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end
	}

	var danceLeft:Bool = false;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		}

		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(introText.bpm);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		generateJsonSprites();

		curWacky = getIntroTextShit();

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		add(titleSprites);

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		startedIntro = true;
	}

	function getIntroTextShit():Array<String>
	{
		var fullText:String = Assets.getText(Paths.txt(introText.introText.path));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return FlxG.random.getObject(swagGoodArray);
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new CutsceneAnimTestState());
		#end

		if (FlxG.keys.justPressed.R) {
			initialized = false;
			FlxG.resetGame();
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.justPressed.F)
			FlxG.fullscreen = !FlxG.fullscreen;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				pressedEnter = true;
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			if (FlxG.sound.music != null)
				FlxG.sound.music.onComplete = null;
			for(i in pressDancers) {
				i.animation.play('press', true);
				idleDancers.remove(i);
				idleBoppers.remove(i);
			}

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;

			new FlxTimer().start(1, function(tmr:FlxTimer) {
				FlxG.switchState(new MainMenuState());
			});
		}

		if (pressedEnter && !skippedIntro && initialized)
			skipIntro();

		if (controls.UI_LEFT)
			swagShader.update(-elapsed * 0.1);

		if (controls.UI_RIGHT)
			swagShader.update(elapsed * 0.1);

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	var curCurWacky:Int = 0;
	var curText:String = '';
	override function beatHit()
	{
		super.beatHit();

		if (!startedIntro)
			return ;

		if (skippedIntro)
		{
			for(i in idleBoppers) i.animation.play('idle', true);

			danceLeft = !danceLeft;

			for(i in idleDancers) {
				if (danceLeft)
					i.animation.play('danceRight');
				else
					i.animation.play('danceLeft');
			}
		}
		else
		{
			// if the user is draggin the window some beats will
			// be missed so this is just to compensate
			if (curBeat > lastBeat)
			{
				for (i in lastBeat...curBeat)
				{
					trace(curCurWacky);
					for(beatThing in introText.titleText) {
						if(beatThing.beat == i + 1) {
							if(beatThing.useIntroText && !beatThing.removeSelected) {
								if(curCurWacky != 0) {
									addMoreText(curWacky[curCurWacky]);
									trace('addin ' + curWacky[curCurWacky]);
								} else {
									createCoolText([curWacky[curCurWacky]]);
									trace('creatin ' + curWacky[curCurWacky]);
								}

								curText = '';
								curCurWacky++;
								
								trace(curCurWacky);

								if(curCurWacky == introText.introText.lines) curCurWacky = 0;
							} if(beatThing.useIntroText && beatThing.removeSelected) {
								deleteCoolText();
							}

							if(!beatThing.removeSelected && !beatThing.useIntroText) {
								if(curText == '')
									createCoolText(beatThing.text.split('\n'));
								else {
									var daText:Array<String> = beatThing.text.split('\n');
									for(j in curText.split('\n')) daText.remove(j);
									for(j in daText) addMoreText(j);
								}
								curText = beatThing.text;
							} if(beatThing.removeSelected && !beatThing.useIntroText) {
								curText.replace(beatThing.text, '');
								deleteCoolText();
								if(curText.split('\n') == []) createCoolText(curText.split('\n'));
							}

							if(beatThing.showSprite != null)
								introTextSprites[beatThing.showSprite].visible = !beatThing.removeSelected;

							if(beatThing == introText.titleText[introText.titleText.length-1]) skipIntro();
						}
					}
				}
			}
			lastBeat = curBeat;
		}
	}

	function generateJsonSprites()
	{
		introTextSprites = new Map();
		idleDancers = [];
		idleBoppers = [];
		pressDancers = [];

		titleSprites = new FlxTypedGroup<FlxSprite>();

		for(jsonSpr in introText.sprites) {
			var daSprite:FlxSprite = new FlxSprite(jsonSpr.pos[0], jsonSpr.pos[1]);
			if(jsonSpr.scale != null) daSprite.scale.set(jsonSpr.scale[0], jsonSpr.scale[1]);

			if(jsonSpr.animations == null)
				daSprite.loadGraphic(Paths.image(jsonSpr.path));
			else
				daSprite.frames = Paths.getSparrowAtlas(jsonSpr.path);

			if(jsonSpr.animations != null) {
				for(jsonAnim in jsonSpr.animations) {
					if(jsonAnim.indices != null)
						daSprite.animation.addByIndices(jsonAnim.name, jsonAnim.anim, jsonAnim.indices, '', jsonAnim.fps, jsonAnim.loop);
					else
						daSprite.animation.addByPrefix(jsonAnim.name, jsonAnim.anim, jsonAnim.fps, jsonAnim.loop);
	
					if(jsonAnim.name.contains('dance'))
						idleDancers.push(daSprite);
					else if(jsonAnim.name.contains('idle'))
						idleBoppers.push(daSprite);
	
					if(jsonAnim.name.contains('press')) // if your anim name is press, you will play an animation when enter is pressed!
						pressDancers.push(daSprite);
				}
				daSprite.animation.play(jsonSpr.animations[0].name);
			}

			daSprite.visible = !jsonSpr.titleSpr;
	
			introTextSprites.set(jsonSpr.id, daSprite);
			
			if(!jsonSpr.titleSpr)
				add(daSprite);
			else
				titleSprites.add(daSprite);
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(titleSprites);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}

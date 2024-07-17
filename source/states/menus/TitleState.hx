package states.menus;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import haxe.Json;
import openfl.Assets;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import shaders.ColorSwap;
#if sys
import sys.FileSystem;
import sys.io.File;
import sys.thread.Thread;
#end

typedef TitleJSON =
{
	var bpm:Float;
	var sprites:Array<
		{
			var id:String;
			var pos:Array<Float>;
			@:optional var scale:Array<Float>;
			var path:String;
			var animations:Array<
				{
					var name:String;
					var anim:String;
					var loop:Bool;
					@:optional var indices:Array<Int>;
					var fps:Int;
				}>;
			@:optional var screenCenter:String;
			@:optional var updateHitbox:Bool;
			@:optional var titleSpr:Bool;
		}>;
	var titleText:Array<
		{
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

	private var startedIntro:Bool;

	private var blackScreen:FlxSprite;
	private var credGroup:FlxGroup;
	private var textGroup:FlxGroup;

	private var curWacky:Array<String> = [];
	private var lastBeat:Int = 0;

	public static var introText:TitleJSON;

	private var introTextSprites:Map<String, FlxSprite> = new Map();

	private var camFilters:Array<BitmapFilter> = [];
	private var swagShader:ColorSwap;

	private var idleBoppers:Array<FlxSprite> = [];
	private var idleDancers:Array<FlxSprite> = [];
	private var pressDancers:Array<FlxSprite> = [];

	private var titleSprites:FlxTypedGroup<FlxSprite>;

	override public function create():Void
	{
		changeWindowName('Title Screen');

		#if DISCORD
		DiscordRPC.details = 'Title Screen';
		DiscordRPC.partyId = 'yes';
		DiscordRPC.partySize = 1;
		DiscordRPC.partyMax = 2;
		DiscordRPC.joinSecret = 'abc';
		#end

		#if MOD_SUPPORT
		HScript.init();
		Module.init();
		#end

		if (introText == null)
			introText = cast Json.parse(Assets.getText(Paths.json('title')).trim());

		startedIntro = false;

		super.create();

		swagShader = new ColorSwap();
		camFilters.push(new ShaderFilter(swagShader.shader));
		FlxG.camera.filters = camFilters;

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
	}

	private var danceLeft:Bool = false;

	private function startIntro()
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

		Conductor.bpm = introText.bpm;
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

		if (FlxG.mouse.visible)
			FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		startedIntro = true;
	}

	private function getIntroTextShit():Array<String>
	{
		var fullText:String = Assets.getText(Paths.txt(introText.introText.path));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
			swagGoodArray.push(i.split('--'));

		return FlxG.random.getObject(swagGoodArray);
	}

	private var transitioning:Bool = false;

	private var easterEggActive:Bool = false;
	private var curEasterPos:Int = 0;
	private var easterArray:Array<FlxKey> = [LEFT, RIGHT, LEFT, RIGHT, UP, DOWN, UP, DOWN];

	private var windowMoving:Bool = false;

	override public function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

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

			for (i in pressDancers)
			{
				i.animation.play('press', true);
				idleDancers.remove(i);
				idleBoppers.remove(i);
			}

			if (ChillSettings.get('flashingLights'))
				FlxG.camera.flash(FlxColor.WHITE, 1);

			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				FlxG.switchState(new MainMenuState());

				if (easterEggActive)
					FlxG.sound.music.stop();
			});
		}

		if (pressedEnter && !skippedIntro && initialized)
			skipIntro();

		if (FlxG.keys.justPressed.Y && !windowMoving)
		{
			FlxTween.tween(Application.current.window, {x: Application.current.window.x + 300}, 1.4, {ease: FlxEase.quadInOut, type: 4, startDelay: 0.35});
			FlxTween.tween(Application.current.window, {y: Application.current.window.y + 100}, 0.7, {ease: FlxEase.quadInOut, type: 4});

			windowMoving = true;
		}

		/*if(FlxG.keys.justPressed.T)
			{
				FunkinServer.hostServer('0.0.0.0', 8000);

				FunkinServer.onEvent.add(function(event) {
					trace('event! ' + event.event + ', ' + event.params);
					FunkinServer.addEvent('testing', ['callback event', 'from server']);
				});
			}

			if(FlxG.keys.justPressed.U)
			{
				FunkinServer.joinServer('127.0.0.1', 8000);

				FunkinServer.onEvent.add(function(event) {
					trace('event! ' + event.event + ', ' + event.params);
				});

				FunkinServer.addEvent('testing', ['initial event', 'from client']);
		}*/

		if (!easterEggActive && skippedIntro)
			checkEasterCode();

		super.update(elapsed);
	}

	private function checkEasterCode()
	{
		if (FlxG.keys.justPressed.ANY)
		{
			if (controls.UI_LEFT_P || controls.NOTE_LEFT_P)
				codePress(LEFT);

			if (controls.UI_DOWN_P || controls.NOTE_DOWN_P)
				codePress(DOWN);

			if (controls.UI_UP_P || controls.NOTE_UP_P)
				codePress(UP);

			if (controls.UI_RIGHT_P || controls.NOTE_RIGHT_P)
				codePress(RIGHT);
		}
	}

	private function codePress(input:FlxKey)
	{
		if (input == easterArray[curEasterPos])
		{
			curEasterPos += 1;

			if (curEasterPos >= easterArray.length)
				startEasterEgg();
		}
		else
			curEasterPos = 0;
	}

	private function startEasterEgg()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7, false, null, true, function()
		{
			easterEggActive = true;
			FlxG.sound.playMusic(Paths.music('girlfriendsRingtone'));
			Conductor.bpm = 190;
			Conductor.songPosition = 0;
		});

		if (ChillSettings.get('flashingLights'))
			FlxG.camera.flash(FlxColor.WHITE, 1);
	}

	private function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], BOLD);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	private function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, BOLD);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	private function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var curCurWacky:Int = 0;
	private var curText:String = '';

	override public function beatHit()
	{
		super.beatHit();

		if (!startedIntro)
			return;

		if (skippedIntro)
		{
			for (i in idleBoppers)
				i.animation.play('idle', true);

			danceLeft = !danceLeft;

			for (i in idleDancers)
			{
				if (danceLeft)
					i.animation.play('danceRight');
				else
					i.animation.play('danceLeft');
			}

			if (easterEggActive && Conductor.curBeat % 2 == 0)
				swagShader.update(0.125);
		}
		else
		{
			// if the user is draggin the window some beats will
			// be missed so this is just to compensate
			if (Conductor.curBeat > lastBeat)
			{
				for (i in lastBeat...Conductor.curBeat)
				{
					for (beatThing in introText.titleText)
					{
						if (beatThing.beat == i + 1)
						{
							if (beatThing.useIntroText && !beatThing.removeSelected)
							{
								if (curCurWacky != 0)
									addMoreText(curWacky[curCurWacky]);
								else
									createCoolText([curWacky[curCurWacky]]);

								curText = '';
								curCurWacky++;

								if (curCurWacky == introText.introText.lines)
									curCurWacky = 0;
							}

							if (beatThing.useIntroText && beatThing.removeSelected)
								deleteCoolText();

							if (!beatThing.removeSelected && !beatThing.useIntroText)
							{
								if (curText == '')
									createCoolText(beatThing.text.split('\n'));
								else
								{
									var daText:Array<String> = beatThing.text.split('\n');
									for (j in curText.split('\n'))
										daText.remove(j);
									for (j in daText)
										addMoreText(j);
								}

								curText = beatThing.text;
							}

							if (beatThing.removeSelected && !beatThing.useIntroText)
							{
								curText.replace(beatThing.text, '');
								deleteCoolText();
								if (curText.split('\n') == [])
									createCoolText(curText.split('\n'));
							}

							if (beatThing.showSprite != null)
								introTextSprites[beatThing.showSprite].visible = !beatThing.removeSelected;

							if (beatThing == introText.titleText[introText.titleText.length - 1])
								skipIntro();
						}
					}
				}
			}
			lastBeat = Conductor.curBeat;
		}
	}

	private function generateJsonSprites()
	{
		introTextSprites = new Map();
		idleDancers = [];
		idleBoppers = [];
		pressDancers = [];

		titleSprites = new FlxTypedGroup<FlxSprite>();

		for (jsonSpr in introText.sprites)
		{
			var daSprite:FlxSprite = new FlxSprite(jsonSpr.pos[0], jsonSpr.pos[1]);

			if (jsonSpr.animations == null)
				daSprite.loadGraphic(Paths.image(jsonSpr.path));
			else
				daSprite.frames = Paths.getSparrowAtlas(jsonSpr.path);

			if (jsonSpr.animations != null)
			{
				for (jsonAnim in jsonSpr.animations)
				{
					if (jsonAnim.indices != null)
						daSprite.animation.addByIndices(jsonAnim.name, jsonAnim.anim, jsonAnim.indices, '', jsonAnim.fps, jsonAnim.loop);
					else
						daSprite.animation.addByPrefix(jsonAnim.name, jsonAnim.anim, jsonAnim.fps, jsonAnim.loop);

					if (jsonAnim.name.startsWith('dance'))
						idleDancers.push(daSprite);
					else if (jsonAnim.name.contains('idle'))
						idleBoppers.push(daSprite);

					if (jsonAnim.name.contains('press')) // if your anim name is press, you will play an animation when enter is pressed!
						pressDancers.push(daSprite);
				}

				daSprite.animation.play(jsonSpr.animations[0].name);
			}

			if (jsonSpr.scale != null)
				daSprite.scale.set(jsonSpr.scale[0], jsonSpr.scale[1]);
			if (jsonSpr.updateHitbox != null && jsonSpr.updateHitbox == true)
				daSprite.updateHitbox();

			if (jsonSpr.screenCenter != null)
			{
				switch (jsonSpr.screenCenter.formatToPath())
				{
					case 'x':
						daSprite.screenCenter(X);
					case 'y':
						daSprite.screenCenter(Y);
					case 'xy' | 'yx':
						daSprite.screenCenter(XY);
				}
			}

			daSprite.visible = !jsonSpr.titleSpr;

			introTextSprites.set(jsonSpr.id, daSprite);

			if (!jsonSpr.titleSpr)
				add(daSprite);
			else
				titleSprites.add(daSprite);
		}
	}

	private var skippedIntro:Bool = false;

	private function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(titleSprites);

			if (ChillSettings.get('flashingLights'))
				FlxG.camera.flash(FlxColor.WHITE, 1);

			remove(credGroup);
			skippedIntro = true;
		}
	}
}

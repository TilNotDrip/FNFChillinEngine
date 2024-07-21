package;

#if sys
import display.FunkinWindowBar;
#end
import display.FunkinSoundtray.FunkinSoundTray;
import display.FPS;
import flixel.FlxGame;
import flixel.system.ui.FlxSoundTray;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

#if (cpp && windows)
@:cppFileCode('
#include <iostream>
#include <windows.h>
#include <psapi.h>
')
#end
class Main extends Sprite
{
	var game = {
		width: 1280,
		height: 720,
		state: states.menus.TitleState,
		framerate: 60,
		splash: true,
		fullscreen: false
	};

	public static var aprilFools(get, never):Bool;

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new():Void
	{
		super();

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

		setupGame();
	}

	var overlay:Sprite;

	// TODO: run shutdown -r -t 0 to test out safe mode
	public static var fpsCounter:FPS;

	// public static var titleBar:FunkinWindowBar;

	function setupGame():Void
	{
		var funkinGame:FlxGame = new FlxGame(game.width, game.height, game.state, game.framerate, game.framerate, game.splash, game.fullscreen);

		@:privateAccess
		funkinGame._customSoundTray = FunkinSoundTray;
		initSaves();

		addChild(funkinGame);

		#if FUNKIN_MOD_SUPPORT
		ModHandler.initializeMods();
		HScript.init();
		Module.init();
		#end

		/*titleBar = new FunkinWindowBar();
			addChild(titleBar); */

		initGame();

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		#end
	}

	function initSaves():Void
	{
		ChillSettings.loadSettings();
		PlayerSettings.init();
		Highscore.load();
	}

	function initGame():Void
	{
		#if (cpp && windows)
		// This disables the "Report to Microsoft" popup when the game stops responding.
		untyped __cpp__('SetErrorMode(SEM_FAILCRITICALERRORS | SEM_NOGPFAULTERRORBOX);');
		#end

		FlxG.debugger.setLayout(MICRO);
		FlxG.game.focusLostFramerate = 30;
		FlxG.sound.muteKeys = [ZERO];

		FlxG.scaleMode = new flixel.system.scaleModes.FixedScaleAdjustSizeScaleMode();

		/*FlxG.signals.postUpdate.add(function() {
			FlxG.game.y = 32;
		});*/

		// Lib.application.window.borderless = true;

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.initialize();
		#end
	}

	static var curDate = Date.now();

	static function get_aprilFools():Bool
	{
		return (curDate.getDate() == 1 && curDate.getMonth() == 4);
	}
}

package;

import display.FunkinSoundtray.FunkinSoundTray;
import display.FPS;

import flixel.FlxGame;

import flixel.system.ui.FlxSoundTray;

import openfl.Lib;

import openfl.display.Sprite;

import openfl.events.Event;

import states.menus.TitleState;

class Main extends Sprite
{
	private var game = {
		width: 1280,
		height: 720,
		state: TitleState,
		framerate: 60,
		splash: true,
		fullscreen: false
	};

	public static var aprilFools(get, never):Bool;

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

		setupGame();
	}

	private var overlay:Sprite;

	// TODO: run shutdown -r -t 0 to test out safe mode

	public static var fpsCounter:FPS;

	private function setupGame():Void
	{
		var flxGame:FunkinGame = new FunkinGame(game.width, game.height, game.state, game.framerate, game.framerate, game.splash, game.fullscreen);
		addChild(flxGame);

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		#end

		initGame();
	}

	private function initGame()
	{
		ChillSettings.loadSettings();
		PlayerSettings.init();
		Highscore.load();

		FlxG.debugger.setLayout(MICRO);
		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = [ZERO];

		#if DISCORD
		DiscordRPC.initialize();
		#end
	}

	private static var curDate = Date.now();

	private static function get_aprilFools():Bool
	{
		var isToday:Bool;

		if (curDate.getDate() == 1 && curDate.getMonth() == 4)
			isToday = true;
		else
			isToday = false;

		return isToday;
	}
}

/**
 * Overrided FlxGame
 */
class FunkinGame extends FlxGame
{
    override public function new(gameWidth = 0, gameHeight = 0, ?initialState:flixel.util.typeLimit.NextState.InitialState, updateFramerate = 60, drawFramerate = 60, skipSplash = false, startFullscreen = false)
    {
        super(gameWidth, gameHeight, initialState, updateFramerate, drawFramerate, skipSplash, startFullscreen);

		_customSoundTray = FunkinSoundTray;
    }
}
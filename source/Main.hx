package;

import display.FPS;

import flixel.FlxGame;

import openfl.Lib;

import openfl.display.Sprite;

import openfl.events.Event;

import states.menus.TitleState;

class Main extends Sprite
{
	private var gameWidth:Int = 1280;
	private var gameHeight:Int = 720;
	private var initialState:Class<FlxState> = TitleState;
	private var zoom:Float = -1;
	private var framerate:Int = 60;
	private var skipSplash:Bool = true;
	private var startFullscreen:Bool = false;

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
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		addChild(new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		#end

		initData();
	}

	private function initData()
	{
		ChillSettings.loadSettings();
		PlayerSettings.init();
		Highscore.load();

		FlxG.debugger.setLayout(MICRO);
		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = [ZERO];

		#if discord_rpc
		if (ChillSettings.get('discordRPC', OTHER))
			DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end
	}
}
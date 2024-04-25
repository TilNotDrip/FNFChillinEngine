package;

import display.FPS;

import flixel.FlxGame;

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
		addChild(new FlxGame(game.width, game.height, game.state, game.framerate, game.framerate, game.splash, game.fullscreen));

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
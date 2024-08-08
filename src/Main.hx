package;

import funkin.display.FPS;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import funkin.states.menus.TitleState;

class Main extends Sprite
{
	var game = {
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

	function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

		setupGame();
	}

	var overlay:Sprite;

	// TODO: run shutdown -r -t 0 to test out safe mode
	public static var fpsCounter:FPS;

	function setupGame():Void
	{
		addChild(new FlxGame(game.width, game.height, game.state, game.framerate, game.framerate, game.splash, game.fullscreen));

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		#end

		initGame();
	}

	function initGame():Void
	{
		FunkinOptions.loadSettings();
		PlayerSettings.init();
		Highscore.load();

		FlxG.debugger.setLayout(MICRO);
		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = [ZERO];

		// Unfortunately we dont have Angry Birds in Chillin' Engine so we can disable this
		FlxG.fixedTimestep = false;

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

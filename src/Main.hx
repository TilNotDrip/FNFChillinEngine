package;

#if FUNKIN_DISCORD_RPC
import funkin.api.DiscordRPC;
#end
import funkin.data.FunkinControls;
import funkin.data.FunkinHighscore;
import funkin.data.FunkinOptions;
import funkin.display.FPS;
import funkin.display.FunkinSoundTray;
import funkin.states.menus.TitleState;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

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

	public static var fpsCounter:FPS;

	function setupGame():Void
	{
		var funkinGame:FlxGame = new FlxGame(game.width, game.height, game.state, game.framerate, game.framerate, game.splash, game.fullscreen);
		initSaves();
		@:privateAccess
		funkinGame._customSoundTray = FunkinSoundTray;
		addChild(funkinGame);

		initGame();

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		#end
	}

	function initSaves():Void
	{
		FunkinOptions.initialize();
		FunkinControls.init();
		FunkinHighscore.load();
	}

	function initGame():Void
	{
		FlxG.debugger.setLayout(MICRO);
		FlxG.game.focusLostFramerate = 30;
		FlxG.sound.muteKeys = [ZERO];

		// Unfortunately we dont have Angry Birds in Chillin' Engine so we can disable this.
		FlxG.fixedTimestep = false;

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.initialize();
		#end
	}
}

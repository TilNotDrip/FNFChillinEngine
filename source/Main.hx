package;

import display.FPS;
import display.FPSOld;

import flixel.FlxGame;

import openfl.Lib;

import openfl.display.Sprite;

import openfl.events.Event;

class Main extends Sprite
{
	var gameWidth:Int = 1280;
	var gameHeight:Int = 720;
	var initialState:Class<FlxState> = states.TitleState;
	var zoom:Float = -1;
	var framerate:Int = #if web 60 #else 240 #end;
	var skipSplash:Bool = true;
	var startFullscreen:Bool = false;

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private var overlay:Sprite;

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
	}

	/**
	 * please never fucking use this 
	 * lol (yea 𝓕𝓻𝓮𝓪𝓴𝔂GPT)
	 * @param speed How fast you wanna *go*?
	 * @return feel good, or not.
	 */
	public function jerkingOff(speed:Float) //i made this with crusher for no fucking reason lol 🤑🤑🤑🤑🤑🤑🤑🤑🤑🤑(❁´◡`❁)☆*: .｡. o(≧▽≦)o .｡.:*☆(*/ω＼*)(●'◡'●)╰(*°▽°*)╯(^///^)
	{ // stop jerking off crusher 
		new FlxTimer().start(64 / speed, function(tmr:FlxTimer) { // I DONT WANT TO
			cocksexbuttasscock('kum'); // go wild 😏😼
		});
	}

	/**
	 * im boutta KUHJJOnjfrjhkldsahjkfhgjkldsahjkngfdjkl;gjkl;fdaslkhjgfdsjkl,'gmf'j klsd;gh'l;jkmfsdlmkj';gfk;l'sdmk'glm;fsd'kml;b'kl;vcs'k;mlhgsd'kl;mgh'klf;mds'kl;m bvfd'kml;ng'bdfklm;h'mkl;tf'km;lh'gdf
	 * @param what you are about to do
	 * @return Application is not responding.
	 */
	function cocksexbuttasscock(what:String)
	{
		var holdon:String = '';
		for(i in 0...FlxMath.MAX_VALUE_INT) {
			holdon += what.charAt(what.length-1).toUpperCase();
		}
		trace('im bouta ' + what.toUpperCase() + holdon);
	}
}

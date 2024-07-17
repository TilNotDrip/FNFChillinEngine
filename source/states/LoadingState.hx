package states;

import flixel.FlxState;
import haxe.io.Path;
import lime.app.Future;
import lime.app.Promise;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets;

class LoadingState extends MusicBeatState
{
	inline private static var MIN_TIME = 1.0;

	private var target:FlxState;
	private var stopMusic = false;
	private var callbacks:MultiCallback;

	private var danceLeft = false;

	private var loadBar:FlxSprite;
	private var funkay:FlxSprite;

	private static var directory(get, never):String;

	private function new(target:FlxState, stopMusic:Bool)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
	}

	override public function create()
	{
		changeWindowName('Loading...');

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = 'Loading...';
		#end

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFcaff4d);
		add(bg);

		funkay = new FlxSprite();
		funkay.loadGraphic(Paths.content.image('menuUI/funkay'));
		funkay.setGraphicSize(0, FlxG.height);
		funkay.updateHitbox();
		add(funkay);
		funkay.scrollFactor.set();
		funkay.screenCenter();

		loadBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 10, 0xFFff16d2);
		loadBar.screenCenter(X);
		add(loadBar);

		initSongsManifest().onComplete(function(lib)
		{
			callbacks = new MultiCallback(onLoad);
			var introComplete = callbacks.add("introComplete");
			checkLoadSong(getSongPath());

			checkLoadSong(getVocalPath());
			checkLoadSong(getVocalPath(PlayState.SONG.metadata.opponent.split('-')[0].trim()));
			checkLoadSong(getVocalPath(PlayState.SONG.metadata.player.split('-')[0].trim()));

			checkLibrary("shared");
			checkLibrary(directory);

			var fadeTime = 0.5;
			FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
			new FlxTimer().start(fadeTime + MIN_TIME, function(_) introComplete());
		});
	}

	private function checkLoadSong(path:String)
	{
		if (!Assets.exists(path, SOUND))
			return;

		var callback = callbacks.add("song:" + path);
		Assets.loadSound(path).onComplete(function(_)
		{
			callback();
		});
	}

	private function checkLibrary(library:String)
	{
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw "Missing library: " + library;

			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function(_)
			{
				callback();
			});
		}
	}

	override public function beatHit()
	{
		super.beatHit();

		danceLeft = !danceLeft;
	}

	private var targetShit:Float = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		funkay.setGraphicSize(Std.int(FlxMath.lerp(FlxG.width * 0.88, funkay.width, 0.9)));
		funkay.updateHitbox();

		if (controls.ACCEPT)
		{
			funkay.setGraphicSize(Std.int(funkay.width + 60));
			funkay.updateHitbox();
		}

		if (callbacks != null)
		{
			targetShit = FlxMath.remapToRange(callbacks.numRemaining / callbacks.length, 1, 0, 0, 1);

			loadBar.scale.x = FlxMath.lerp(loadBar.scale.x, targetShit, 0.50);
			FlxG.watch.addQuick('percentage?', callbacks.numRemaining / callbacks.length);
		}
	}

	private function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.switchState(target);
	}

	private static function getSongPath()
	{
		return Paths.location.inst(PlayState.SONG.metadata.song);
	}

	private static function getVocalPath(?char:String = "")
	{
		return Paths.location.voices(PlayState.SONG.metadata.song, char);
	}

	inline public static function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		#if NO_PRELOAD_ALL
		FlxG.switchState(getNextState(target, stopMusic));
		#else
		substates.StickerTransition.switchState(getNextState(target, stopMusic));
		// FlxG.state.openSubState(new substates.StickerSubState(getNextState(target, stopMusic)));
		#end
	}

	private static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		Paths.setCurrentLevel(directory);
		#if NO_PRELOAD_ALL
		var loaded = isSoundLoaded(getSongPath()) && (isSoundLoaded(getVocalPath())) && isLibraryLoaded("shared");

		if (!loaded)
			return new LoadingState(target, stopMusic);
		#end
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		return target;
	}

	#if NO_PRELOAD_ALL
	private static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}

	private static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}
	#end

	override public function destroy()
	{
		super.destroy();

		callbacks = null;
	}

	private static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
				rootPath = Path.directory(path);

			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
				promise.error("Cannot open library \"" + id + "\"");
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
				promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}

	private static function get_directory():String
	{
		var dir:String = '';

		switch (PlayState.SONG.metadata.stage)
		{
			case 'spooky':
				dir = 'week2';
			case 'philly':
				dir = 'week3';
			case 'limo':
				dir = 'week4';
			case 'mall':
				dir = 'week5';
			case 'mallEvil':
				dir = 'week5';
			case 'school':
				dir = 'week6';
			case 'schoolEvil':
				dir = 'week6';
			case 'tank':
				dir = 'week7';
			case 'streets':
				dir = 'weekend1';
		}

		return dir;
	}
}

class MultiCallback
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;

	private var unfired = new Map<String, Void->Void>();
	private var fired = new Array<String>();

	public function new(callback:Void->Void, logId:String = null)
	{
		this.callback = callback;
		this.logId = logId;
	}

	public function add(id = "untitled")
	{
		id = '$length:$id';
		length++;
		numRemaining++;

		var func:Void->Void = null;

		func = function()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;

				if (logId != null)
					log('fired $id, $numRemaining remaining');

				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}

	inline private function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}

	public function getFired()
		return fired.copy();

	public function getUnfired()
		return [for (id in unfired.keys()) id];
}

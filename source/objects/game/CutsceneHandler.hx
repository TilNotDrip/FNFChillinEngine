package objects.game;

import flixel.FlxCamera;
import flixel.util.FlxSignal;
#if hxvlc
import hxvlc.flixel.FlxVideoSprite;
#end
import haxe.ds.Map;

// :(
class CutsceneHandler extends MusicBeatSubstate
{
	public var callback:FlxSignal = new FlxSignal();
	public var endTime:Float = 0;

	private var eventMap:Array<EventParams> = [];
	private var videoCutscene:Bool = false;

	public var cutsceneCamera:FlxCamera;
	public var cutsceneSound:FlxSound;

	public function new(cutsceneName:String)
	{
		super();

		cutsceneCamera = new SwagCamera();
		cutsceneCamera.followLerp = 0.04;
		FlxG.cameras.add(cutsceneCamera, false);

		cutsceneSound = new FlxSound();

		FlxG.state.persistentDraw = false;

		callback.add(function()
		{
			close();

			if (cutsceneSound != null)
				cutsceneSound.stop();

			FlxG.state.persistentDraw = true;
		});
	}

	public function startVideo(path:String)
	{
		#if VIDEOS
		videoCutscene = true;

		#if hxvlc
		var video:FlxVideoSprite = new FlxVideoSprite();
		video.bitmap.onEndReached.add(callback.dispatch);
		video.load(Paths.video(path));
		video.play();
		video.setGraphicSize(0, FlxG.height);
		video.updateHitbox();
		video.screenCenter();
		add(video);

		callback.add(function()
		{
			video.stop();
			video.bitmap.dispose();
		});
		#else
		var video:FlxVideo = new FlxVideo(Paths.video(path));
		video.finishCallback = callback.dispatch;
		video.setGraphicSize(0, FlxG.height);
		video.updateHitbox();
		video.screenCenter();
		add(video);

		callback.add(function()
		{
			video.destroy();
		});
		#end
		#else
		FlxG.log.error('Trying to start video, but it\'s disabled! Skipping Cutscene...');
		callback.dispatch();
		#end
	}

	var elapsedTime:Float = 0;
	var timeUntilSkip:Float = 3;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
			timeUntilSkip -= elapsed;
		else
			timeUntilSkip = 3;

		if (timeUntilSkip <= 0)
			callback.dispatch();

		if (videoCutscene)
			return;

		elapsedTime += elapsed;

		for (event in eventMap)
		{
			if (elapsedTime >= event.time)
			{
				var eventSignal:FlxSignal = event.signal;
				eventSignal.dispatch();
				eventMap.remove(event);
			}
		}

		if (elapsedTime >= endTime)
			callback.dispatch();
	}

	public function addEvent(time:Float, functionToCall:Void->Void)
	{
		var eventSignal:EventParams = eventMap.find((event) -> event.time == time);

		if (eventSignal == null)
			eventSignal = {time: time, signal: new FlxSignal()};

		eventSignal.signal.add(functionToCall);

		var index:Int = eventMap.indexOf(eventSignal);

		if (index != -1)
			eventMap[index] = eventSignal;
		else
			eventMap.push(eventSignal);
	}

	override public function add(sprite:flixel.FlxBasic):flixel.FlxBasic
	{
		var returnedSpr:flixel.FlxBasic = super.add(sprite);
		returnedSpr.cameras = [cutsceneCamera];
		return returnedSpr;
	}
}

typedef EventParams =
{
	var time:Float;
	var signal:FlxSignal;
}

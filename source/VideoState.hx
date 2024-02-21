package;

import flixel.FlxG;
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler as VideoHandler;
#else import vlc.VideoHandler; #end

class VideoState extends MusicBeatState
{
	var video:VideoHandler;

	public static var seenVideo:Bool = false;

	override function create()
	{
		super.create();

		seenVideo = true;

		FlxG.save.data.seenVideo = true;
		FlxG.save.flush();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		video = new VideoHandler();

		#if (hxCodec >= "3.0.0")
		// Recent versions
		video.play(Paths.file('music/kickstarterTrailer.mp4'));
		video.onEndReached.add(function()
		{
			video.dispose();
			finishVid();
			return;
		}, true);
		#else
		// Older versions
		video.playVideo(Paths.file('music/kickstarterTrailer.mp4'));
		video.finishCallback = function()
		{
			finishVid();
			return;
		}
		#end
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
			finishVid();

		super.update(elapsed);
	}

	function finishVid():Void
	{
		TitleState.initialized = false;
		FlxG.switchState(new TitleState());
	}
}

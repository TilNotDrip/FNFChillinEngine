package objects;

import openfl.display.BitmapData;
import flixel.FlxBasic;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

// TO BE USED WITH WEB ONLY
class FlxVideo extends FlxSprite
{
	private var video:Video;
	private var netStream:NetStream;

	public var finishCallback:Void->Void;

	public function new(vidSrc:String)
	{
		#if !web
		throw "FlxVideo is only supported on web!";
		#end

		super();

		video = new Video();
		video.x = 0;
		video.y = 0;

		var netConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: client_onMetaData};
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnection_onNetStatus);
		netStream.play(vidSrc);
	}

	override public function update(elapsed:Float)
	{
		var scrn:BitmapData = new BitmapData(video.videoWidth, video.videoHeight, true, 0x00000000);
		scrn.draw(video);

		loadGraphic(scrn);
	}

	public function finishVideo():Void
	{
		netStream.dispose();

		if (finishCallback != null)
			finishCallback();
	}

	public function client_onMetaData(metaData:Dynamic)
	{
		video.attachNetStream(netStream);

		// video.width = FlxG.width;
		// video.height = FlxG.height;
	}

	private function netConnection_onNetStatus(event:NetStatusEvent):Void
	{
		if (event.info.code == 'NetStream.Play.Complete')
			finishVideo();
	}
}

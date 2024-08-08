package funkin.objects;

import flixel.FlxBasic;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

// TO BE USED WITH WEB ONLY
class FlxVideo extends FlxBasic
{
	var video:Video;
	var netStream:NetStream;

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

		FlxG.addChildBelowMouse(video);

		var netConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: client_onMetaData};
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnection_onNetStatus);
		netStream.play(vidSrc);
	}

	public function finishVideo():Void
	{
		netStream.dispose();
		FlxG.removeChild(video);

		if (finishCallback != null)
			finishCallback();
	}

	public function client_onMetaData(metaData:Dynamic)
	{
		video.attachNetStream(netStream);

		video.width = FlxG.width;
		video.height = FlxG.height;
	}

	function netConnection_onNetStatus(event:NetStatusEvent):Void
	{
		if (event.info.code == 'NetStream.Play.Complete')
			finishVideo();
	}
}

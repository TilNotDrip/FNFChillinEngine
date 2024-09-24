package funkin.util;

import flixel.graphics.frames.FlxFrame;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

typedef ImageFramesArrayIndex =
{
	var name:String;
	var graphic:FlxGraphicAsset;
};

class ImageFrames extends FlxFramesCollection
{
	public function new()
	{
		super(null, IMAGE);
	}

	public static function generateFrameCollection(images:Array<ImageFramesArrayIndex>):ImageFrames
	{
		var frameCollection:ImageFrames = new ImageFrames();

		for (source in images)
		{
			var graphic:FlxGraphic = FlxG.bitmap.add(source.graphic, false);
			if (graphic == null)
				continue;

			var frame:FlxFrame = graphic.imageFrame.frame;
			frame.name = source.name;
			frameCollection.pushFrame(frame);
		}

		return frameCollection;
	}

	public static function fromDirectory(directory:String):ImageFrames
	{
		var graphicArray:Array<ImageFramesArrayIndex> = [];

		for (path in Paths.location.list())
		{
			if (!(path.startsWith('images/' + directory + '/') && path.endsWith('.${Constants.EXT_IMAGE}')))
				continue;

			var pathNoDir:String = path.substring('images/$directory/'.length);
			var removingDot:Array<String> = pathNoDir.split('.');
			removingDot.pop();
			pathNoDir = removingDot.join('.');

			graphicArray.push({
				name: pathNoDir,
				graphic: Paths.content.imageGraphic(directory + '/' + pathNoDir)
			});
		}

		return generateFrameCollection(graphicArray);
	}

	public static function isFrameDirectory(directory:String):Bool
	{
		return Paths.location.list().filter(function(path:String)
		{
			return (path.startsWith('images/' + directory + '/') && path.endsWith('.${Constants.EXT_IMAGE}'));
		}).length > 0;
	}
}

package funkin.util.paths;

import openfl.display.BitmapData;
import openfl.system.System;
import haxe.Json;
import openfl.Assets;
import flixel.graphics.FlxGraphic;

/**
 * A Path class for returning content from locations.
 */
class PathContent
{
	/**
	 * The content that doesn't get wiped from a cache clean.
	 *
	 * You should only put something here if you use it on a daily basis.
	 */
	public var clearCacheExcludeKeys:Array<String> = [
		'default:assets/images/fonts/bold.png',
		'default:assets/images/fonts/default.png',
		'default:assets/images/mainmenu/menuBG.png',
		'default:assets/images/mainmenu/menuDesat.png',
		'default:assets/music/freakyMenu.${Constants.EXT_SOUND}'
	];

	var imgGraphicCache:Map<String, FlxGraphic> = new Map();

	public function new() {}

	/**
	 * Returns and also caches a graphic of a image bitmap.
	 * @param key Image File name.
	 * @param library Library the image is in.
	 * @return A BitampData instance of a image.
	 */
	public function imageBitmap(key:String, ?library:String):BitmapData
	{
		var bitmap:BitmapData = null;
		var graphic:FlxGraphic = null;
		var assetKey:String = Paths.location.image(key, library);

		try
		{
			graphic = imageGraphic(key, library);
			bitmap = graphic.bitmap;
		}
		catch (e)
		{
			trace('[WARNING]: Bitmap is null! $assetKey');
			return null;
		}

		return bitmap;
	}

	/**
	 * Returns and also caches a graphic of a image.
	 * @param key Image File name.
	 * @param library Library the image is in.
	 * @return A FlxGraphic instance of a image.
	 */
	public function imageGraphic(key:String, ?library:String):FlxGraphic
	{
		var bitmap:BitmapData = null;
		var graphic:FlxGraphic = null;
		var assetKey:String = Paths.location.image(key, library);

		if (!imgGraphicCache.exists(key))
		{
			try
			{
				bitmap = Assets.getBitmapData(assetKey);
			}
			catch (e)
			{
				trace('[WARNING]: Bitmap is null! $assetKey');
				return null;
			}

			graphic = FlxGraphic.fromBitmapData(bitmap, false, assetKey);
			graphic.persist = true;
			graphic.destroyOnNoUse = false;
			imgGraphicCache.set(assetKey, graphic);
		}
		else
		{
			graphic = imgGraphicCache.get(assetKey);
		}

		return graphic;
	}

	/**
	 * @param key Json File name.
	 * @param library Library the json is in.
	 * @return A Parsed JSON from the text asset in Paths.location.json
	 */
	public function json(key:String, ?library:String, ?trim:Bool = false):Dynamic
	{
		if (trim)
			return Json.parse(Assets.getText(Paths.location.json(key, library)).trim());

		return Json.parse(Assets.getText(Paths.location.json(key, library)));
	}

	/**
	 * @param key Xml File name.
	 * @param library Library the xml is in.
	 * @return A Parsed XML Document from the text asset in Paths.location.xml
	 */
	public function xml(key:String, ?library:String):Xml
	{
		return Xml.parse(Assets.getText(Paths.location.xml(key, library)));
	}

	/**
	 * @param key The image and xml name.
	 * @param library The library the image and xml are located.
	 * @return Sparrow Atlas frames from library:assets/images/key.png&.xml
	 */
	public function sparrowAtlas(key:String, ?library:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(imageGraphic(key, library), xml('images/$key', library));
	}

	/**
	 * Clears the image cache and runs the system garbage collector.
	 */
	public function clearImageCache():Void
	{
		for (graphicKey in imgGraphicCache.keys())
		{
			// Note to self: Don't return in a loop learned that the hard way
			if (!clearCacheExcludeKeys.contains(graphicKey))
			{
				@:privateAccess
				FlxG.bitmap._cache.remove(graphicKey);
				Assets.cache.removeBitmapData(graphicKey);

				var graphic:FlxGraphic = imgGraphicCache.get(graphicKey);
				graphic.persist = false;
				graphic.destroyOnNoUse = true;
				imgGraphicCache.remove(graphicKey);
				graphic.destroy();
			}
		}

		System.gc();
	}
}

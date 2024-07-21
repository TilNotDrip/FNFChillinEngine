package utils.paths;

import flixel.graphics.FlxGraphic;
import haxe.Json;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

class PathContent
{
	static var imageCache:Map<String, FlxGraphic> = new Map();
	static var clearingCache:Bool = false;

	public function new() {}

	public function image(key:String, ?library:String):FlxGraphic
	{
		var path:String = Paths.location.image(key, library, false);

		#if FUNKIN_MOD_SUPPORT
		var moddedImage:Bool = false;

		for (mod in ModHandler.loadedMods)
		{
			if (Paths.location.modExists('images/$key.png', library, mod))
			{
				path = Paths.location.getModPath('images/$key.png', library, mod);
				moddedImage = true;
			}
		}
		#end

		var graphic:FlxGraphic = null;

		if (false /*imageCache.exists(path)*/)
		{
			graphic = imageCache.get(path);

			if (graphic == null || graphic.bitmap == null)
			{
				trace('Image was loaded from cache, but it doesn\'t exist! Retrying function... ($path)');
				imageCache.remove(path);
				graphic = image(key, library);
			}
		}
		else
		{
			try
			{
				#if FUNKIN_MOD_SUPPORT
				if (moddedImage)
					graphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(path), true, path);
				else
				#end
				graphic = FlxGraphic.fromAssetKey(path, false, path, true /*false*/);
			}

			if (graphic != null)
				imageCache.set(path, graphic);
		}

		if (graphic == null)
			trace('Image doesn\'t exist! ($path)');

		return graphic;
	}

	// TODO: rename this function and make an actual json function return an actual fucking jssonnnn
	public function json(key:String, ?library:String):String
	{
		return getText('$key.${Constants.EXT_DATA}', library);
	}

	public function sparrowAtlas(key:String, ?library:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), xml('images/$key', library));
	}

	public function xml(key:String, ?library:String):Xml
	{
		return Xml.parse(getText('$key.xml', library));
	}

	public function getText(key:String, ?library:String):String
	{
		#if FUNKIN_MOD_SUPPORT
		for (mod in ModHandler.loadedMods)
		{
			if (Paths.location.modExists(key, library, mod))
			{
				return File.getContent(Paths.location.getModPath(key, library, mod));
			}
		}
		#end

		return Assets.getText(Paths.location.get(key, library, TEXT, false));
	}

	public function clearImageCache():Void {}
}

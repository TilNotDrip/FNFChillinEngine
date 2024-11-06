package funkin.util.paths;

import haxe.Exception;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.FlxGraphic;
import haxe.Json;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.system.System;
#if FUNKIN_MOD_SUPPORT
import sys.io.File;
import sys.FileSystem;
#end

/**
 * A Path class for returning content from locations whether it be a FlxGraphic, Sound, or a String with a files content that you can parse using another class.
 */
class PathContent
{
	/**
	 * The cache handler for this class.
	 */
	public var cache:PathCache;

	public function new()
	{
		cache = new PathCache();
	}

	/**
	 * Adds an OpenFL sound to the audio cache and also returns it.
	 * @param key The key to cache.
	 * @return OpenFL Sound instance of a audio.
	 */
	public function audio(key:String, ?checkMods:Bool = true):Sound
	{
		return cache.getAudio(Paths.location.audio(key, checkMods));
	}

	/**
	 * Returns and also caches a graphic of a image bitmap.
	 * @param key Image File name.
	 * @param library Library the image is in.
	 * @param checkMods Allow mod images to be returned?
	 * @return A BitampData instance of a image.
	 */
	public function imageBitmap(key:String, ?checkMods:Bool = true):BitmapData
	{
		return cache.getBitmapData(Paths.location.image(key, checkMods));
	}

	/**
	 * Returns and also caches a FlxGraphic of a image.
	 * @param key Image File name.
	 * @param library Library the image is in.
	 * @param checkMods Allow mod images to be returned?
	 * @return A FlxGraphic instance of a image.
	 */
	public function imageGraphic(key:String, ?checkMods:Bool = true):FlxGraphic
	{
		return cache.getFlxGraphic(Paths.location.image(key, checkMods));
	}

	/**
	 * @param key Json File name.
	 * @param library Library the json is in.
	 * @param checkMods Allow mod jsons to be returned?
	 * @return A JSON turned into a string from the text asset in Paths.location.json
	 */
	public function json(key:String, ?checkMods:Bool = true):String
	{
		return getText(Paths.location.json(key, checkMods), checkMods);
	}

	/**
	 * @param key The image and xml name.
	 * @param library The library the image and xml are located.
	 * @param checkMods Allow mod sparrow atlases to be returned?
	 * @return Sparrow Atlas frames from library:assets/images/key.png&.xml
	 */
	public function sparrowAtlas(key:String, ?checkMods:Bool = true):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(imageGraphic(key, checkMods), xml(key, checkMods));
	}

	/**
	 * @param key The image and txt name.
	 * @param library The library the image and txt are located.
	 * @param checkMods Allow mod packer atlases to be returned?
	 * @return Packer Atlas frames from library:assets/images/key.png&.txt
	 */
	public function packerAtlas(key:String, ?checkMods:Bool = true):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(imageGraphic(key, checkMods), getText(Paths.location.txt(key, checkMods)));
	}

	/**
	 * Auto picks an atlas and returns an FlxFramesCollection.
	 * @param key The image and the description name.
	 * @param library The library the image and description are located.
	 * @param checkMods Allow mod atlases to be returned?
	 * @return Atlas frames from key.
	 */
	public function autoAtlas(key:String, ?checkMods:Bool = true):FlxFramesCollection
	{
		var path:String = Paths.location.get(key, checkMods).cutRawPath();

		if (Paths.location.exists('$path.txt'))
		{
			return packerAtlas(key, checkMods);
		}
		else if (Paths.location.exists('$path.xml'))
		{
			return sparrowAtlas(key, checkMods);
		}
		else if (ImageFrames.isFrameDirectory(key))
		{
			return ImageFrames.fromDirectory(key);
		}

		return null;
	}

	/**
	 * @param key Text File name. (get() IS NOT INCLUDED YOU HAVE TO DO IT YOURSELF!)
	 * @param checkMods Allow mod texts to be returned?
	 * @return String with text from specified file.
	 */
	public function getText(key:String, ?checkMods:Bool = true):String
	{
		var toReturn:String = null;
		try
		{
			#if FUNKIN_MOD_SUPPORT
			if (checkMods
				&& key.startsWith(Constants.MODS_FOLDER + '/')) // I should REALLY find a better way of doing this im just too lazy rn
				toReturn = File.getContent(key);
			else
			#end
			toReturn = Assets.getText(key);
		}
		catch (e:Exception)
		{
			trace('[ERROR]: Error loading $key! Does it not exist?');
			toReturn = null;
		}

		return toReturn;
	}

	/**
	 * @param key Xml File name.
	 * @param library Library the xml is in.
	 * @param checkMods Allow mod xmls to be returned?
	 * @return A Parsed XML Document from the text asset in Paths.location.xml
	 */
	public function xml(key:String, ?checkMods:Bool = true):Xml
	{
		return Xml.parse(getText(Paths.location.xml(key, checkMods), checkMods));
	}
}

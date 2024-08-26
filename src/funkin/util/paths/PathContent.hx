package funkin.util.paths;

import flixel.graphics.FlxGraphic;
import haxe.Json;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.system.System;
#if FUNKIN_MOD_SUPPORT
import sys.io.File;
#end

/**
 * A Path class for returning content from locations.
 *
 * This class also handles caching for audios and images.
 */
class PathContent
{
	/**
	 * The content that doesn't get wiped from a cache clean.
	 *
	 * You should only put something here if you use it on a daily basis.
	 *
	 * TODO: Alphabet loves getting fucked on a cache clear if its not in exclude idk why.
	 * TODO: Sound gets fucked if it's not in exclude mainly music tho.
	 */
	public var clearCacheExcludeKeys:Array<String> = [
		'default:assets/images/fonts/bold.png',
		'default:assets/images/fonts/default.png',
		'default:assets/images/mainmenu/menuBG.png',
		'default:assets/images/mainmenu/menuDesat.png',
		'default:assets/images/soundtray/bars_1.png', // The entire soundtray won't have an effect mainly because it uses Paths.location like the homosexual it is.
		'default:assets/images/soundtray/bars_2.png',
		'default:assets/images/soundtray/bars_3.png',
		'default:assets/images/soundtray/bars_4.png',
		'default:assets/images/soundtray/bars_5.png',
		'default:assets/images/soundtray/bars_6.png',
		'default:assets/images/soundtray/bars_7.png',
		'default:assets/images/soundtray/bars_8.png',
		'default:assets/images/soundtray/bars_9.png',
		'default:assets/images/soundtray/bars_10.png',
		'default:assets/images/soundtray/volumebox.png',
		'default:assets/music/freakyMenu.${Constants.EXT_SOUND}'
	];

	var imgGraphicCache:Map<String, FlxGraphic> = new Map();
	var audioCache:Map<String, Sound> = new Map();

	public function new() {}

	/**
	 * Returns and also caches a graphic of a image bitmap.
	 * @param key Image File name.
	 * @param library Library the image is in.
	 * @param checkMods Allow mod images to be returned?
	 * @return A BitampData instance of a image.
	 */
	public function imageBitmap(key:String, ?library:String, ?checkMods:Bool = true):BitmapData
	{
		var bitmap:BitmapData = null;
		var assetKey:String = Paths.location.image(key, library, checkMods);

		try
		{
			#if FUNKIN_MOD_SUPPORT
			if (assetKey.startsWith(Constants.MODS_FOLDER + '/')) // I should REALLY find a better way of doing this im just too lazy rn
				bitmap = BitmapData.fromFile(assetKey);
			else
			#end
			bitmap = Assets.getBitmapData(assetKey);
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
	 * @param checkMods Allow mod images to be returned?
	 * @return A FlxGraphic instance of a image.
	 */
	public function imageGraphic(key:String, ?library:String, ?checkMods:Bool = true):FlxGraphic
	{
		var bitmap:BitmapData = null;
		var graphic:FlxGraphic = null;
		var assetKey:String = Paths.location.image(key, library, checkMods);

		if (!imgGraphicCache.exists(key))
		{
			try
			{
				bitmap = imageBitmap(key, library, checkMods);
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
	 * @param checkMods Allow mod jsons to be returned?
	 * @return A Parsed JSON from the text asset in Paths.location.json
	 */
	public function json(key:String, ?library:String, ?trim:Bool = false, ?checkMods:Bool = true):Dynamic
	{
		if (trim)
			return Json.parse(jsonText(key, library, checkMods).trim());

		return Json.parse(jsonText(key, library, checkMods));
	}

	/**
	 * @param key Json File name.
	 * @param library Library the json is in.
	 * @param checkMods Allow mod jsons to be returned?
	 * @return A JSON turned into a string from the text asset in Paths.location.json
	 */
	public function jsonText(key:String, ?library:String, ?checkMods:Bool = true):String
	{
		return getText(Paths.location.json(key, library, checkMods), checkMods);
	}

	/**
	 * Returns and also caches a music file.
	 * @param key Music File name.
	 * @param library Library the music is in.
	 * @param checkMods Allow mod music to be returned?
	 * @return OpenFL Sound instance of a music audio.
	 */
	public function music(key:String, ?library:String, ?checkMods:Bool = true):Sound
	{
		return getAudio(Paths.location.music(key, library, checkMods));
	}

	/**
	 * Returns and also caches a sound file.
	 * @param key Sound File name.
	 * @param library Library the sound is in.
	 * @param checkMods Allow mod sounds to be returned?
	 * @return OpenFL Sound instance of a sound audio.
	 */
	public function sound(key:String, ?library:String, ?checkMods:Bool = true):Sound
	{
		return getAudio(Paths.location.sound(key, library, checkMods));
	}

	/**
	 * @param key The image and xml name.
	 * @param library The library the image and xml are located.
	 * @param checkMods Allow mod sparrow atlases to be returned?
	 * @return Sparrow Atlas frames from library:assets/images/key.png&.xml
	 */
	public function sparrowAtlas(key:String, ?library:String, ?checkMods:Bool = true):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(imageGraphic(key, library, checkMods), xml('images/$key', library, checkMods));
	}

	/**
	 * @param key Text File name. (get() IS NOT INCLUDED YOU HAVE TO DO IT YOURSELF!)
	 * @param checkMods Allow mod texts to be returned?
	 * @return String with text from specified file.
	 */
	public function getText(key:String, ?checkMods:Bool = true):String
	{
		#if FUNKIN_MOD_SUPPORT
		if (key.startsWith(Constants.MODS_FOLDER + '/')) // I should REALLY find a better way of doing this im just too lazy rn
		{
			return File.getContent(key);
		}
		#end

		return Assets.getText(key);
	}

	/**
	 * @param key Xml File name.
	 * @param library Library the xml is in.
	 * @param checkMods Allow mod xmls to be returned?
	 * @return A Parsed XML Document from the text asset in Paths.location.xml
	 */
	public function xml(key:String, ?library:String, ?checkMods:Bool = true):Xml
	{
		return Xml.parse(getText(Paths.location.xml(key, library, checkMods), checkMods));
	}

	/**
	 * Adds an OpenFL sound to the audio cache and also returns it.
	 * @param key The key to cache. (Paths.location.get is not called you have to do it yourself!)
	 * @return OpenFL Sound instance of a audio.
	 */
	public function getAudio(key:String):Sound
	{
		if (!audioCache.exists(key))
		{
			try
			{
				#if FUNKIN_MOD_SUPPORT
				if (key.startsWith(Constants.MODS_FOLDER + '/')) // I should REALLY find a better way of doing this im just too lazy rn
					audioCache.set(key, Sound.fromFile(key));
				else
				#end
				audioCache.set(key, Assets.getSound(key));
			}
			catch (e)
			{
				trace('[WARNING]: Sound is null! $key');
				return null;
			}
		}

		return audioCache.get(key);
	}

	/**
	 * Clears all audios in the audio cache and then runs the garbage collector.
	 */
	public function clearAudioCache():Void
	{
		for (audioKey in audioCache.keys())
		{
			removeFromAudioCache(audioKey);
		}

		System.gc();
	}

	/**
	 * Clears all images inside the image cache then runs the garbage collector.
	 */
	public function clearImageCache():Void
	{
		for (graphicKey in imgGraphicCache.keys())
		{
			removeFromImageCache(graphicKey);
		}

		System.gc();
	}

	/**
	 * Removes and destroys an audio from the adio cache.
	 * @param key Audio to remove and destroy.
	 */
	public function removeFromAudioCache(key:String):Void
	{
		if (clearCacheExcludeKeys.contains(key))
			return;

		Assets.cache.removeSound(key);
		audioCache.remove(key);
	}

	/**
	 * Removes and destroys an image from the image cache.
	 * @param key Image to remove and destroy.
	 */
	public function removeFromImageCache(key:String):Void
	{
		if (clearCacheExcludeKeys.contains(key))
			return;

		@:privateAccess
		FlxG.bitmap._cache.remove(key);
		Assets.cache.removeBitmapData(key);

		var graphic:FlxGraphic = imgGraphicCache.get(key);
		graphic.persist = false;
		graphic.destroyOnNoUse = true;
		imgGraphicCache.remove(key);
		graphic.destroy();
	}
}

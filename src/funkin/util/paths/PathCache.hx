package funkin.util.paths;

import openfl.system.System;
import openfl.Assets;
import haxe.Exception;
import openfl.media.Sound;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

/**
 * A paths class that handles all the caching for use by PathContent.
 */
class PathCache
{
	/**
	 * The content that doesn't get wiped from a cache clean.
	 *
	 * You should only put something here if you use it on a daily basis.
	 */
	final removeExcludeKeys:Array<String> = [
		'assets/ui/fonts/bold.png',
		'assets/ui/fonts/default.png',
		'assets/ui/soundtray/bars_1.png',
		'assets/ui/soundtray/bars_2.png',
		'assets/ui/soundtray/bars_3.png',
		'assets/ui/soundtray/bars_4.png',
		'assets/ui/soundtray/bars_5.png',
		'assets/ui/soundtray/bars_6.png',
		'assets/ui/soundtray/bars_7.png',
		'assets/ui/soundtray/bars_8.png',
		'assets/ui/soundtray/bars_9.png',
		'assets/ui/soundtray/bars_10.png',
		'assets/ui/soundtray/volumebox.png',
		'assets/ui/mainmenu/menuBG.png',
		'assets/ui/mainmenu/menuDesat.png',
		'assets/mainmenu/freakyMenu.${Constants.EXT_SOUND}'
	];

	var cachedAudioKeys:Array<String>;
	var cachedImageKeys:Array<String>;

	var cachedAudio:Map<String, Sound>;
	var cachedBitmapData:Map<String, BitmapData>;
	var cachedFlxGraphic:Map<String, FlxGraphic>;

	public function new()
	{
		cachedAudioKeys = [];
		cachedImageKeys = [];

		cachedAudio = new Map<String, Sound>();
		cachedBitmapData = new Map<String, BitmapData>();
		cachedFlxGraphic = new Map<String, FlxGraphic>();
	}

	/**
	 * Adds an OpenFL Sound instance to the audio cache and also returns it.
	 * @param key The key to cache.
	 * @return OpenFL Sound instance.
	 */
	public function getAudio(key:String):Sound
	{
		if (cachedAudio.get(key) == null)
		{
			var audio:Sound = null;

			try
			{
				#if FUNKIN_MOD_SUPPORT
				if (key.startsWith(Constants.MODS_FOLDER + '/'))
					audio = Sound.fromFile(key);
				else
				#end
				audio = Assets.getSound(key, false);
			}
			catch (e:Exception)
			{
				trace('[WARNING]: Audio is null! $key');
				return null;
			}

			cachedAudio.set(key, audio);

			if (!cachedAudioKeys.contains(key))
				cachedAudioKeys.push(key);

			return audio;
		}

		return cachedAudio.get(key);
	}

	/**
	 * Adds an OpenFL BitmapData instance to the bitmapData cache and also returns it.
	 * @param key The key to cache.
	 * @return OpenFL BitmapData instance.
	 */
	public function getBitmapData(key:String):BitmapData
	{
		if (cachedBitmapData.get(key) == null)
		{
			var bitmapData:BitmapData = null;

			try
			{
				#if FUNKIN_MOD_SUPPORT
				if (key.startsWith(Constants.MODS_FOLDER + '/'))
					bitmapData = BitmapData.fromFile(key);
				else
				#end
				bitmapData = Assets.getBitmapData(key, false);
			}
			catch (e:Exception)
			{
				trace('[WARNING]: BitmapData is null! $key');
				return null;
			}

			cachedBitmapData.set(key, bitmapData);

			if (!cachedImageKeys.contains(key))
				cachedImageKeys.push(key);

			return bitmapData;
		}

		return cachedBitmapData.get(key);
	}

	/**
	 * Adds an FlxGraphic instance to the FlxGraphic cache and also returns it.
	 * @param key The key to cache.
	 * @return FlxGraphic instance.
	 */
	public function getFlxGraphic(key:String):FlxGraphic
	{
		if (cachedFlxGraphic.get(key) == null)
		{
			var bitmapData:BitmapData = null;
			var flxGraphic:FlxGraphic = null;

			try
			{
				bitmapData = getBitmapData(key);
			}
			catch (e:Exception)
			{
				return null;
			}

			flxGraphic = FlxGraphic.fromBitmapData(bitmapData, false, key, false);
			flxGraphic.persist = true;
			flxGraphic.destroyOnNoUse = false;

			cachedFlxGraphic.set(key, flxGraphic);

			if (!cachedImageKeys.contains(key))
				cachedImageKeys.push(key);

			return flxGraphic;
		}

		return cachedFlxGraphic.get(key);
	}

	/**
	 * Clears out the cached objects in this instance.
	 * @param bypassExcludeKeys  Whether to remove the objects even if its in the exclude list.
	 */
	public function clear(?bypassExcludeKeys:Bool = false):Void
	{
		clearImages(bypassExcludeKeys);
		clearAudios(bypassExcludeKeys);
	}

	/**
	 * Clears out the cached audios in this instance.
	 * @param bypassExcludeKeys  Whether to remove the audios even if its in the exclude list.
	 */
	public function clearAudios(?bypassExcludeKeys:Bool = false):Void
	{
		for (audio in cachedAudioKeys)
		{
			removeAudio(audio, bypassExcludeKeys);
		}

		System.gc();
	}

	/**
	 * Clears out the cached images in this instance.
	 * @param bypassExcludeKeys Whether to remove the images even if its in the exclude list.
	 */
	public function clearImages(?bypassExcludeKeys:Bool = false):Void
	{
		for (image in cachedImageKeys)
		{
			removeImage(image, bypassExcludeKeys);
		}

		FlxG.bitmap.reset(); // Flixel caches all texts and transitions and stuff like that.
		System.gc();
	}

	/**
	 * Removes an audio from this audio cache.
	 * @param key The audio key to remove.
	 * @param bypassExcludeKeys Whether to remove the audio even if its in the exclude list.
	 */
	public function removeAudio(key:String, ?bypassExcludeKeys:Bool = false):Void
	{
		if (removeExcludeKeys.contains(key) && !bypassExcludeKeys)
			return;

		if (cachedAudio.get(key) != null)
		{
			cachedAudio.remove(key);
		}

		cachedAudioKeys.remove(key);
	}

	/**
	 * Removes and destroys an BitmapData and FlxGraphic instance from this cache.
	 * @param key The image key to remove.
	 * @param bypassExcludeKeys Whether to remove the image even if its in the exclude list.
	 */
	public function removeImage(key:String, ?bypassExcludeKeys:Bool = false):Void
	{
		if (removeExcludeKeys.contains(key) && !bypassExcludeKeys)
			return;

		if (cachedBitmapData.get(key) != null)
		{
			var bitmapData:BitmapData = cachedBitmapData.get(key);
			cachedBitmapData.remove(key);
			bitmapData.dispose();
		}

		if (cachedFlxGraphic.get(key) != null)
		{
			var flxGraphic:FlxGraphic = cachedFlxGraphic.get(key);
			flxGraphic.persist = false;
			flxGraphic.destroyOnNoUse = true;
			cachedFlxGraphic.remove(key);

			if (FlxG.bitmap.checkCache(key))
				FlxG.bitmap.remove(flxGraphic);

			if (flxGraphic != null)
				flxGraphic.destroy(); // The FlxG.bitmap.remove does but that one is a fallback incase it somehow got past.
		}

		cachedImageKeys.remove(key);
	}
}

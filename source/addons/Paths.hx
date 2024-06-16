package addons;

import flixel.graphics.FlxGraphic;
import openfl.system.System;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	private static var imageCache:Map<String, FlxGraphic> = new Map();
	private static var clearingCache:Bool = false;

	private static final excludePaths:Array<String> = ['shared:assets/shared/images/transitionSwag', 'assets/images/soundtray'];
	public static function clearImageCache()
	{
		clearingCache = true;

		var imageArray:Array<String> = imageCache.keyValues();

		@:privateAccess
		while(imageArray.length != 0)
		{
			var path:String = imageArray.shift();
			var image:FlxGraphic = imageCache.get(path);

			for(excludeyy in excludePaths)
			{
				if(path.startsWith(excludeyy))
				{
					image.persist = true;
					image.destroyOnNoUse = false;
					return;
				}
			}

			if(image != null)
			{
				image.persist = false;
				image.destroyOnNoUse = true;
				image.destroy();
			}

			// remove the key from all cache maps
			FlxG.bitmap._cache.remove(path);
			openfl.Assets.cache.removeBitmapData(path);
			imageCache.remove(path);

			trace('Successfully dealed with ${path}!');
		}

		System.gc();

		clearingCache = false;

		/*while(imageArray.length != 0)
			Sys.sleep(0.01);*/
	}

	public static function setCurrentLevel(name:String)
	{
		currentLevel = name;
	}

	public static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		#if MOD_SUPPORT
		for(daFile in ModLoader.modFile(file))
		{
			if (OpenFlAssets.exists(daFile, type))
				return daFile;
		}
		#end

		if (library != null)
			return getLibraryPath(file, library);

		var levelPath = getLibraryPathForce(file, "shared");
		if (OpenFlAssets.exists(levelPath, type))
			return levelPath;

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}	

	public static function exists(file:String, type:AssetType, ?library:Null<String>)
	{
		return OpenFlAssets.exists(getPath(file, type, library), type);
	}

	public static function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline private static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline private static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline public static function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline public static function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline public static function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	inline public static function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline public static function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline public static function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline public static function voices(song:String, ?person:String = '')
	{
		var fix:String = '';
		if(person != '')
			fix = '-' + person;

		return getPath('${song.formatToPath()}/Voices$fix.$SOUND_EXT', MUSIC, 'songs');
	}

	inline public static function inst(song:String)
	{
		return getPath('${song.formatToPath()}/Inst.$SOUND_EXT', MUSIC, 'songs');
	}

	inline public static function image(key:String, ?library:String)
	{
		var path = getPath('images/$key.png', IMAGE, library);

		var daReturn:FlxGraphic = null;

		if(false/*imageCache.exists(path)*/)
		{
			daReturn = imageCache.get(path);

			if(daReturn == null || daReturn.bitmap == null)
			{
				trace('Image was loaded from cache, but it doesn\'t exist! Retrying function... ($path)');
				imageCache.remove(path);
				daReturn = image(key, library);
			}
		}
		else
		{
			try {
				daReturn = FlxGraphic.fromAssetKey(path, false, path, true/*false*/);
			}

			if(daReturn != null)
				imageCache.set(path, daReturn);
		}

		if(daReturn == null)
			trace('Image does\' t exist! ($path)');

		return daReturn;
		
	}

	inline public static function font(key:String)
	{
		return getPath('fonts/$key', FONT, 'preload');
	}

	public static function video(videoFile:String):String {
		return getPath('videos/$videoFile.mp4', BINARY, 'preload');
	}

	inline public static function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	@:deprecated("`getPackerAtlas` is deprecated, use an XML instead.")
	inline public static function getPackerAtlas(key:String, ?library:String)
	{
		trace('getPackerAtlas is deprecated!');
		trace('Converting $key.txt to $key.xml...');

		var headOfYay:Xml = Xml.createDocument();
		var yay:Xml = Xml.createElement('TextureAtlas');

		yay.set('imagePath', key.split('/').getLastInArray() + '.png');

		for(i in CoolUtil.coolTextFile(file('images/$key.txt', library))) {
			var daThing:Array<String> = i.substring(i.lastIndexOf(' = ')).split(' ');
			var stupidNameFix:Array<String> = i.substring(0, i.indexOf(' = ')).split('_');

			var nameFix:String = '';

			nameFix += stupidNameFix[0];

			for(j in 1...4-stupidNameFix[1].length+1) nameFix += '0';
			nameFix += stupidNameFix[1];

			var subTexture:Xml = Xml.createElement('SubTexture');

			subTexture.set('name', nameFix);
			subTexture.set('x', daThing[0]);
			subTexture.set('y', daThing[1]);
			subTexture.set('width', daThing[2]);
			subTexture.set('height', daThing[3]);

			yay.addChild(subTexture);
		}

		headOfYay.addChild(yay);

		trace('Converted $key.txt to $key.xml!');

		return FlxAtlasFrames.fromSparrow(image(key, library), headOfYay);
	}

	public static function atlas(folder:String, ?library:String = 'preload')
	{
		return getLibraryPath('images/' + folder, library);
	}
}

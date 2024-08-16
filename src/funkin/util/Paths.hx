package funkin.util;

import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
	public static inline final SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	public static function setCurrentLevel(name:String)
	{
		currentLevel = name;
	}

	public static function atlas(folder:String):String
	{
		var animationFile:String = getPath('images/' + folder + '/Animation.json', TEXT);

		return animationFile.substring(0, animationFile.length - '/Animation.json'.length);
	}

	public static function font(key:String)
	{
		return getPath('fonts/$key', FONT, 'preload');
	}

	public static function inst(song:String)
	{
		return getPath('${song.formatToPath()}/Inst.$SOUND_EXT', MUSIC, 'songs');
	}

	public static function image(key:String, ?library:String)
	{
		var path = 'images/$key.png';

		if (exists(path, library, IMAGE))
			return OpenFlAssets.getBitmapData(getPath(path, IMAGE, library), true);

		return null;
	}

	public static function json(key:String, ?library:String)
	{
		return getPath('$key.json', TEXT, library);
	}

	public static function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	public static function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	public static function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	public static function txt(key:String, ?library:String)
	{
		return getPath('$key.txt', TEXT, library);
	}

	public static function video(videoFile:String):String
	{
		return getPath('videos/$videoFile.mp4', BINARY, 'preload');
	}

	public static function voices(song:String)
	{
		return getPath('${song.formatToPath()}/Voices.$SOUND_EXT', MUSIC, 'songs');
	}

	public static function exists(key:String, ?library, type:AssetType):Bool
	{
		// I hate my life
		if (OpenFlAssets.exists(getPath(key, type, library), type))
			return true;

		return false;
	}

	inline public static function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), getPath('images/$key.xml', TEXT, library));
	}

	@:deprecated("`getPackerAtlas` is deprecated, use an XML instead.")
	inline public static function getPackerAtlas(key:String, ?library:String)
	{
		trace('getPackerAtlas is deprecated!');
		trace('Converting $key.txt to $key.xml...');

		var keyShit:Array<String> = key.split('/');
		var yay:String = '<?xml version="1.0" encoding="utf-8"?>\n	<TextureAtlas imagePath="${keyShit[keyShit.length - 1]}.png">\n		<!-- Created with Til\'s bare hands -->\n		<!-- from .txt -->\n';
		for (i in CoolUtil.coolTextFile(getPath('images/$key.txt', TEXT, library)))
		{
			var daThing:Array<String> = i.split(' = ')[1].split(' ');
			var nameShit:String = '';
			var stupid:Array<String> = i.split(' = ')[0].split('_');

			nameShit += stupid[0];

			for (j in 1...4 - stupid[1].length + 1)
				nameShit += '0';
			nameShit += stupid[1];

			yay += '	<SubTexture name="$nameShit" x="${daThing[0]}" y="${daThing[1]}" width="${daThing[2]}" height="${daThing[3]}"/>\n';
		}

		yay += '</TextureAtlas>';

		var daXMLThing:Xml = Xml.parse(yay);

		trace('Converted $key.txt to $key.xml!');

		return FlxAtlasFrames.fromSparrow(image(key, library), daXMLThing);
	}

	public static function getPath(file:String, type:AssetType, ?library:Null<String>)
	{
		#if FUNKIN_MOD_SUPPORT
		for (daFile in ModLoader.modFile(file))
		{
			if (OpenFlAssets.exists(daFile, type))
				return daFile;
		}
		#end

		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	public static function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}
}

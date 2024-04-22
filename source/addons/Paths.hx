package addons;

#if flxanimate
import flxanimate.frames.FlxAnimateFrames;
#end

import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	public static function setCurrentLevel(name:String)
	{
		currentLevel = name.formatToPath();
	}

	public static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		for(daFile in ModLoader.modFile(file))
		{
			if (OpenFlAssets.exists(daFile, type))
				return daFile;
		}

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

	inline public static function voices(song:String)
	{
		return getPath('${song.formatToPath()}/Voices.$SOUND_EXT', MUSIC, 'songs');
	}

	inline public static function inst(song:String)
	{
		return getPath('${song.formatToPath()}/Inst.$SOUND_EXT', MUSIC, 'songs');
	}

	inline public static function image(key:String, ?library:String)
	{
		var path = getPath('images/$key.png', IMAGE, library);

		return OpenFlAssets.getBitmapData(path, true);
	}

	inline public static function font(key:String)
	{
		return getPath('fonts/$key', FONT, 'preload');
	}

	public static function video(videoFile:String):String {
		return getPath('video/$videoFile.mp4', BINARY, 'preload');
	}

	inline public static function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	@:deprecated("`getPackerAtlas` is deprecated, use an XML instead.")
	inline public static function getPackerAtlas(key:String, ?library:String)
	{
		var keyShit:Array<String> = key.split('/');
		var yay:String = 
		'<?xml version="1.0" encoding="utf-8"?>\n	<TextureAtlas imagePath="${keyShit[keyShit.length-1]}.png">\n		<!-- Created with Til\'s bare hands -->\n		<!-- from .txt -->\n';
		for(i in CoolUtil.coolTextFile(file('images/$key.txt', library))) {
			var daThing:Array<String> = i.split(' = ')[1].split(' ');
			var nameShit:String = '';
			var stupid:Array<String> = i.split(' = ')[0].split('_');

			nameShit += stupid[0];

			for(j in 1...4-stupid[1].length+1) nameShit += '0';
			nameShit += stupid[1];

			yay += '	<SubTexture name="$nameShit" x="${daThing[0]}" y="${daThing[1]}" width="${daThing[2]}" height="${daThing[3]}"/>\n';
		}

		yay += '</TextureAtlas>';

		var daXMLThing:Xml = Xml.parse(yay);

		trace('ohhh nahh we not using $key.txt, we converting like a real man');

		return FlxAtlasFrames.fromSparrow(image(key, library), daXMLThing);
	}
}

package addons;

import flixel.util.FlxSave;

class Highscore
{
	private static var saveScores:FlxSave;
	public static var songScores:Map<String, Int> = new Map<String, Int>();

	public static function load():Void
	{
		saveScores = new FlxSave();
		saveScores.bind('scores', CoolUtil.getSavePath());

		if (saveScores.data.songScores != null)
			songScores = saveScores.data.songScores;
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:String = ''):Void
	{
		var formattedSong:String = formatSong(song, diff);

		if (songScores.exists(formattedSong))
		{
			if (songScores.get(formattedSong) < score)
				setScore(formattedSong, score);
		}
		else
			setScore(formattedSong, score);
	}

	public static function saveWeekScore(week:String = 'week1', score:Int = 0, ?diff:String = ''):Void
	{
		var formattedSong:String = formatSong(week, diff);

		if (songScores.exists(formattedSong))
		{
			if (songScores.get(formattedSong) < score)
				setScore(formattedSong, score);
		}
		else
			setScore(formattedSong, score);
	}

	public static function formatSong(song:String, diff:String):String
	{
		var daSong:String = song;

		daSong += '-' + diff;

		return daSong.formatToPath();
	}

	public static function getScore(song:String, diff:String):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getWeekScore(week:String, diff:String):Int
	{
		if (!songScores.exists(formatSong(week, diff)))
			setScore(formatSong(week, diff), 0);

		return songScores.get(formatSong(week, diff));
	}

	private static function setScore(formattedSong:String, score:Int):Void
	{
		songScores.set(formattedSong, score);
		saveScores.data.songScores = songScores;
		saveScores.flush();
	}
}

package funkin.util;

#if sys
import sys.FileSystem;
#end

class SystemUtil
{
	#if sys
	/**
	 * Creates a new folder if it doesn't exist already.
	 * @param directory Folder name to be created.
	 */
	public static function makeFolder(directory:String):Void
	{
		if (!FileSystem.exists(directory))
		{
			FileSystem.createDirectory(directory);
		}
	}
	#end
}

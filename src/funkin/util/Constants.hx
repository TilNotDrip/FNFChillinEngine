package funkin.util;

import thx.semver.Version;
import thx.semver.VersionRule;

class Constants
{
	/**
	 * FILE EXTENSIONS
	 */
	// ==============================

	/**
	 * The file extension used when exporting chart files.
	 *
	 * - "I made a new file format"
	 * - "Actually new or just a renamed ZIP?"
	 */
	public static final EXT_CHART = "fnfc";

	/**
	 * The file extension used when loading data files.
	 */
	public static final EXT_DATA = "json";

	/**
	 * The file extension used when loading image files.
	 */
	public static final EXT_IMAGE = "png";

	/**
	 * The file extension used when loading audio files.
	 */
	public static final EXT_SOUND = #if web "mp3" #else "ogg" #end;

	/**
	 * The file extension used when loading video files.
	 */
	public static final EXT_VIDEO = "mp4";

	/**
	 * VERSIONS
	 */
	// ==============================

	/**
	 * The current character version that Chillin' Engine is on right now.
	 */
	public static final VERSION_CHARACTER:Version = "0.1.0";

	/**
	 * The version rule that Chillin' Engine supports right now.
	 */
	public static final VERSION_CHARACTER_RULE:VersionRule = "0.1.x";
}

package utils.paths;

class Paths
{
	public static var currentLevel:String;

	/**
	 * Grabs content from a path.
	 */
	public static var content:PathContent = new PathContent();

	/**
	 * Grabs a string location of a path.
	 */
	public static var location:PathLocation = new PathLocation();

	public static function setCurrentLevel(name:String)
	{
		currentLevel = name;
	}
}

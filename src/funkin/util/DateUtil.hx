package funkin.util;

class DateUtil
{
	/**
	 * @return Whether its April Fools or not.
	 */
	public static var aprilFools(get, never):Bool;

	static function get_aprilFools():Bool
	{
		return (Date.now().getDate() == 1 && Date.now().getMonth() == 4);
	}
}

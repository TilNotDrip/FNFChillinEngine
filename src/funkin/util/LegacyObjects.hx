package funkin.util;

abstract LegacyNotes(Array<Dynamic>) from Array<Dynamic> to Array<Dynamic> // i would like to apoligize.
{
	@:arrayAccess
	function arrayIndex(i:Int)
	{
		return this[i];
	}
}

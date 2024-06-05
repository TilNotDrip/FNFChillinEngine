package addons;

class ChillinEase extends FlxEase
{
    public static inline function lerp(t:Float):Float
	{
		return CoolUtil.coolLerp(t, 1, 0.04);
	}
}
package objects.menu;

class MenuAlphabet extends Alphabet
{
    public var targetY:Float = 0;

    override function update(elapsed:Float)
    {
        var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
      
        y = CoolUtil.coolLerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
        x = CoolUtil.coolLerp(x, (targetY * 20) + 90, 0.16);
      
        super.update(elapsed);
    }
}
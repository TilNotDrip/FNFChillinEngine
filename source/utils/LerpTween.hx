package utils;

import flixel.util.FlxDestroyUtil.IFlxDestroyable;

class LerpTween implements IFlxDestroyable
{
	public var valueFunc:Float->Void;

	var originalValue:Float;

	public var lerpTo:Float;

	var curValue:Float = 0;

	public var onComplete:Void->Void;

	public function new(valueFunc:Float->Void, originalValue:Float, lerpTo:Float)
	{
		this.valueFunc = valueFunc;
		this.originalValue = curValue = originalValue;
		this.lerpTo = lerpTo;

		FlxG.signals.preUpdate.add(update);
		FlxG.signals.preStateSwitch.add(destroy);
	}

	public function update()
	{
		curValue = CoolUtil.coolLerp(curValue, lerpTo, 0.04);
		valueFunc(curValue);

		if (curValue == lerpTo)
		{
			onComplete();
			destroy();
		}
	}

	public function destroy()
	{
		FlxG.signals.preUpdate.remove(update);
		FlxG.signals.preStateSwitch.remove(destroy);
	}
}

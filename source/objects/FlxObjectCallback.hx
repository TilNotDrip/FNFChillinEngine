package objects;

class FlxObjectCallback extends flixel.FlxObject
{
	public var positionChange:Void->Void;

	@:noCompletion
	override function set_x(value:Float):Float
	{
		if (positionChange != null)
			positionChange();

		return super.set_x(value);
	}

	@:noCompletion
	override function set_y(value:Float):Float
	{
		if (positionChange != null)
			positionChange();

		return super.set_y(value);
	}
}

package funkin.objects;

class TrackedSprite extends FlxSprite
{
	/**
	 * The object you want it attached to.
	 */
	public var sprTracker:FlxSprite;

	public var sprOffsetX:Float = 0.0;
	public var sprOffsetY:Float = 0.0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition((sprTracker.x + sprTracker.width) + sprOffsetX, sprTracker.y + sprOffsetY);
	}
}

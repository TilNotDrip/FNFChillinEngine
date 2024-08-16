package funkin.objects.menu;

class Checkbox extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.content.sparrowAtlas('mainmenu/checkbox');
		animation.addByIndices('idle', 'Unselect', [13, 13], '', 24, true);
		animation.addByIndices('idle selected', 'Press', [13, 13], '', 24, true);
		animation.addByPrefix('checked', 'Press', 24, false);
		animation.addByPrefix('unchecked', 'Unselect', 24, false);

		setGraphicSize(Std.int(width * 0.2));
		updateHitbox();
	}

	public function check(value:Bool):Void
	{
		if (value)
		{
			animation.play('checked', true);

			animation.finishCallback = function(anim:String)
			{
				animation.play('idle selected', true);
				animation.finishCallback = null;
			}
		}
		else
		{
			animation.play('unchecked', true);

			animation.finishCallback = function(anim:String)
			{
				animation.play('idle', true);
				animation.finishCallback = null;
			}
		}
	}
}

package objects;

import objects.Alphabet.AtlasChar;
import objects.menu.FreeplayScore;
import flixel.util.FlxSignal;

class AlphabetType extends Alphabet
{
	public var typing:Bool = false;
	public var speed:Float = 0.04;

	public var onComplete:FlxSignal = new FlxSignal();
	public var onText:FlxSignal = new FlxSignal(); // like coding a funny sound...

	private var timeElapsed:Float = 0;
	private var textIndex:Int = 0;
	private var curText:String = '';

	override function set_text(value:String)
	{
		super.set_text(value);

		if (!text.startsWith(curText) && typing)
			startTyping();
		else
			curText = text; // already gets called in startTyping, no use calling it twice

		visibilityCheck();

		return text;
	}

	public function startTyping()
	{
		group.kill();

		timeElapsed = 0;
		textIndex = 0;
		curText = text;

		typing = true;
	}

	public function skip()
	{
		timeElapsed = (curText.length - 1 * speed);
		textIndex = curText.length - 1;
	}

	override public function update(elapsed:Float)
	{
		if (typing)
			runLogic(elapsed);

		return super.update(elapsed);
	}

	/**
	 * runs the text logic.
	 * logic example; yeah:
	 * 0, y, first letter, automatically finishes. 
	 * 1, e, needs to wait for speed seconds. 
	 * 2, a, same as a, but x2. 
	 * 3, h, same as a, but x3, also last letter. 
	 * 4 [nothing] logic gets ready for it, but there isnt a 4th letter. so, because of a check at the end, it finishes.
	 * @param elapsed The time elapsed since the last update.
	 */
	public function runLogic(elapsed:Float)
	{
		timeElapsed += elapsed;

		while ((textIndex * speed) <= timeElapsed && typing)
		{
			members[textIndex].visible = true;
			onText.dispatch();

			textIndex++;

			if (curText.length <= textIndex)
				finishBackend();
		}
	}

	private function visibilityCheck()
	{
		forEachAlive(function(spr:AtlasChar)
		{
			spr.visible = !(members.indexOf(spr) <= textIndex);
		});
	}

	private function finishBackend()
	{
		onComplete.dispatch();
		typing = false;
	}
}

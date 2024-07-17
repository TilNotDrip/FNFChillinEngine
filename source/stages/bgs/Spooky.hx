package stages.bgs;

import objects.game.BGSprite;
import objects.game.Character;

class Spooky extends StageBackend
{
	private var halloweenBG:BGSprite;

	override public function create()
	{
		halloweenBG = new BGSprite('halloween_bg', -200, -100, 1, 1, ['halloweem bg lightning strike']);
		add(halloweenBG);
	}

	private function lightningStrikeShit()
	{
		FlxG.sound.play(Paths.location.sound('thunder_' + FlxG.random.int(1, 2)));

		lightningStrikeBeat = Conductor.curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		halloweenBG.dance();

		player.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	private var lightningStrikeBeat:Int = 0;
	private var lightningOffset:Int = 8;

	override public function beatHit()
	{
		if (FlxG.random.bool(10) && Conductor.curBeat > lightningStrikeBeat + lightningOffset)
			lightningStrikeShit();
	}
}

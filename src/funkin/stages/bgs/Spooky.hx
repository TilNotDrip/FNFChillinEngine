package funkin.stages.bgs;

import funkin.objects.game.BGSprite;
import funkin.objects.game.Character;

class Spooky extends StageBackend
{
	var halloweenBG:BGSprite;

	override public function create()
	{
		halloweenBG = new BGSprite('halloween_bg', -200, -100, 1, 1, ['halloweem bg lightning strike']);
		add(halloweenBG);
	}

	function lightningStrikeShit()
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		halloweenBG.dance();

		player.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override public function beatHit()
	{
		if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
			lightningStrikeShit();
	}
}
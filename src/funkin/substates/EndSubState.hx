package funkin.substates;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import funkin.stages.StageBackend;

class EndSubState extends MusicBeatSubstate
{
	var bfCheeringYouOn:FlxSprite;

	public function new()
	{
		super();

		Application.current.window.title += ' [ENDING]';

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = PlayState.game.rpcDetailsText + ' [Ending]';
		PlayState.game.setRpcTimestamps(false);
		#end

		PlayState.game.isEnding = true;
		FlxG.sound.music.stop();
		PlayState.game.vocals.stop();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFFFFFFF);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		var checker:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(75, 75, 150, 150, true, 0xFF000000, 0x0));
		checker.alpha = 0.3;
		checker.velocity.set(26, 26);
		checker.scrollFactor.set();
		add(checker);

		bfCheeringYouOn = new FlxSprite();
		bfCheeringYouOn.frames = Paths.getSparrowAtlas('endScreen/bf');
		bfCheeringYouOn.animation.addByIndices('uhh', 'yayy0', [0, 1], '', 24, false);
		bfCheeringYouOn.animation.addByPrefix('yippee', 'yayy0', 24, false);
		bfCheeringYouOn.animation.addByPrefix('tbh', 'yayy loop', 24, true);
		bfCheeringYouOn.animation.play('uhh', true);
		bfCheeringYouOn.screenCenter();
		bfCheeringYouOn.x = 150;
		add(bfCheeringYouOn);

		new FlxTimer().start(2.6, function(tmr:FlxTimer)
		{
			if (bfCheeringYouOn.animation != null)
				bfCheeringYouOn.animation.play('yippee', true);
			else
				tmr.reset(0.01);
		});
	}

	var hitEnd:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT && !hitEnd)
		{
			hitEnd = true;

			StageBackend.stage.endingStuff();
		}

		if (bfCheeringYouOn.animation.curAnim != null)
		{
			if (bfCheeringYouOn.animation.curAnim.finished && bfCheeringYouOn.animation.curAnim.name == 'yippee')
				bfCheeringYouOn.animation.play('tbh', true);
		}
	}
}

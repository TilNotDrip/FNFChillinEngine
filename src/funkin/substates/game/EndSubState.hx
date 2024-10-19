package funkin.substates.game;

import funkin.util.ChillinAnimationController;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

class EndSubState extends MusicBeatSubstate
{
	var bfCheeringYouOn:FlxSprite;

	public function new()
	{
		super();

		Application.current.window.title += ' [ENDING]';

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = PlayState.instance.rpcDetailsText + ' [Ending]';
		PlayState.instance.setRpcTimestamps(false);
		#end

		PlayState.instance.isEnding = true;
		FlxG.sound.music.stop();
		PlayState.instance.vocals.stop();

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
		bfCheeringYouOn.frames = Paths.content.autoAtlas('endScreen/bf');
		bfCheeringYouOn.animation = new ChillinAnimationController(bfCheeringYouOn);
		bfCheeringYouOn.animation.addByIndices('uhh', 'yayy0', [0, 1], '', 24, false);
		bfCheeringYouOn.animation.addByPrefix('yippee', 'yayy0', 24, false);
		bfCheeringYouOn.animation.addByPrefix('yippee-loop', 'yayy loop', 24, true);
		bfCheeringYouOn.animation.play('uhh', true);
		bfCheeringYouOn.screenCenter(Y);
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

			// PlayState.instance.curStage.endingStuff();
			PlayState.instance.endSong();
		}
	}
}

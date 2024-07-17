package substates;

import flixel.ui.FlxBar;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import stages.StageBackend;

class EndSubState extends MusicBeatSubstate
{
	var bfCheeringYouOn:FlxSprite;
	var ratingSpr:FlxSprite;

	var daAccuracy:Float = 0;
	var healthBarBG:FlxSprite;
	var healthBar:FlxBar;

	public function new()
	{
		super();

		Application.current.window.title += ' [ENDING]';

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = PlayState.game.rpcDetailsText + ' [Ending]';
		PlayState.game.setRpcTimestamps(false);
		#end

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
		bfCheeringYouOn.animation = new FunkinAnimationController(bfCheeringYouOn);
		bfCheeringYouOn.frames = Paths.content.sparrowAtlas('endScreen/bf');
		bfCheeringYouOn.animation.addByPrefix('yippee', 'yayy0', 24, false);
		bfCheeringYouOn.animation.addByPrefix('yippee-loop', 'yayy loop', 24, true);
		bfCheeringYouOn.animation.play('yippee', true);
		bfCheeringYouOn.animation.pause();
		bfCheeringYouOn.screenCenter();
		bfCheeringYouOn.x -= FlxG.width / 4;
		add(bfCheeringYouOn);

		var daRating:String = 'sick';

		if (PlayState.game.songAccuracy < 25)
			daRating = 'shit';
		else if (PlayState.game.songAccuracy > 25 && PlayState.game.songAccuracy < 50)
			daRating = 'bad';
		else if (PlayState.game.songAccuracy > 50 && PlayState.game.songAccuracy < 75)
			daRating = 'good';

		healthBarBG = new FlxSprite().makeGraphic(600, 20, FlxColor.BLACK);
		healthBarBG.screenCenter();
		healthBarBG.x += FlxG.width / 4;
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, LEFT_TO_RIGHT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'daAccuracy', 0, 100);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		add(healthBar);

		ratingSpr = new FlxSprite().loadGraphic(Paths.content.image("ui/" + daRating));
		ratingSpr.updateHitbox();
		ratingSpr.screenCenter();
		ratingSpr.y += 100;
		ratingSpr.x = healthBarBG.x + ((healthBarBG.width - ratingSpr.width) / 2);
		add(ratingSpr);
		ratingSpr.visible = false;

		new FlxTimer().start(2.5, function(tmr:FlxTimer)
		{
			if (bfCheeringYouOn.animation != null)
				showRating();
			else
				tmr.reset(0.001);
		});

		FlxTween.tween(this, {daAccuracy: PlayState.game.songAccuracy}, 2.5);
	}

	private function showRating()
	{
		bfCheeringYouOn.animation.resume();

		ratingSpr.scale.set(1.3, 1.3);
		ratingSpr.visible = true;
		FlxTween.tween(ratingSpr.scale, {x: 1, y: 1}, 0.3, {ease: FlxEase.quadOut});
	}

	private var hitEnd:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT && !hitEnd)
		{
			hitEnd = true;

			if (PlayState.game.curStage.endCallback != null)
				PlayState.game.curStage.endCallback();
			else
				PlayState.game.endSong();
		}
	}
}

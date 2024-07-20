package states.game;

class GitarooPause extends MusicBeatState
{
	private var replayButton:FlxSprite;
	private var cancelButton:FlxSprite;

	private var replaySelect:Bool = false;

	public function new()
	{
		super();
	}

	override public function create()
	{
		Application.current.window.title += ' [Secret Paused]';

		#if FUNKIN_DISCORD_RPC
		DiscordRPC.details = PlayState.instance.rpcDetailsText + ' [Paused (Secret)]';
		#end

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.content.image('pauseAlt/pauseBG'));
		add(bg);

		var bf:FlxSprite = new FlxSprite(0, 30);
		bf.frames = Paths.content.sparrowAtlas('pauseAlt/bfLol');
		bf.animation.addByPrefix('lol', "funnyThing instance", 13);
		bf.animation.play('lol');
		add(bf);
		bf.screenCenter(X);

		replayButton = new FlxSprite(FlxG.width * 0.28, FlxG.height * 0.7);
		replayButton.frames = Paths.content.sparrowAtlas('pauseAlt/pauseUI');
		replayButton.animation.addByPrefix('selected', 'bluereplay instance', 0, false);
		replayButton.animation.appendByPrefix('selected', 'yellowreplay instance');
		replayButton.animation.play('selected');
		add(replayButton);

		cancelButton = new FlxSprite(FlxG.width * 0.58, replayButton.y);
		cancelButton.frames = Paths.content.sparrowAtlas('pauseAlt/pauseUI');
		cancelButton.animation.addByPrefix('selected', 'bluecancel instance', 0, false);
		cancelButton.animation.appendByPrefix('selected', 'cancelyellow instance');
		cancelButton.animation.play('selected');
		add(cancelButton);

		changeThing();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
			changeThing();

		if (controls.ACCEPT)
		{
			if (replaySelect)
				FlxG.switchState(new PlayState());
			else
				FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	private function changeThing():Void
	{
		replaySelect = !replaySelect;

		if (replaySelect)
		{
			cancelButton.animation.curAnim.curFrame = 0;
			replayButton.animation.curAnim.curFrame = 1;
		}
		else
		{
			cancelButton.animation.curAnim.curFrame = 1;
			replayButton.animation.curAnim.curFrame = 0;
		}
	}
}

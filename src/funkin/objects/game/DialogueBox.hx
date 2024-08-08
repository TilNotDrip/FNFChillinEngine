package funkin.objects.game;

import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogueList:Array<String> = [];

	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.players[0].controls;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.formatToPath())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		if (PlayState.isPixel)
		{
			switch (PlayState.SONG.song.formatToPath())
			{
				case 'roses':
					portraitLeft = new FlxSprite(-20, 45);
					portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiMadPortrait');
					portraitLeft.animation.addByPrefix('enter', 'SENPAI ANGRY IMPACT SPEECH instance 1', 24, false);

				default:
					portraitLeft = new FlxSprite(-20, 40);
					portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
					portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter instance', 24, false);
			};

			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.antialiasing = false;
			portraitLeft.scrollFactor.set();
			portraitLeft.updateHitbox();
			portraitLeft.visible = false;
			add(portraitLeft);

			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
			portraitRight.antialiasing = false;
			portraitRight.scrollFactor.set();
			portraitRight.updateHitbox();
			add(portraitRight);
			portraitRight.visible = false;
		}

		box = new FlxSprite(-20, 45);

		var hasDialog = false;

		switch (PlayState.SONG.song.formatToPath())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('pixelui/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear instance 1', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('pixelui/dialogueBox-mad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH instance 1', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH instance 1', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('pixelui/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn instance 1', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn instance 1', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				face.antialiasing = false;
				add(face);
		}

		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.antialiasing = false;
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		if (portraitLeft != null)
			portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('pixelui/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.antialiasing = false;
		handSelect.updateHitbox();
		handSelect.visible = false;
		add(handSelect);

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	override public function update(elapsed:Float)
	{
		if (PlayState.SONG.song.formatToPath() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished && PlayState.isPixel)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (controls.ACCEPT && dialogueEnded)
		{
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.formatToPath() == 'senpai' || PlayState.SONG.song.formatToPath() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						handSelect.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		else if (controls.ACCEPT && dialogueStarted)
			swagDialogue.skip();

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04);
		swagDialogue.completeCallback = function()
		{
			handSelect.visible = true;
			dialogueEnded = true;
		};
		handSelect.visible = false;
		dialogueEnded = false;

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}

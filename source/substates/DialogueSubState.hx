package substates;

import flixel.FlxCamera;

class DialogueSubState extends MusicBeatSubstate
{
	public var dialogueList:Array<DialogueEntry> = [{text: 'coolswag', character: 'bf'}, {text: 'money money', character: 'dad'}];

	private var curDialogue:DialogueEntry = null;
	private var curDialogueIndex:Int = -1;

	private var canActuallyClose:Bool = false;

	private var bubble:FlxSprite;
	private var dialogueText:AlphabetType;
	private var background:FlxSprite;

	override public function create()
	{
		super.create();

		var dialogueCamera:FlxCamera = new FlxCamera();
		dialogueCamera.bgColor.alpha = 0;
		FlxG.cameras.add(dialogueCamera, false);

		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFFB3DFd8);
		background.antialiasing = false;
		background.cameras = [dialogueCamera];
		add(background);

		bubble = new FlxSprite(0, 300);
		bubble.frames = Paths.getSparrowAtlas('dialogue/bubble');
		bubble.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
		bubble.animation.addByPrefix('normal-intro', 'speech bubble normal', 24, false);
		bubble.animation.addByPrefix('angry', 'AHH speech bubble', 24, true);
		bubble.animation.addByPrefix('angry-intro', 'speech bubble loud open', 24, false);
		bubble.animation.play('normal', true);

		bubble.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int)
		{
			bubble.screenCenter(X);
			bubble.y = 300 + ((250 - bubble.frameHeight) / 2);
		};

		bubble.cameras = [dialogueCamera];
		add(bubble);
		bubble.visible = false;

		dialogueText = new AlphabetType(0, 330, 'coolswag', DEFAULT);
		dialogueText.cameras = [dialogueCamera];
		add(dialogueText);

		background.alpha = 0;
		FlxTween.tween(background, {alpha: 0.8}, 3, {
			onComplete: function(twn:FlxTween)
			{
				bubble.visible = true;
				handleDialogue();
			}
		});
	}

	public function handleDialogue()
	{
		curDialogueIndex++;
		curDialogue = dialogueList[curDialogueIndex];

		if (curDialogue == null)
		{
			if (curDialogueIndex > dialogueList.length - 1)
				close();
			else
				startNextDialogue();
		}
	}

	private function startNextDialogue()
	{
		var type:String = curDialogue.bubbleType ?? 'normal';

		dialogueText.text = (curDialogue.text ?? 'coolswag (Null Object Reference)');
		dialogueText.speed = (0.04 * (curDialogue.speedMult ?? 1.00));

		if (bubble.animation.curAnim.name != type)
			bubble.animation.play(type + '-intro', true);
		else
			dialogueText.startTyping();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT && curDialogueIndex < 0)
		{
			if (dialogueText.typing)
				dialogueText.skip();
			else
				handleDialogue();
		}

		if (bubble.animation != null && bubble.animation.curAnim != null)
		{
			dialogueText.visible = (!bubble.animation.curAnim.name.endsWith('-intro'));

			if (bubble.animation.curAnim.finished)
			{
				var name:String = bubble.animation.curAnim.name;

				if (name.endsWith('-intro'))
				{
					if (!bubble.animation.curAnim.reversed)
					{
						bubble.animation.play(name.substring(0, name.indexOf('-intro')), true);
						dialogueText.startTyping();
					}
					else
					{
						canActuallyClose = true;
						close();
					}
				}
			}
		}
	}

	override public function close()
	{
		if (!canActuallyClose)
		{
			if (bubble.animation.curAnim.name.endsWith('-intro') && !bubble.animation.curAnim.reversed)
				bubble.animation.play(bubble.animation.curAnim.name, true, true);
			else
				bubble.animation.play(bubble.animation.curAnim.name + '-intro', true, true);

			FlxTween.tween(background, {alpha: 0}, ((1 / 24) * 2));
		}
		else
			super.close();
	}
}

typedef DialogueEntry =
{
	var text:String;
	var character:String;
	@:optional var bubbleType:String;
	@:optional var speedMult:Float;
}

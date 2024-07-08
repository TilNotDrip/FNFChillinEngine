package objects.menu;

import shaders.HSVShader;
import shaders.GaussianBlurShader;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import shaders.Grayscale;
import openfl.filters.BitmapFilterQuality;

class SongMenuItem extends FlxSpriteGroup
{
	public var capsule:FlxSprite;

	var pixelIcon:FlxSprite;

	/**
	 * Modify this by calling `init()`
	 * If `null`, assume this SongMenuItem is for the "Random Song" option.
	 */
	public var songData(default, null):Null<addons.Week.SongData> = null;

	public var selected(default, set):Bool;

	public var songText:CapsuleText;
	public var favIcon:FlxSprite;
	public var explicitIcon:FlxSprite;
	public var ranking:FlxSprite;

	var ranks:Array<String> = ["fail", "average", "great", "excellent", "perfect"];

	public var targetPos:FlxPoint = new FlxPoint();
	public var doLerp:Bool = false;
	public var doJumpIn:Bool = false;

	public var doJumpOut:Bool = false;

	public var onConfirm:Void->Void;
	public var grayscaleShader:Grayscale;

	public var hsvShader(default, set):HSVShader;

	// var diffRatingSprite:FlxSprite;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		capsule = new FlxSprite();
		capsule.frames = Paths.getSparrowAtlas('freeplay/freeplayCapsule');
		capsule.animation.addByPrefix('selected', 'mp3 capsule w backing0', 24);
		capsule.animation.addByPrefix('unselected', 'mp3 capsule w backing NOT SELECTED', 24);
		// capsule.animation
		add(capsule);

		// doesn't get added, simply is here to help with visibility of things for the pop in!
		grpHide = new FlxGroup();

		var rank:String = FlxG.random.getObject(ranks);

		ranking = new FlxSprite(capsule.width * 0.84, 30);
		// ranking.loadGraphic(Paths.image('freeplay/ranks/' + rank));
		// ranking.scale.x = ranking.scale.y = realScaled;
		// ranking.alpha = 0.75;
		// ranking.visible = false;
		// ranking.origin.set(capsule.origin.x - ranking.x, capsule.origin.y - ranking.y);
		// add(ranking);
		// grpHide.add(ranking);

		switch (rank)
		{
			case 'perfect':
				ranking.x -= 10;
		}

		grayscaleShader = new Grayscale(1);

		// diffRatingSprite = new FlxSprite(145, 90).loadGraphic(Paths.image('freeplay/diffRatings/diff00'));
		// diffRatingSprite.shader = grayscaleShader;
		// diffRatingSprite.origin.set(capsule.origin.x - diffRatingSprite.x, capsule.origin.y - diffRatingSprite.y);
		// TODO: Readd once ratings are fully implemented
		// add(diffRatingSprite);
		// grpHide.add(diffRatingSprite);

		songText = new CapsuleText(capsule.width * 0.26, 45, 'Random', Std.int(40 * realScaled));
		add(songText);
		grpHide.add(songText);

		// TODO: Use value from metadata instead of random.
		updateDifficultyRating(FlxG.random.int(0, 15));

		pixelIcon = new FlxSprite(160, 35);

		pixelIcon.makeGraphic(32, 32, 0x00000000);
		pixelIcon.antialiasing = false;
		pixelIcon.active = false;
		add(pixelIcon);
		grpHide.add(pixelIcon);

		explicitIcon = new FlxSprite(0, 47);
		explicitIcon.loadGraphic(Paths.image('freeplay/explicit'));
		explicitIcon.x = capsule.width - explicitIcon.width - 95;
		explicitIcon.scale.x = explicitIcon.scale.y = 2;
		explicitIcon.antialiasing = false;
		explicitIcon.active = false;
		add(explicitIcon);
		grpHide.add(explicitIcon);

		favIcon = new FlxSprite(400, 40);
		favIcon.frames = Paths.getSparrowAtlas('freeplay/favHeart');
		favIcon.animation.addByPrefix('fav', 'favorite heart', 24, false);
		favIcon.animation.play('fav');
		favIcon.setGraphicSize(50, 50);
		favIcon.visible = false;
		add(favIcon);
		// grpHide.add(favIcon);

		setVisibleGrp(false);
	}

	function updateDifficultyRating(newRating:Int):Void
	{
		var ratingPadded:String = newRating < 10 ? '0$newRating' : '$newRating';
		// diffRatingSprite.loadGraphic(Paths.image('freeplay/diffRatings/diff${ratingPadded}'));
		// diffRatingSprite.visible = false;
	}

	function set_hsvShader(value:HSVShader):HSVShader
	{
		this.hsvShader = value;
		capsule.shader = hsvShader;
		songText.shader = hsvShader;

		return value;
	}

	function textAppear():Void
	{
		songText.scale.x = 1.7;
		songText.scale.y = 0.2;

		new FlxTimer().start(1 / 24, function(_)
		{
			songText.scale.x = 0.4;
			songText.scale.y = 1.4;
		});

		new FlxTimer().start(2 / 24, function(_)
		{
			songText.scale.x = songText.scale.y = 1;
		});
	}

	function setVisibleGrp(value:Bool):Void
	{
		for (spr in grpHide.members)
		{
			spr.visible = value;
		}

		if (value)
			textAppear();

		updateSelected();
	}

	public function init(?x:Float, ?y:Float, songData:Null<addons.Week.SongData>):Void
	{
		if (x != null)
			this.x = x;
		if (y != null)
			this.y = y;
		this.songData = songData;

		// Update capsule text.
		songText.text = (songData != null) ? songData.song : 'Random';
		// Update capsule character.
		if (songData != null && songData.icon != null)
			setCharacter(songData.icon);
		// updateDifficultyRating((songData != null) ? songData.songRating : 0);
		// Update opacity, offsets, etc.

		if (songData != null && songData.explicit)
			explicitIcon.alpha = 1;
		else
			explicitIcon.alpha = 0;

		updateSelected();
	}

	/**
	 * Set the character displayed next to this song in the freeplay menu.
	 * @param char The character ID used by this song.
	 *             If the character has no freeplay icon, a warning will be thrown and nothing will display.
	 */
	public function setCharacter(char:String):Void
	{
		var charPath:String = "freeplay/icons/";

		// TODO: Put this in the character metadata where it belongs.
		// TODO: Also, can use CharacterDataParser.getCharPixelIconAsset()
		switch (char)
		{
			case 'mom':
				charPath += 'mommypixel';
			case 'dad':
				charPath += 'daddypixel';
			case 'parents':
				charPath += 'parents-christmaspixel';
			default:
				charPath += '${char}pixel';
		}

		if (!Paths.exists('images/$charPath.png', IMAGE))
		{
			trace('[WARN] Character ${char} has no freeplay icon.');
			return;
		}

		pixelIcon.loadGraphic(Paths.image(charPath));
		pixelIcon.scale.x = pixelIcon.scale.y = 2;

		switch (char)
		{
			case 'parents':
				pixelIcon.origin.x = 140;
			default:
				pixelIcon.origin.x = 100;
		}
		// pixelIcon.origin.x = capsule.origin.x;
		// pixelIcon.offset.x -= pixelIcon.origin.x;
	}

	var frameInTicker:Float = 0;
	var frameInTypeBeat:Int = 0;

	var frameOutTicker:Float = 0;
	var frameOutTypeBeat:Int = 0;

	var xFrames:Array<Float> = [1.7, 1.8, 0.85, 0.85, 0.97, 0.97, 1];
	var xPosLerpLol:Array<Float> = [0.9, 0.4, 0.16, 0.16, 0.22, 0.22, 0.245]; // NUMBERS ARE JANK CUZ THE SCALING OR WHATEVER
	var xPosOutLerpLol:Array<Float> = [0.245, 0.75, 0.98, 0.98, 1.2]; // NUMBERS ARE JANK CUZ THE SCALING OR WHATEVER

	public var realScaled:Float = 0.8;

	public function initJumpIn(maxTimer:Float, ?force:Bool):Void
	{
		frameInTypeBeat = 0;

		new FlxTimer().start((1 / 24) * maxTimer, function(doShit)
		{
			doJumpIn = true;
		});

		new FlxTimer().start((0.09 * maxTimer) + 0.85, function(lerpTmr)
		{
			doLerp = true;
		});

		if (force)
		{
			visible = true;
			capsule.alpha = 1;
			setVisibleGrp(true);
		}
		else
		{
			new FlxTimer().start((xFrames.length / 24) * 2.5, function(_)
			{
				visible = true;
				capsule.alpha = 1;
				setVisibleGrp(true);
			});
		}
	}

	var grpHide:FlxGroup;

	public function forcePosition():Void
	{
		visible = true;
		capsule.alpha = 1;
		updateSelected();
		doLerp = true;
		doJumpIn = false;
		doJumpOut = false;

		frameInTypeBeat = xFrames.length;
		frameOutTypeBeat = 0;

		capsule.scale.x = xFrames[frameInTypeBeat - 1];
		capsule.scale.y = 1 / xFrames[frameInTypeBeat - 1];
		// x = FlxG.width * xPosLerpLol[Std.int(Math.min(frameInTypeBeat - 1, xPosLerpLol.length - 1))];

		x = targetPos.x;
		y = targetPos.y;

		capsule.scale.x *= realScaled;
		capsule.scale.y *= realScaled;

		setVisibleGrp(true);
	}

	override function update(elapsed:Float):Void
	{
		if (doJumpIn)
		{
			frameInTicker += elapsed;

			if (frameInTicker >= 1 / 24 && frameInTypeBeat < xFrames.length)
			{
				frameInTicker = 0;

				capsule.scale.x = xFrames[frameInTypeBeat];
				capsule.scale.y = 1 / xFrames[frameInTypeBeat];
				x = FlxG.width * xPosLerpLol[Std.int(Math.min(frameInTypeBeat, xPosLerpLol.length - 1))];

				capsule.scale.x *= realScaled;
				capsule.scale.y *= realScaled;

				frameInTypeBeat += 1;
			}
		}

		if (doJumpOut)
		{
			frameOutTicker += elapsed;

			if (frameOutTicker >= 1 / 24 && frameOutTypeBeat < xFrames.length)
			{
				frameOutTicker = 0;

				capsule.scale.x = xFrames[frameOutTypeBeat];
				capsule.scale.y = 1 / xFrames[frameOutTypeBeat];
				x = FlxG.width * xPosOutLerpLol[Std.int(Math.min(frameOutTypeBeat, xPosOutLerpLol.length - 1))];

				capsule.scale.x *= realScaled;
				capsule.scale.y *= realScaled;

				frameOutTypeBeat += 1;
			}
		}

		if (doLerp)
		{
			x = CoolUtil.coolLerp(x, targetPos.x, 0.3);
			y = CoolUtil.coolLerp(y, targetPos.y, 0.4);
		}

		super.update(elapsed);
	}

	public function intendedY(index:Int):Float
	{
		return (index * ((height * realScaled) + 10)) + 120;
	}

	function set_selected(value:Bool):Bool
	{
		// cute one liners, lol!
		selected = value;
		updateSelected();
		return selected;
	}

	function updateSelected():Void
	{
		grayscaleShader.setAmount(this.selected ? 0 : 0.8);
		songText.alpha = this.selected ? 1 : 0.6;
		songText.blurredText.visible = this.selected ? true : false;
		capsule.offset.x = this.selected ? 0 : -5;
		capsule.animation.play(this.selected ? "selected" : "unselected");
		ranking.alpha = this.selected ? 1 : 0.7;
		ranking.color = this.selected ? 0xFFFFFFFF : 0xFFAAAAAA;
	}
}

class CapsuleText extends FlxSpriteGroup
{
	public var blurredText:FlxText;

	var whiteText:FlxText;

	public var text(default, set):String;

	public function new(x:Float, y:Float, songTitle:String, size:Float)
	{
		super(x, y);

		blurredText = initText(songTitle, size);
		blurredText.shader = new GaussianBlurShader(1);
		whiteText = initText(songTitle, size);
		// whiteText.shader = new GaussianBlurShader(0.3);
		text = songTitle;

		blurredText.color = 0xFF00ccff;
		whiteText.color = 0xFFFFFFFF;
		add(blurredText);
		add(whiteText);
	}

	function initText(songTitle, size:Float):FlxText
	{
		var text:FlxText = new FlxText(0, 0, 0, songTitle, Std.int(size));
		text.font = "5by7";
		return text;
	}

	function set_text(value:String):String
	{
		if (value == null)
			return value;
		if (blurredText == null || whiteText == null)
		{
			trace('WARN: Capsule not initialized properly');
			return text = value;
		}

		blurredText.text = value;
		whiteText.text = value;
		whiteText.textField.filters = [
			new openfl.filters.GlowFilter(0x00ccff, 1, 5, 5, 210, BitmapFilterQuality.MEDIUM),
			// new openfl.filters.BlurFilter(5, 5, BitmapFilterQuality.LOW)
		];
		return text = value;
	}
}

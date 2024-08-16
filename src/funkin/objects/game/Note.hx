package funkin.objects.game;

import funkin.shaders.RGBShader;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;
	public var noteData:Int = 0;
	public var ui:String = 'funkin';

	public var mustPress:Bool = false;

	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	var willMiss:Bool = false;

	public var altNote:Bool = false;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public static var swagWidth:Float = 160 * 0.7;

	public var inEditor:Bool = false;

	public var colors:Array<String> = ['purple', 'blue', 'green', 'red'];

	public var arrowColorsRed:Array<FlxColor> = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];
	public var arrowColorsGreen:Array<FlxColor> = [0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF];
	public var arrowColorsBlue:Array<FlxColor> = [0xFF3C1F56, 0xFF1542B7, 0xFF0A4447, 0xFF651038];

	public var rgbShader:RGBShader = new RGBShader();

	public function new(strumTime:Float, noteData:Int, ui:String = 'funkin', ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		this.ui = ui;

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		switch (ui)
		{
			case 'funkin-pixel':
				if (isSustainNote)
				{
					loadGraphic(Paths.content.imageGraphic('ui/pixel/NotesENDS'), true, 7, 6);

					animation.add('hold', [0]);
					animation.add('holdend', [1]);
				}
				else
				{
					loadGraphic(Paths.content.imageGraphic('ui/pixel/Notes'), true, 17, 17);

					animation.add('purpleScroll', [0]);
					animation.add('blueScroll', [1]);
					animation.add('greenScroll', [2]);
					animation.add('redScroll', [3]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				antialiasing = false;
				updateHitbox();

				arrowColorsRed = [0xFFE276FF, 0xFF3DCAFF, 0xFF71E300, 0xFFFF884E];
				arrowColorsGreen = [0xFFFFF9FF, 0xFFF4FFFF, 0xFFF6FFE6, 0xFFFFFAF5];
				arrowColorsBlue = [0xFF60008D, 0xFF003060, 0xFF003100, 0xFF6C0000];

			default:
				frames = Paths.content.sparrowAtlas('ui/funkin/Notes');

				animation.addByPrefix('purpleScroll', 'left static');
				animation.addByPrefix('blueScroll', 'down static');
				animation.addByPrefix('greenScroll', 'up static');
				animation.addByPrefix('redScroll', 'right static');

				animation.addByPrefix('hold', 'hold piece');
				animation.addByPrefix('holdend', 'hold end');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();

				arrowColorsRed = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];
				arrowColorsGreen = [0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF];
				arrowColorsBlue = [0xFF3C1F56, 0xFF1542B7, 0xFF0A4447, 0xFF651038];
		}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;

				if (!isSustainNote)
					animation.play('purpleScroll');

				rgbShader.rgb = [arrowColorsRed[0], arrowColorsGreen[0], arrowColorsBlue[0]];
			case 1:
				x += swagWidth * 1;

				if (!isSustainNote)
					animation.play('blueScroll');

				rgbShader.rgb = [arrowColorsRed[1], arrowColorsGreen[1], arrowColorsBlue[1]];
			case 2:
				x += swagWidth * 2;

				if (!isSustainNote)
					animation.play('greenScroll');

				rgbShader.rgb = [arrowColorsRed[2], arrowColorsGreen[2], arrowColorsBlue[2]];
			case 3:
				x += swagWidth * 3;

				if (!isSustainNote)
					animation.play('redScroll');

				rgbShader.rgb = [arrowColorsRed[3], arrowColorsGreen[3], arrowColorsBlue[3]];
		}

		if (isSustainNote && prevNote != null)
		{
			if (FunkinOptions.get('downScroll'))
				angle = 180;

			x += width / 2;

			animation.play('holdend');

			updateHitbox();

			x -= width / 2;

			if (ui == 'funkin-pixel')
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play('hold');

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
			}
		}

		shader = rgbShader.shader;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if ((mustPress || PlayState.botplay) || (!mustPress || PlayState.botplayDad))
		{
			if (willMiss && !wasGoodHit)
			{
				tooLate = true;
				canBeHit = false;
			}
			else
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset)
				{
					if (strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
						canBeHit = true;
				}
				else
				{
					canBeHit = true;
					willMiss = true;
				}
			}
		}
		else
			canBeHit = false;

		if (tooLate && !inEditor)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}

	public function returnColors(note:Int)
	{
		return [arrowColorsRed[note], arrowColorsGreen[note], arrowColorsBlue[note]];
	}
}

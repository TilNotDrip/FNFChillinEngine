package objects.game;

import flixel.group.*;
import shaders.RGBShader;

class Strumline extends FlxGroup
{
	// Static Colors Variables
	public var staticColors:Array<FlxColor> = [0xFF87A3AD, 0xFFFFFFFF, 0xFF000000];
	public var staticColorsPixel:Array<FlxColor> = [0xFFA2BAC8, 0xFFFFF5FC, 0xFF404047];

	// Very Important
	public var strumID:String;

	// Metadata
	public var isPixel:Bool;
	public var speed:Float;
	public var noteAmount:Int = 4;

	// Strums
	public var strums:FlxSpriteGroup;
	public var strumsRGB:Array<RGBShader> = [];

	// Notes
	public var notes:FlxTypedGroup<Note>;
	public var holdNotes:FlxTypedGroup<SustainNote>;

	// Note Splashes/Hold Covers
	public var noteSplashes:FlxTypedGroup<NoteSplash>;
	public var holdCovers:FlxTypedGroup<NoteSplash>;

	// Position
	public var x(default, set):Float = 0;

	public function new(strumID:String)
	{
		this.strumID = strumID;

		super();

		strums = new FlxSpriteGroup();
		add(strums);

		for (note in 0...noteAmount)
		{
			var newNote:FlxSprite = new FlxSprite(Note.NOTE_WIDTH * note);

			if (isPixel)
			{
				newNote.loadGraphic(Paths.content.image('pixelui/notes/strums'), true, 17, 17);

				newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
				newNote.updateHitbox();
				newNote.antialiasing = false;

				newNote.animation.add('static', [0 + note]);
				newNote.animation.add('pressed', [4 + note, 8 + note], 12, false);
				newNote.animation.add('confirm', [12 + note, 16 + note], 24, false);
			}
			else
			{
				var direction:String = cast(note, Direction).toString().toLowerCase();
				newNote.frames = Paths.content.sparrowAtlas('ui/notes/strums');
				newNote.setGraphicSize(Std.int(newNote.width * 0.7));

				newNote.animation.addByPrefix('static', direction + ' static');
				newNote.animation.addByPrefix('pressed', direction + ' press', 24, false);
				newNote.animation.addByPrefix('confirm', direction + ' confirm', 24, false);
			}

			newNote.animation.play('static');

			var rgbShader:RGBShader = new RGBShader();
			newNote.shader = rgbShader.shader;
			strumsRGB.push(rgbShader);

			strums.add(newNote);
		}
	}

	public function tweenInNotes()
	{
		for (i => babyArrow in strums.members)
		{
			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
		}
	}

	function set_x(value:Float):Float
	{
		strums.x = value;
		return value;
	}
}

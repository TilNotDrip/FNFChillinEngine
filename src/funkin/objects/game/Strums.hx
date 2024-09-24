package funkin.objects.game;

import flixel.group.FlxSpriteGroup;
import funkin.graphics.shaders.RGBShader;

class Strums extends FlxSpriteGroup
{
	public var notes:Int;

	var noteArray:Array<String> = ['left', 'down', 'up', 'right'];

	public var staticNoteShader:RGBShader = new RGBShader();
	public var pressNoteShader:Array<RGBShader> = [new RGBShader(), new RGBShader(), new RGBShader(), new RGBShader()];

	var staticNoteColors:Array<FlxColor>;

	var ui:String = 'funkin';

	public function new(x:Float, y:Float, notes:Int, ui:String = 'funkin')
	{
		super(x, y);
		this.notes = notes;
		this.ui = ui;

		for (note in 0...notes)
		{
			var newNote:FlxSprite = new FlxSprite(Note.swagWidth * note);

			switch (ui)
			{
				case 'funkin-pixel':
					newNote.loadGraphic(Paths.content.imageGraphic('gameplay-ui/pixel/Notes'), true, 17, 17);

					newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
					newNote.updateHitbox();
					newNote.antialiasing = false;

					newNote.animation.add('static', [0 + note]);
					newNote.animation.add('pressed', [0 + note, 4 + note], 12, false);
					newNote.animation.add('confirm', [8 + note, 12 + note], 24, false);

					staticNoteShader.rgb = [0xFFA2BAC8, 0xFFFFF5FC, 0xFF404047];

				default:
					var directions:Array<String> = ['left', 'down', 'up', 'right'];

					newNote.frames = Paths.content.autoAtlas('gameplay-ui/funkin/Notes');
					newNote.setGraphicSize(Std.int(newNote.width * 0.7));

					newNote.animation.addByPrefix('static', directions[note] + ' static');
					newNote.animation.addByPrefix('pressed', directions[note] + ' press', 24, false);
					newNote.animation.addByPrefix('confirm', directions[note] + ' confirm', 24, false);

					staticNoteShader.rgb = [0xFF87A3AD, 0xFFFFFFFF, 0xFF000000];
			}

			shader = staticNoteShader.shader;

			newNote.animation.play('static');
			newNote.ID = note;

			add(newNote);
		}
	}

	override public function update(elapsed:Float)
	{
		offsetThingy();
		super.update(elapsed);
		offsetThingy();
	}

	public function offsetThingy()
	{
		for (i in 0...notes)
		{
			var spr:FlxSprite = getNote(i);

			spr.centerOffsets();
			spr.updateHitbox();

			if (spr.animation.curAnim.name == 'static')
			{
				spr.shader = staticNoteShader.shader;
			}
			else
			{
				spr.shader = pressNoteShader[i].shader;
			}

			if (spr.animation.curAnim.name == 'confirm' && ui == 'funkin')
			{
				spr.offset.x += 26;
				spr.offset.y += 26;
			}

			if (ui == 'funkin')
				spr.scrollFactor.set();
		}
	}

	public function playNoteAnim(note:Int, anim:String, forced:Bool = true)
	{
		getNote(note).animation.play(anim, forced);
		offsetThingy();
	}

	public function getNote(note:Int):FlxSprite
	{
		if (note >= notes)
			throw 'Note ID ' + note + ' doesnt exist!';
		var daSpr:FlxSprite = null;
		forEach(function(spr:FlxSprite)
		{
			if (spr.ID == note)
				daSpr = spr;
		});
		return daSpr;
	}

	override function get_width():Float
	{
		return Note.swagWidth * notes;
	}
}

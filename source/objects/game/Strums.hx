package objects.game;

import flixel.group.FlxSpriteGroup;

import shaders.RGBShader;

class Strums extends FlxSpriteGroup
{
    var noteArray:Array<String> = ['left', 'down', 'up', 'right'];
	public var notes:Int;
	public var staticNotes:RGBShader = new RGBShader();

	// lmao idk how to do this correctly
	public var pressNoteLeft:RGBShader = new RGBShader();
	public var pressNoteDown:RGBShader = new RGBShader();
	public var pressNoteUp:RGBShader = new RGBShader();
	public var pressNoteRight:RGBShader = new RGBShader();

	var staticNoteColors:Array<FlxColor>;

	var isPixel:Bool = false;
    public function new(x:Float, y:Float, notes:Int, isPixel:Bool)
	{
        super(x, y);
		this.notes = notes;
		this.isPixel = isPixel;

		for(note in 0...notes)
		{
			var newNote:FlxSprite = new FlxSprite(Note.swagWidth * note);
			if (isPixel)
			{
				newNote.loadGraphic(Paths.image('pixelui/Notes'), true, 17, 17);

				newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
				newNote.updateHitbox();
				newNote.antialiasing = false;

				newNote.animation.add('static', [0]);
				newNote.animation.add('pressed', [1, 2], 12, false);
				newNote.animation.add('confirm', [3, 4], 24, false);

				staticNotes.rgb = [0xFFA2BAC8, 0xFFFFF5FC, 0xFF404047];
			}
			else
			{
				newNote.frames = Paths.getSparrowAtlas('ui/Notes');

				newNote.setGraphicSize(Std.int(newNote.width * 0.7));

				var direction:Array<String> = ['left', 'down', 'up', 'right'];
				newNote.animation.addByPrefix('static', direction[note] + ' static');
				newNote.animation.addByPrefix('pressed', direction[note] + ' press', 24, false);
				newNote.animation.addByPrefix('confirm', direction[note] + ' confirm', 24, false);

				staticNotes.rgb = [0xFF87A3AD, 0xFFFFFFFF, 0xFF000000];
			}

			shader = staticNotes.shader;

			newNote.animation.play('static');
			newNote.ID = note;

			if (isPixel)
			{
				switch (newNote.ID)
				{
					case 0:
						newNote.angle = -90;
					case 1:
						newNote.angle = 180;
					case 2:
						newNote.angle = 0;
					case 3:
						newNote.angle = 90;
				}
			}

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
		for(i in 0...notes)
		{
			var spr:FlxSprite = getNote(i);

			spr.centerOffsets();
			spr.updateHitbox();

			if (spr.animation.curAnim.name == 'static')
				spr.shader = staticNotes.shader;
			else
			{
				switch(i)
				{
					case 0: spr.shader = pressNoteLeft.shader;
					case 1: spr.shader = pressNoteDown.shader;
					case 2: spr.shader = pressNoteUp.shader;
					case 3: spr.shader = pressNoteRight.shader;
				}
			}

			if (spr.animation.curAnim.name == 'confirm' && !isPixel)
			{
				spr.offset.x += 26;
				spr.offset.y += 26;
			}

			if(isPixel)
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
		if(note >= notes) throw 'Note ID ' + note + ' doesnt exist!';
		var daSpr:FlxSprite = null;
		forEach(function(spr:FlxSprite) {
			if(spr.ID == note) daSpr = spr;
		});
		return daSpr;
	}
}
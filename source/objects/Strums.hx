package objects;

import flixel.group.FlxSpriteGroup;

class Strums extends FlxSpriteGroup
{
    var noteArray:Array<String> = ['left', 'down', 'up', 'right'];
	public var notes:Int;
	var isPixel:Bool = false;
    public function new(x:Float, y:Float, notes:Int, isPixel:Bool) {
        super(x, y);
		this.notes = notes;
		this.isPixel = isPixel;

		for(note in 0...notes)
		{
			var newNote:FlxSprite = new FlxSprite(Note.swagWidth * note);
			if (isPixel)
			{
				newNote.loadGraphic(Paths.image('pixelui/NOTE_assets'), true, 17, 17);

				newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
				newNote.updateHitbox();
				newNote.antialiasing = false;

				newNote.animation.add('static', [0 + note]);
				newNote.animation.add('pressed', [4 + note, 8 + note], 12, false);
				newNote.animation.add('confirm', [12 + note, 16 + note], 24, false);
			}
			else
			{
				newNote.frames = Paths.getSparrowAtlas('ui/NOTE_assets');

				newNote.setGraphicSize(Std.int(newNote.width * 0.7));

				var whoTf:Array<String> = ['1', '2', '4', '3']; //who is stupid enough to do this.
				newNote.animation.addByPrefix('static', 'arrow static instance ' + whoTf[note]);
				newNote.animation.addByPrefix('pressed', noteArray[note] + ' press instance', 24, false);
				newNote.animation.addByPrefix('confirm', noteArray[note] + ' confirm instance', 24, false);
			}

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
		for(i in 0...notes)
		{
			var spr:FlxSprite = getNote(i);

			spr.centerOffsets();

			if (spr.animation.curAnim.name == 'confirm' && !isPixel)
			{
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}

			if(isPixel)
			{
				spr.updateHitbox();
				spr.scrollFactor.set();
			}
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
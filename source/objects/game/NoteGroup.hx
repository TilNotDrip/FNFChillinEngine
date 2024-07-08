package objects.game;

import flixel.math.FlxRect;
import addons.Song.SwagNote;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxSignal;


class NoteGroup extends FlxTypedSpriteGroup<Note>
{
    public var strum:Strums;
    public var notes(default, set):Array<SwagNote>;

    public var maxHeight:Float;
    public var speed:Float;
    
    public var botplay:Bool = true;
    public var downScroll:Bool = false;
    public var despawn:Bool = true;

    public var hitSignal:FlxTypedSignal<Note->Void> = new FlxTypedSignal();
    public var missSignal:FlxTypedSignal<Note->Void> = new FlxTypedSignal();
    public var ghostSignal:FlxSignal = new FlxSignal();

    public function new(notes:Array<SwagNote>, strum:Strums, speed:Float)
    {
        super();

        this.strum = strum;
        this.notes = notes;
        
        this.speed = speed;
    }

    public function regenerateNotes()
    {
        forEach(function(note:Note) {
            remove(note, true).destroy();
        });

        for (songNotes in notes)
		{
            if(songNotes.strum != strum.strumID)
                return;

			var oldNote:Note;
			if (length > 0)
				oldNote = members[Std.int(members.length - 1)];
			else
				oldNote = null;

			var swagNote:Note = new Note(songNotes.time, songNotes.direction, strum.isPixel, oldNote);
			swagNote.sustainLength = songNotes.length;
			swagNote.type = songNotes.type;
            swagNote.mustPress = (songNotes.strum == 'Player');
            add(swagNote);

			for (susNote in 0...Math.floor(swagNote.sustainLength / Conductor.stepCrochet))
			{
				oldNote = members[Std.int(members.length - 1)];

				var sustainNote:Note = new Note(songNotes.time + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, songNotes.direction, strum.isPixel, oldNote, true);
				sustainNote.mustPress = (songNotes.strum == 'Player');
				add(sustainNote);

				sustainNote.kill();
			}

            swagNote.kill();
		}
    }

    override public function draw()
    {
        super.draw();

        forEach(function(daNote:Note)
		{
            if(downScroll)
                daNote.y = (maxHeight - OldNote.swagWidth) - ((Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(speed, 2)));
            else
                daNote.y = ((Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(speed, 2)));

            daNote.x = (OldNote.swagWidth * daNote.noteData);
            if(daNote.isSustainNote) daNote.x += ((OldNote.swagWidth - daNote.width) / 2);
		});

        forEachDead(function(daNote:Note) {
            if (((downScroll && daNote.y > -daNote.height)
				|| (!downScroll && daNote.y < maxHeight)))
				daNote.revive();
        });

        forEachAlive(function(daNote:Note) {
            if (((downScroll && daNote.y < -daNote.height)
				|| (!downScroll && daNote.y > FlxG.height)))
				daNote.kill();
            
            daNote.visible = strum.visible;

            if(daNote.isSustainNote)
            {
                if (downScroll)
                {
                    var strumLineMid:Float = maxHeight - OldNote.swagWidth / 2;
    
                    if (daNote.animation.curAnim.name.endsWith("end") && daNote.prevNote != null)
                        daNote.y += daNote.prevNote.height;
                    else
                        daNote.y += daNote.height / 2;
    
                    if (despawn && (botplay || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))
                        && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= strumLineMid)
                    {
                        var swagRect:FlxRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
    
                        swagRect.height = (strumLineMid - daNote.y) / daNote.scale.y;
                        swagRect.y = daNote.frameHeight - swagRect.height;
                        daNote.clipRect = swagRect;
                    }
                }
                else
                {
                    var strumLineMid:Float = OldNote.swagWidth / 2;
    
                     if (despawn && (botplay || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))
                        && daNote.y + daNote.offset.y * daNote.scale.y <= strumLineMid)
                    {
                            var swagRect:FlxRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
        
                        swagRect.y = (strumLineMid - daNote.y) / daNote.scale.y;
                        swagRect.height -= swagRect.y;
                        daNote.clipRect = swagRect;
                    }
                }
            }

            if (!daNote.mustPress && daNote.strumTime <= Conductor.songPosition && botplay)
				hitSignal.dispatch(daNote);

			if (daNote.isSustainNote && daNote.wasGoodHit)
			{
				if ((!downScroll && daNote.y < -daNote.height)
					|| (downScroll && daNote.y > FlxG.height))
					remove(daNote, true).destroy();
			}
			else if (daNote.tooLate || daNote.wasGoodHit)
			{
				if (daNote.tooLate && !botplay) // little behind-the-scenes trick! 
					missSignal.dispatch(daNote);

				remove(daNote, true).destroy();
			}
        });
    }

    override public function update(elapsed:Float):Void
	{
        super.update(elapsed);

		var holdArray:Array<Bool> = [
			PlayerSettings.players[0].controls.NOTE_LEFT,
			PlayerSettings.players[0].controls.NOTE_DOWN,
			PlayerSettings.players[0].controls.NOTE_UP,
			PlayerSettings.players[0].controls.NOTE_RIGHT
		];

		var pressArray:Array<Bool> = [
			PlayerSettings.players[0].controls.NOTE_LEFT_P,
			PlayerSettings.players[0].controls.NOTE_DOWN_P,
			PlayerSettings.players[0].controls.NOTE_UP_P,
			PlayerSettings.players[0].controls.NOTE_RIGHT_P
		];

		if (holdArray.contains(true))
		{
			forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
				{
					hitSignal.dispatch(daNote);
				}
			});
		}

		if (pressArray.contains(true))
		{
			var possibleNotes:Array<Note> = [];
			var directionList:Array<Int> = [];
			var dumbNotes:Array<Note> = [];

			forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});

			for (note in dumbNotes)
			{
				FlxG.log.notice("killing dumb ass note at " + note.strumTime);
				remove(note, true).destroy();
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			/*if (perfectMode)
				goodNoteHit(possibleNotes[0]);
			else */if (possibleNotes.length > 0)
			{
				for (shit in 0...pressArray.length)
				{
					if (pressArray[shit] && !directionList.contains(shit))
						missSignal.dispatch(possibleNotes[0]);
				}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
						hitSignal.dispatch(coolNote);
				}
			}
			else
				ghostSignal.dispatch();
		}
	}

    function set_notes(value:Array<SwagNote>):Array<SwagNote> 
    {
        return value.filter(function(note:SwagNote) {
            return note.strum == strum.strumID;
        });
    }
}
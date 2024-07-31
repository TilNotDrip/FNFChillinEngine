package objects.game;

import flixel.util.FlxSort;
import flixel.math.FlxRect;
import flixel.util.FlxSignal;
import utils.Scoring;
import utils.Song.SwagSong;
import flixel.group.FlxSpriteGroup;
import utils.Direction;
import flixel.group.*;
import shaders.RGBShader;

class Strumline extends FlxGroup
{
	// Static Variables
	public static var STATIC_COLORS:Array<FlxColor> = [0xFF87A3AD, 0xFFFFFFFF, 0xFF000000];
	public static var STATIC_COLORS_PIXEL:Array<FlxColor> = [0xFFA2BAC8, 0xFFFFF5FC, 0xFF404047];
	public static var CONFIRM_HOLD_TIME:Float = 0.1;

	// Very Important
	public var strumID:String;

	// Metadata
	public var isPixel:Bool;
	public var speed:Float;
	public var noteAmount:Int = 4;
	public var botplay:Bool;

	// Signals
	public var noteHit:FlxTypedSignal<Note->Void>;
	public var noteMiss:FlxTypedSignal<Note->Void> = new FlxTypedSignal<Note->Void>();

	// Strums
	public var strums:FlxSpriteGroup;
	public var strumsRGB:Array<RGBShader> = [];
	private var confirmTimer:Array<Null<Float>> = [];
	private var activleyHeld:Array<Bool> = [];

	// Notes
	public var notes:FlxTypedGroup<Note>;
	public var holdNotes:FlxTypedGroup<SustainNote>;

	// Note Splashes/Hold Covers
	public var noteSplashes:FlxTypedGroup<NoteSplash>;
	public var holdCovers:FlxTypedGroup<NoteHoldCover>;


	public function new(strumID:String, botplay:Bool)
	{
		this.strumID = strumID;
		this.botplay = botplay;

		super();

		strums = new FlxSpriteGroup();
		add(strums);

		notes = new FlxTypedGroup<Note>();
		holdNotes = new FlxTypedGroup<SustainNote>();

		add(holdNotes);
		add(notes);

		holdCovers = new FlxTypedGroup<NoteHoldCover>();
		add(holdCovers);

		var holdCover:NoteHoldCover = new NoteHoldCover();
		holdCovers.add(holdCover);
		holdCover.kill();

		noteSplashes = new FlxTypedGroup<NoteSplash>(6);
		add(noteSplashes);

		var noteSplash:NoteSplash = new NoteSplash(100, 100);
		noteSplashes.add(noteSplash);
		noteSplash.kill();

		generateStrums();

		noteHit = new FlxTypedSignal<Note->Void>();
		noteMiss = new FlxTypedSignal<Note->Void>();

		noteHit.add(noteHitThings);
	}

	public function noteHitThings(note:Note) 
	{
		note.kill();

		if (ChillSettings.get('noteSplashes'))
		{
			var noteSplash:NoteSplash = noteSplashes.recycle(NoteSplash);
			noteSplash.setupNoteSplash(note.x, strums.y, isPixel);
			noteSplash.setColors(note.returnColors());
			noteSplashes.add(noteSplash);
		}

		strumsRGB[note.data.direction].rgb = note.returnColors();
		strums.members[note.data.direction].animation.play('confirm', true);
	}

	public function generateStrums():Void
	{
		strumsRGB = [];
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

			newNote.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int) {
				newNote.centerOffsets();
				newNote.updateHitbox();

				if (newNote.animation.curAnim.name == 'confirm' && !isPixel)
				{
					newNote.offset.x += 26;
					newNote.offset.y += 26;
				}
			};

			newNote.animation.play('static');

			var rgbShader:RGBShader = new RGBShader();
			newNote.shader = rgbShader.shader;
			strumsRGB.push(rgbShader);

			if(!isPixel)
				rgbShader.rgb = STATIC_COLORS;
			else
				rgbShader.rgb = STATIC_COLORS_PIXEL;

			strums.add(newNote);
		}
	}

	public function generateNotes(song:SwagSong):Void
	{
		for (songNotes in song.notes)
		{
			if(songNotes.strum != strumID)
				continue;

			var swagNote:Note = new Note(songNotes, isPixel);
			// swagNote.strums = strums;

			if (swagNote.sustain != null)
			{
				holdNotes.add(swagNote.sustain);
				swagNote.sustain.kill();
			}

			notes.add(swagNote);
			swagNote.kill();
		}
	}

	public function tweenInNotes():Void
	{
		for (i => babyArrow in strums.members)
		{
			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
		}
	}

	override public function update(elapsed:Float)
	{
		var strumLineMid:Float = strums.y + (Note.NOTE_WIDTH / 2);

		notes.forEach(function(daNote:Note)
		{
			if (ChillSettings.get('downScroll'))
				daNote.y = (strums.y + (Conductor.songPosition - daNote.data.time) * (0.45 * FlxMath.roundDecimal(speed, 2)));
			else
				daNote.y = (strums.y - (Conductor.songPosition - daNote.data.time) * (0.45 * FlxMath.roundDecimal(speed, 2)));

			if (((ChillSettings.get('downScroll') && daNote.y < -daNote.height)
				|| (!ChillSettings.get('downScroll') && daNote.y > FlxG.height))
				&& daNote.alive
				&& !daNote.wasHit)
				daNote.kill();

			if (((ChillSettings.get('downScroll') && daNote.y + Note.NOTE_WIDTH < FlxG.height)
				|| (!ChillSettings.get('downScroll') && daNote.y > 0))
				&& !daNote.alive
				&& !daNote.wasHit)
				daNote.revive();
		});

		notes.forEachAlive(function(daNote:Note)
		{
			daNote.mayHit = (daNote.data.time >= Conductor.songPosition - Scoring.PBOT1_MISS_THRESHOLD
				&& daNote.data.time <= Conductor.songPosition + (Scoring.PBOT1_MISS_THRESHOLD - 1));

			daNote.x = strums.x + (Note.NOTE_WIDTH * daNote.data.direction);

			if (daNote.data.time + Scoring.PBOT1_MISS_THRESHOLD <= Conductor.songPosition && !daNote.wasHit && !botplay)
				noteMiss.dispatch(daNote);

			if (daNote.data.time <= Conductor.songPosition && !daNote.wasHit && botplay)
				noteHit.dispatch(daNote);
		});

		holdNotes.forEach(function(daNote:SustainNote)
		{
			daNote.x = daNote.head.x + ((Note.NOTE_WIDTH - daNote.width) / 2);

			if (ChillSettings.get('downScroll'))
			{
				daNote.y = daNote.head.y - (Conductor.stepCrochet * (0.45 * FlxMath.roundDecimal(speed, 2)));
				daNote.flipY = true;
			}
			else
				daNote.y = daNote.head.y + (Conductor.stepCrochet * (0.45 * FlxMath.roundDecimal(speed, 2)));

			if (((ChillSettings.get('downScroll') && daNote.y < -daNote.height)
				|| (!ChillSettings.get('downScroll') && daNote.y > FlxG.height))
				&& daNote.alive /* && !daNote.wasHit*/)
				daNote.kill();

			if (((ChillSettings.get('downScroll') && daNote.y + Note.NOTE_WIDTH < FlxG.height)
				|| (!ChillSettings.get('downScroll') && daNote.y > 0))
				&& !daNote.alive /* && !daNote.wasHit*/)
				daNote.revive();
		});

		holdNotes.forEachAlive(function(daNote:SustainNote)
		{
			if(daNote.head.wasHit)
			{
				if (daNote.cover == null)
				{
					var holdCover:NoteHoldCover = holdCovers.recycle(NoteHoldCover);
					holdCover.setColors(daNote.head.returnColors());
					holdCover.playStart();
					daNote.cover = holdCover;
					holdCovers.add(holdCover);

					holdCover.x = strums.x;
    				holdCover.x += Note.NOTE_WIDTH * daNote.head.data.direction;
    				holdCover.x += Note.NOTE_WIDTH / 2;
    				holdCover.x -= holdCover.width / 2;
    				holdCover.x += 12; // Manual tweaking because fuck.

					holdCover.y = strums.y;
    				holdCover.y += -0.275 * Note.NOTE_WIDTH;
    				holdCover.y += Note.NOTE_WIDTH / 2;
    				holdCover.y += -96; // Manual tweaking because fuck.
				}
				else if(Conductor.songPosition >= daNote.head.data.time + daNote.head.data.length)
					daNote.cover.playEnd();

				if (daNote.y + daNote.offset.y * daNote.scale.y <= strumLineMid)
				{
					var swagRect:FlxRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);

					swagRect.y = (strumLineMid - daNote.y) / daNote.scale.y;
					swagRect.height -= swagRect.y;
					daNote.clipRect = swagRect;
				}
			}
		});

		notes.sort(PlayState.sortNotes, FlxSort.DESCENDING);

		for (i=>strum in strums.members)
		{
			if(strum.animation.curAnim.name == "confirm" && strum.animation.curAnim.finished && confirmTimer[i] != null && !activleyHeld[i])
				confirmTimer[i] += elapsed;
			else
				confirmTimer[i] = 0;

			if(confirmTimer[i] >= 0.1)
			{
				strum.animation.play('static', true);

				if(!isPixel)
					strumsRGB[i].rgb = STATIC_COLORS;
				else
					strumsRGB[i].rgb = STATIC_COLORS_PIXEL;
				
			}
		}

		super.update(elapsed);
	}
}

package objects.game;

import shaders.RGBShader;

class OldNote extends FlxSprite
{
	public var strumTime:Float = 0;
	public var noteData:Int = 0;
	public var isPixel:Bool;

	public var mustPress:Bool = false;
	
	public var wasHit:Bool = false;
	public var mayHit:Bool = false;

	public var prevNote:OldNote;

	public var suffix:String = '';
	public var type(default, set):String = 'Normal';
	public var lowPriority:Bool = false;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public static var swagWidth:Float = 160 * 0.7;

	public var inEditor:Bool = false;

	public var colors:Array<String> = ['purple', 'blue', 'green', 'red']; 

	public var arrowColorsRed:Array<FlxColor> = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];
	public var arrowColorsGreen:Array<FlxColor> = [0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF];
	public var arrowColorsBlue:Array<FlxColor> = [0xFF3C1F56, 0xFF1542B7, 0xFF0A4447, 0xFF651038];

	private var rgbShader:RGBShader = new RGBShader();

	public function new(strumTime:Float, noteData:Int, isPixel:Bool, ?prevNote:OldNote, ?sustainNote:Bool = false)
	{
		super();

		this.isPixel = isPixel;

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		type = type;
    }

	private function set_type(value:String):String
	{
		var funnyPath:String = 'Notes';
		switch(value)
		{
			case 'Alt':
				suffix = 'alt';
			
			default:
				suffix = '';
				resetColors();
		}

		reloadNote(funnyPath);

		return type;
	}

	public function resetColors()
	{
		if(isPixel)
		{
			arrowColorsRed = [0xFFE276FF, 0xFF3DCAFF, 0xFF71E300, 0xFFFF884E];
			arrowColorsGreen = [0xFFFFF9FF, 0xFFF4FFFF, 0xFFF6FFE6, 0xFFFFFAF5];
			arrowColorsBlue = [0xFF60008D, 0xFF003060, 0xFF003100, 0xFF6C0000];
		}
		else
		{
			arrowColorsRed = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];
			arrowColorsGreen = [0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF];
			arrowColorsBlue = [0xFF3C1F56, 0xFF1542B7, 0xFF0A4447, 0xFF651038];
		}
	}

	public function reloadNote(?path:String = 'Notes')
	{
		if (isPixel)
		{
			var noteToFrame:Array<Int> = [4, 5, 6, 7];
			
			loadGraphic(Paths.image('pixelui/' + path), true, 17, 17);

			animation.add('scroll', [noteToFrame[noteData]]);

			if (isSustainNote)
			{
				loadGraphic(Paths.image('pixelui/' + path + 'ENDS'), true, 7, 6);

				animation.add('hold', [0]);
				animation.add('holdend', [1]);
			}

			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			antialiasing = false;
			updateHitbox();
		}
		else
		{
			var noteToString:Array<String> = ['left', 'down', 'up', 'right'];

			frames = Paths.getSparrowAtlas('ui/' + path);

			animation.addByPrefix('scroll', noteToString[noteData] + ' static');

			animation.addByPrefix('hold', 'hold piece');
			animation.addByPrefix('holdend', 'hold end');

			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
		}

		x += swagWidth * noteData;
		rgbShader.rgb = [arrowColorsRed[noteData], arrowColorsGreen[noteData], arrowColorsBlue[noteData]];

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;

			if (ChillSettings.get('downScroll', GAMEPLAY))
				angle = 180;

			animation.play('holdend');

			updateHitbox();

			if (isPixel)
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play('hold');

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.metadata.speed;
				prevNote.updateHitbox();
			}
		}
		else
			animation.play('scroll');

		shader = rgbShader.shader;
	}

	public function returnColors(note:Int)
	{
		return [arrowColorsRed[note], arrowColorsGreen[note], arrowColorsBlue[note]];
	}
}
package objects.game;

import shaders.RGBShader;
import utils.Song.SwagNote;
import utils.Direction;

class Note extends FlxSprite
{
	public static final NOTE_WIDTH:Float = 160 * 0.7;

	public static final NOTE_COLORS:Array<Array<FlxColor>> = [
		[0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
		[0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
		[0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
		[0xFFF9393F, 0xFFFFFFFF, 0xFF651038]
	];

	public static final NOTE_COLORS_PIXEL:Array<Array<FlxColor>> = [
		[0xFFE276FF, 0xFFFFF9FF, 0xFF60008D],
		[0xFF3DCAFF, 0xFFF4FFFF, 0xFF003060],
		[0xFF71E300, 0xFFF6FFE6, 0xFF003100],
		[0xFFFF884E, 0xFFFFFAF5, 0xFF6C0000]
	];

	public var strums:Strums;

	public var data:SwagNote;
	public var sustain(default, null):SustainNote = null;

	public var isPixel(default, set):Bool = false;

	public var animToPlay:String = '';
	public var lowPriority:Bool = false;

	private var rgbShader:RGBShader = new RGBShader();
	private var curTexture:Null<String> = null;

	public var mayHit:Bool = false;
	public var wasHit:Bool = false;

	public function new(data:SwagNote, isPixel:Bool)
	{
		this.data = data;
		this.isPixel = isPixel;

		super();

		setNoteTypeValues(data.type);

		if (data.length != null && data.length > 1)
			generateSustain(data.length);
	}

	public function setNoteTypeValues(name:String)
	{
		animToPlay = "sing" + (cast(data.direction, Direction)).toString();
		lowPriority = false;

		var texture:String = 'arrows';

		switch (name)
		{
			case 'Alt':
				animToPlay += '-alt';
		}

		reloadNoteTexture(texture);
	}

	public function generateSustain(length:Float)
	{
		sustain = new SustainNote();
		sustain.generateSustain(length, PlayState.SONG.metadata.speed);
		sustain.head = this;
		sustain.shader = rgbShader.shader;
	}

	public function reloadNoteTexture(?path:String = 'arrows')
	{
		if (!Paths.location.exists('ui/notes/' + path))
			path = 'strums';

		if (isPixel)
		{
			loadGraphic(Paths.content.image('pixelui/notes/' + path), true, 17, 17);

			animation.add('scroll', [[0, 1, 2, 3][data.direction]]);

			/*if (isSustainNote)
				{
					loadGraphic(Paths.content.image('pixelui/' + path + 'ENDS'), true, 7, 6);

					animation.add('hold', [0]);
					animation.add('holdend', [1]);
			}*/

			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			antialiasing = false;
			updateHitbox();

			rgbShader.rgb = NOTE_COLORS_PIXEL[data.direction];
		}
		else
		{
			frames = Paths.content.sparrowAtlas('ui/notes/' + path);

			animation.addByPrefix('scroll', (cast(data.direction, Direction)).toString().toLowerCase() + ' static');

			setGraphicSize(Std.int(width * 0.7));
			antialiasing = FlxSprite.defaultAntialiasing;
			updateHitbox();

			rgbShader.rgb = NOTE_COLORS[data.direction];
		}

		animation.play('scroll');

		shader = rgbShader.shader;
	}

	private function set_isPixel(value:Bool):Bool
	{
		isPixel = value;

		if (curTexture != null)
			reloadNoteTexture(curTexture);

		return isPixel;
	}

	public function returnColors():Array<FlxColor>
	{
		return rgbShader.rgb;
	}
}

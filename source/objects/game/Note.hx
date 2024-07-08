package objects.game;

import addons.Song.SwagNote;
import shaders.RGBShader;

class Note extends FlxSprite 
{
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

    public function new(data:SwagNote, isPixel:Bool)
    {
        this.data = data;
        this.isPixel = isPixel;

        if(data.length != null && data.length > 1)
            generateSustain(data.length);

        super();
    }

    public function setNoteTypeValues(name:String)
    {
        animToPlay = "sing" + (cast (data.direction, Direction)).toString();
        lowPriority = false;

        var texture:String = 'Notes';

        switch(name)
        {
            case 'Alt':
                animToPlay += '-alt';
        }

        reloadNoteTexture();
    }

    public function generateSustain(length:Float)
    {
        sustain = new SustainNote();
        sustain.generateSustain(length, PlayState.SONG.metadata.speed);
        sustain.head = this;
        sustain.shader = rgbShader.shader;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if(sustain != null)
        {
            sustain.x = x + ((width - sustain.width) / 2);
            sustain.y = y + (Conductor.stepCrochet * (0.45 * FlxMath.roundDecimal(PlayState.SONG.metadata.speed, 2)));
        }
    }

    public function reloadNoteTexture(?path:String = 'Notes')
    {
        curTexture = path;

        if(isPixel)
        {
            loadGraphic(Paths.image('pixelui/' + path), true, 17, 17);

			animation.add('scroll', [[4, 5, 6, 7][data.direction]]);

			/*if (isSustainNote)
			{
				loadGraphic(Paths.image('pixelui/' + path + 'ENDS'), true, 7, 6);

				animation.add('hold', [0]);
				animation.add('holdend', [1]);
			}*/

            setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			antialiasing = false;
			updateHitbox();

            rgbShader.rgb = NOTE_COLORS[data.direction];
        }
        else
        {
            frames = Paths.getSparrowAtlas('ui/' + path);

			animation.addByPrefix('scroll', (cast (data.direction, Direction)).toString() + ' static');

            setGraphicSize(Std.int(width * 0.7));
            antialiasing = FlxSprite.defaultAntialiasing;
			updateHitbox();

            rgbShader.rgb = NOTE_COLORS_PIXEL[data.direction];
        }

        shader = rgbShader.shader;
    }

    private function set_isPixel(value:Bool):Bool
    {
        isPixel = value;

        if(curTexture != null)
            reloadNoteTexture(curTexture);

        return isPixel;
    }
}
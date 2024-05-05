package display;

import openfl.display.Bitmap;
import flixel.FlxG;
import Math;
import flixel.system.ui.FlxSoundTray;

class FunkinSoundTray extends FlxSoundTray
{
	public var alphaTarget:Float;
	public var lerpYPos:Float;
	public var graphicScale:Float;
	public var volumeMaxSound:String;

    /**
	 * Sets up the "sound tray", the little volume meter that pops down sometimes.
	 */
	@:keep
	public function new()
	{
		alphaTarget = 0;
		lerpYPos = 0;
		graphicScale = 0.30;

		super();

		removeChildren();

		var bg:Bitmap = new Bitmap(Paths.image("soundtray/volumebox"));
		bg.x = 1;
		bg.y = 1;
		bg.scaleX = graphicScale;
        bg.scaleY = graphicScale;
		addChild(bg);

		y = -height;
		visible = false;

		var backingBar:Bitmap = new Bitmap(Paths.image("soundtray/bars_10"));
		backingBar.x = 9;
		backingBar.y = 5;
        backingBar.scaleX = graphicScale;
        backingBar.scaleY = graphicScale;
		addChild(backingBar);

		backingBar.alpha = 0.4;

		_bars = [];

		var _g:Int = 1;
		while (_g < 11)
		{
			var i = _g++;

			var bar = new Bitmap(Paths.image("soundtray/bars_" + i));
			bar.x = 9;
            bar.y = 5;
            bar.scaleX = graphicScale;
            bar.scaleY = graphicScale;
			addChild(bar);

			_bars.push(bar);
		}

		y = -height;
		screenCenter();

		volumeUpSound = Paths.sound("soundtray/Volup");
		volumeDownSound = Paths.sound("soundtray/Voldown");
		volumeMaxSound = Paths.sound("soundtray/VolMAX");
	}

	/**
	 * This function updates the soundtray object.
	 */
	override public function update(MS:Float):Void
	{
		y = CoolUtil.coolLerp(y, lerpYPos, 0.1);
		alpha = CoolUtil.coolLerp(alpha, alphaTarget, 0.25);

		if (_timer > 0)
		{
			_timer -= MS / 1000;
			alphaTarget = 1;
		}
		else if (y >= -height)
		{
			lerpYPos = -height - 10;
			alphaTarget = 0;
		}

		if (y <= -height)
		{
			visible = false;
			active = false;

            #if FLX_SAVE
			if (FlxG.save.isBound)
			{
				FlxG.save.data.mute = FlxG.sound.muted;
				FlxG.save.data.volume = FlxG.sound.volume;
				FlxG.save.flush();
			}
            #end
		}
	}

	/**
	 * Makes the little volume tray slide out.
	 *
	 * @param	up Whether the volume is increasing.
	 */
	override public function show(up:Bool = false):Void
	{
		_timer = 1;
		lerpYPos = 10;
		visible = true;
		active = true;

		var globalVolume:Int = Math.round(FlxG.sound.volume * 10);

		if (FlxG.sound.muted)
			globalVolume = 0;

		if (!silent)
		{
			var sound = up ? volumeUpSound : volumeDownSound;

			if (globalVolume == 10)
				sound = volumeMaxSound;

			if (sound != null)
				FlxG.sound.load(sound).play();
		}

		var _g:Int = 0;
		var _g1:Int = _bars.length;

		while (_g < _g1)
		{
			var i = _g++;

			if (i < globalVolume)
				_bars[i].visible = true;
			else
				_bars[i].visible = false;
		}
	}
}
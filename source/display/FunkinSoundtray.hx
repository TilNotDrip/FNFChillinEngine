package display;

import openfl.Assets;
import openfl.display.Bitmap;
import flixel.FlxG;
import flixel.system.ui.FlxSoundTray;

/**
 * Extends the default flixel soundtray, but with some art
 * and lil polish!
 *
 * Gets added to the game in Main.hx, right after FlxGame is new'd
 * since it's a Sprite rather than Flixel related object
 */
class FunkinSoundTray extends FlxSoundTray
{
	var graphicScale:Float = 0.30;
	var lerpYPos:Float = 0;
	var alphaTarget:Float = 0;

	var volumeMaxSound:String;

	public function new()
	{
		super();

		removeChildren();

		var bg:Bitmap = new Bitmap(Assets.getBitmapData(Paths.location.image('soundtray/volumebox')));
		bg.x = 1;
		bg.y = 1;
		bg.scaleX = graphicScale;
		bg.scaleY = graphicScale;
		bg.smoothing = true;
		addChild(bg);

		y = -height;
		visible = false;

		var backingBar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.location.image('soundtray/bars_10')));
		backingBar.x = 9;
		backingBar.y = 5;
		backingBar.scaleX = graphicScale;
		backingBar.scaleY = graphicScale;
		bg.smoothing = true;
		addChild(backingBar);

		backingBar.alpha = 0.4;

		_bars = [];

		for (i in 1...11)
		{
			var bar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.location.image('soundtray/bars_$i')));
			bar.x = 9;
			bar.y = 5;
			bar.scaleX = graphicScale;
			bar.scaleY = graphicScale;
			bg.smoothing = true;
			addChild(bar);

			_bars.push(bar);
		}

		y = -height;
		screenCenter();

		volumeUpSound = Paths.location.sound("soundtray/Volup");
		volumeDownSound = Paths.location.sound("soundtray/Voldown");
		volumeMaxSound = Paths.location.sound("soundtray/VolMAX");
	}

	override public function update(elapsed:Float):Void
	{
		y = CoolUtil.coolLerp(y, lerpYPos, 0.1);
		alpha = CoolUtil.coolLerp(alpha, alphaTarget, 0.25);

		if (_timer > 0)
		{
			_timer -= (elapsed / 1000);
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
	 * @param up Whether the volume is increasing.
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
			var sound:String = up ? volumeUpSound : volumeDownSound;

			if (globalVolume == 10)
				sound = volumeMaxSound;

			if (sound != null)
				FlxG.sound.load(sound).play();
		}

		for (i in 0..._bars.length)
		{
			if (i < globalVolume)
				_bars[i].visible = true;
			else
				_bars[i].visible = false;
		}
	}
}

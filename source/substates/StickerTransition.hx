package substates;

import openfl.geom.Rectangle;
import flixel.math.FlxPoint;
import openfl.utils.Assets;
import haxe.Json;
import flixel.util.FlxSort;
import openfl.display.DisplayObject;
import flixel.addons.transition.FlxTransitionableState;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import flixel.util.FlxSignal;
import flixel.FlxState;
import openfl.display.Sprite;

class StickerTransition extends Sprite
{
	public static function switchState(targetState:FlxState)
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		var stickerGroup:StickerTransition = new StickerTransition();
		FlxG.addChildBelowMouse(stickerGroup);

		stickerGroup.generateStickers().add(function()
		{
			FlxG.switchState(targetState);
			targetState.persistentUpdate = false;

			FlxG.signals.preStateCreate.addOnce(function(_)
			{
				FlxG.addChildBelowMouse(stickerGroup);
				stickerGroup.removeStickers().add(function()
				{
					targetState.persistentUpdate = true;
					FlxG.removeChild(stickerGroup);
				});
			});
		});
	}

	private var spriteToTiming:Map<DisplayObject, Float> = new Map<DisplayObject, Float>();
	private var sounds:Array<String> = [];

	public function new()
	{
		super();

		sounds = getSounds();
	}

	public function generateStickers():FlxSignal
	{
		var stickerInfo:StickerInfo = new StickerInfo('stickers-set-1');
		var stickers:Map<String, Array<String>> = new Map<String, Array<String>>();
		for (stickerSets in stickerInfo.getPack("all"))
		{
			stickers.set(stickerSets, stickerInfo.getStickers(stickerSets));
		}

		var xPos:Float = -100;
		var yPos:Float = -100;
		while (xPos <= FlxG.width)
		{
			var stickerSet:String = FlxG.random.getObject(stickers.keyValues());
			var sticker:String = FlxG.random.getObject(stickers.get(stickerSet));

			var stickyBitmap:BitmapData = Assets.getBitmapData(Paths.location.image('transitionSwag/' + stickerInfo.name + '/' + sticker));
			var sticky:BetterBitmap = new BetterBitmap(stickyBitmap);
			addChild(sticky);

			sticky.x = xPos;
			sticky.y = yPos;
			xPos += stickyBitmap.width * 0.5;

			if (xPos >= FlxG.width)
			{
				if (yPos <= FlxG.height)
				{
					xPos = -100;
					yPos += FlxG.random.float(70, 120);
				}
			}

			sticky.rotation = FlxG.random.int(-60, 70);
			sticky.visible = false;
		}

		FlxG.random.shuffle(__children);

		var finishedSignal:FlxSignal = new FlxSignal();

		for (ind => sticker in __children)
		{
			var timing:Float = FlxMath.remapToRange(ind, 0, __children.length, 0, 0.9);
			spriteToTiming.set(sticker, timing);

			new FlxTimer().start(timing, function(_)
			{
				sticker.visible = true;
				var daSound:String = FlxG.random.getObject(sounds);
				FlxG.sound.play(Paths.location.sound(daSound));

				var frameTimer:Int = FlxG.random.int(0, 2);

				// always make the last one POP
				if (ind == __children.length - 1)
					frameTimer = 2;

				new FlxTimer().start((1 / 24) * frameTimer, function(__)
				{
					sticker.scaleX = sticker.scaleY = FlxG.random.float(0.97, 1.02);

					if (ind == __children.length - 1)
						finishedSignal.dispatch();
				});
			});
		}

		__children.sort(function(a, b)
		{
			return FlxSort.byValues(FlxSort.ASCENDING, spriteToTiming.get(a), spriteToTiming.get(b));
		});

		// centers the very last sticker
		var lastOne:DisplayObject = __children[__children.length - 1];
		lastOne.rotation = 0;

		lastOne.x = (FlxG.width - lastOne.width) / 2;
		lastOne.y = (FlxG.height - lastOne.height) / 2;

		return finishedSignal;
	}

	public function removeStickers():FlxSignal
	{
		var finishedSignal:FlxSignal = new FlxSignal();

		for (ind => sticker in __children)
		{
			new FlxTimer().start(spriteToTiming.get(sticker), function(_)
			{
				sticker.visible = false;
				var daSound:String = FlxG.random.getObject(sounds);
				FlxG.sound.play(Paths.location.sound(daSound));

				if (ind == __children.length - 1)
					finishedSignal.dispatch();
			});
		}

		return finishedSignal;
	}

	private static var soundSelections:Array<String> = null;

	private function getSounds():Array<String>
	{
		// all assets.
		var assetsInList = openfl.utils.Assets.list();

		// what "folder" was randomly selected
		var soundSelection:String = "";
		var sounds:Array<String> = [];

		if (soundSelections == null)
		{
			soundSelections = assetsInList.filter(function(a:String)
			{
				return a.startsWith('assets/shared/sounds/stickersounds/');
			});

			soundSelections = soundSelections.map(function(a:String)
			{
				return a.replace('assets/shared/sounds/stickersounds/', '').split('/')[0];
			});

			// cracked cleanup... yuchh...
			for (i in soundSelections)
			{
				while (soundSelections.contains(i))
				{
					soundSelections.remove(i);
				}
				soundSelections.push(i);
			}
		}

		soundSelection = FlxG.random.getObject(soundSelections);

		sounds = assetsInList.filter(function(a:String)
		{
			return a.startsWith('assets/shared/sounds/stickersounds/' + soundSelection + '/');
		});

		for (i in 0...sounds.length)
		{
			sounds[i] = sounds[i].replace('assets/shared/sounds/', '');
			sounds[i] = sounds[i].substring(0, sounds[i].lastIndexOf('.'));
		}

		return sounds;
	}
}

class BetterBitmap extends openfl.display.Bitmap
{
	private var offsetScale:FlxPoint = FlxPoint.get();
	private var offsetRotation:FlxPoint = FlxPoint.get();

	override public function set_scaleX(value:Float)
	{
		var daReturn:Float = super.set_scaleX(value);
		centerSpriteScale(daReturn, null);
		return daReturn;
	}

	override public function set_scaleY(value:Float)
	{
		var daReturn:Float = super.set_scaleY(value);
		centerSpriteScale(null, daReturn);
		return daReturn;
	}

	override public function set_rotation(value:Float)
	{
		centerSpriteRotate(value);
		return super.set_rotation(value);
	}

	public function centerSpriteScale(scaleX:Null<Float>, scaleY:Null<Float>)
	{
		if (scaleX == null)
			scaleX = this.scaleX;

		if (scaleY == null)
			scaleY = this.scaleY;

		offsetScale = offsetScale.set((-x * scaleX + x), (-y * scaleY + y));

		set_x(x);
		set_y(y);
	}

	public function centerSpriteRotate(rotation:Float)
	{
		// stolen from http://hakomike.blogspot.com.ar/2013/11/arbitrary-center-bitmap-rotation-in.html

		var rect:Rectangle = getBounds(parent);
		var mymatrix:Matrix = new Matrix();
		mymatrix.rotate(Math.PI * rotation / 180);

		var newpoint:flash.geom.Point = mymatrix.transformPoint(new flash.geom.Point(rect.width / 2, rect.height / 2));

		offsetRotation = offsetRotation.set(-newpoint.x, -newpoint.y);

		set_x(x);
		set_y(y);
	}

	override public function set_x(value:Float)
	{
		return super.set_x(value + (offsetScale + offsetRotation).x) - (offsetScale + offsetRotation).x;
	}

	override public function set_y(value:Float)
	{
		return super.set_y(value + (offsetScale + offsetRotation).y) - (offsetScale + offsetRotation).y;
	}

	override public function get_x()
	{
		return super.get_x() - (offsetScale + offsetRotation).x;
	}

	override public function get_y()
	{
		return super.get_y() - (offsetScale + offsetRotation).y;
	}
}

class StickerInfo
{
	public var name:String;
	public var artist:String;
	public var stickers:Map<String, Array<String>>;
	public var stickerPacks:Map<String, Array<String>>;

	public function new(stickerSet:String):Void
	{
		var json:Dynamic = Json.parse(Paths.content.json('images/transitionSwag/' + stickerSet + '/stickers'));

		// doin this dipshit nonsense cuz i dunno how to deal with casting a json object with
		// a dash in its name (sticker-packs)
		var jsonInfo:StickerShit = cast json;

		this.name = jsonInfo.name;
		this.artist = jsonInfo.artist;

		stickerPacks = new Map<String, Array<String>>();

		for (field in Reflect.fields(json.stickerPacks))
		{
			var stickerFunny = json.stickerPacks;
			var stickerStuff = Reflect.field(stickerFunny, field);

			stickerPacks.set(field, cast stickerStuff);
		}

		// creates a similar for loop as before but for the stickers
		stickers = new Map<String, Array<String>>();

		for (field in Reflect.fields(json.stickers))
		{
			var stickerFunny = json.stickers;
			var stickerStuff = Reflect.field(stickerFunny, field);

			stickers.set(field, cast stickerStuff);
		}
	}

	public function getStickers(stickerName:String):Array<String>
	{
		return this.stickers[stickerName];
	}

	public function getPack(packName:String):Array<String>
	{
		return this.stickerPacks[packName];
	}
}

// somethin damn cute just for the json to cast to!
typedef StickerShit =
{
	name:String,
	artist:String,
	stickers:Map<String, Array<String>>,
	stickerPacks:Map<String, Array<String>>
}

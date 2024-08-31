package funkin.objects.game;

import json2object.JsonParser;
import funkin.structures.IconStructure;

class HealthIcon extends TrackedSprite
{
	public var curHealthBarColor:FlxColor;
	public var metadata:IconStructure;

	public var char:String = '';
	public var isPlayer:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		this.isPlayer = flipX = isPlayer;

		sprOffsetX = 10;
		sprOffsetY = -30;

		changeIcon(char);
		scrollFactor.set();
	}

	private var isOldIcon:Bool = false;
	private var iconBeforeOldChange:String;

	public function swapOldIcon():Void
	{
		isOldIcon = !isOldIcon;

		var iconChange:String;
		if (isOldIcon)
		{
			iconBeforeOldChange = char;
			iconChange = 'bf-old';
		}
		else
			iconChange = iconBeforeOldChange;

		changeIcon(iconChange);
	}

	public function changeIcon(newChar:String):Void
	{
		var metadataText:String = Paths.content.jsonText('images/icons/$newChar');

		if (metadataText == null)
		{
			trace('[ERROR]: Unable to load the Icon Metadata of $newChar! Maybe it doesnt exist? Falling Back to Default...');

			newChar = 'face';
			metadataText = Paths.content.jsonText('images/icons/$newChar');

			if (metadataText == null)
			{
				trace('[FATAL ERROR]: Tried loading metadata for default icon, but it failed! [$newChar] Loading HaxeFlixel image...');
				loadGraphic("flixel/images/logo/default.png");
				setGraphicSize(150, 150);
				antialiasing = false;
				return;
			}
		}

		metadata = cast new JsonParser<IconStructure>().fromJson(metadataText);

		if (metadata.resolution != null)
			loadGraphic(Paths.content.imageGraphic('icons/' + newChar), true, metadata.resolution[0], metadata.resolution[1]);
		else
			frames = Paths.content.sparrowAtlas('icons/' + newChar);

		curHealthBarColor = FlxColor.fromString(metadata.color);

		if (FunkinOptions.get('antialiasing'))
			antialiasing = metadata.antialiasing;

		for (anim in metadata.animations)
		{
			if (metadata.resolution != null)
				animation.add(anim.name, anim.indices, anim.framerate, anim.looped, anim.flipX, anim.flipY);
			else
			{
				if (anim.indices.length != 0)
					animation.addByIndices(anim.name, anim.prefix, anim.indices, '', anim.framerate, anim.looped, anim.flipX, anim.flipY);
				else
					animation.addByPrefix(anim.name, anim.prefix, anim.framerate, anim.looped, anim.flipX, anim.flipY);
			}

			trace(anim);
		}

		updateIconAnimation(50);
	}

	public dynamic function bop():Void
	{
		if (metadata == null || !metadata.shouldBop)
			return;

		FlxTween.tween(scale, {x: 1.3, y: 1.3}, (Conductor.crochet / 1000) * 0.1, {ease: FlxEase.cubeIn});
		FlxTween.tween(scale, {x: 1, y: 1}, (Conductor.crochet / 1000) * 0.9, {ease: FlxEase.cubeOut, startDelay: (Conductor.crochet / 1000) * 0.1});
	}

	public function updateIconAnimation(health:Float):Void
	{
		if (metadata == null)
			return;

		for (check in metadata.healthAnimations)
		{
			if (animation.curAnim != null && animation.curAnim.name == check.anim)
				continue;

			if (check.goesUnder)
			{
				if (health < check.atHealth)
					animation.play(check.anim, true);
			}
			else if (health >= check.atHealth)
				animation.play(check.anim, true);
		}
	}
}

package funkin.objects;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxStringUtil;

class Alphabet extends FlxTypedSpriteGroup<AtlasChar>
{
	static var fonts = new Map<AtlasFont, AtlasFontData>();
	static var casesAllowed = new Map<AtlasFont, Case>();

	public var text(default, set):String = "";

	var font:AtlasFontData;

	public var targetY:Float = 0;
	public var isMenuItem:Bool = false;

	public var atlas(get, never):FlxAtlasFrames;

	inline function get_atlas()
		return font.atlas;

	public var caseAllowed(get, never):Case;

	inline function get_caseAllowed()
		return font.caseAllowed;

	public var maxHeight(get, never):Float;

	inline function get_maxHeight()
		return font.maxHeight;

	public function new(x = 0.0, y = 0.0, text:String, fontName:AtlasFont = Default)
	{
		if (!fonts.exists(fontName))
			fonts[fontName] = new AtlasFontData(fontName);

		font = fonts[fontName];

		super(x, y);

		this.text = text;
	}

	function set_text(value:String)
	{
		if (value == null)
			value = "";

		var caseValue = restrictCase(value);
		var caseText = restrictCase(this.text);

		this.text = value;
		if (caseText == caseValue)
			return value;

		if (caseValue.indexOf(caseText) == 0)
		{
			appendTextCased(caseValue.substr(caseText.length));
			return this.text;
		}

		value = caseValue;

		group.kill();

		if (value == "")
			return this.text;

		appendTextCased(caseValue);
		return this.text;
	}

	/**
	 * Adds new characters, without needing to redraw the previous characters
	 * @param text The text to add.
	 * @throws String if `text` is null.
	 */
	public function appendText(text:String)
	{
		if (text == null)
			throw "cannot append null";

		if (text == "")
			return;

		this.text = this.text + text;
	}

	/**
	 * Converts all characters to fit the font's `allowedCase`.
	 * @param text 
	 */
	function restrictCase(text:String)
	{
		return switch (caseAllowed)
		{
			case Both: text;
			case Upper: text.toUpperCase();
			case Lower: text.toLowerCase();
		}
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			y = CoolUtil.coolLerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
			x = CoolUtil.coolLerp(x, (targetY * 20) + 90, 0.16);
		}

		super.update(elapsed);
	}

	/**
	 * Adds new text on top of the existing text. Helper for other methods; DOESN'T CHANGE `this.text`.
	 * @param text The text to add, assumed to match the font's `caseAllowed`.
	 */
	function appendTextCased(text:String)
	{
		var charCount = group.countLiving();
		var xPos:Float = 0;
		var yPos:Float = 0;

		if (charCount == -1)
			charCount = 0;
		else if (charCount > 0)
		{
			var lastChar = group.members[charCount - 1];
			xPos = lastChar.x + lastChar.width - x;
			yPos = lastChar.y + lastChar.height - maxHeight - y;
		}

		var splitValues = text.split("");
		for (i in 0...splitValues.length)
		{
			switch (splitValues[i])
			{
				case " ":
					xPos += 40;

				case "\n":
					xPos = 0;
					yPos += maxHeight;

				case char:
					var charSprite:AtlasChar;

					if (group.members.length <= charCount)
						charSprite = new AtlasChar(atlas, char);
					else
					{
						charSprite = group.members[charCount];
						charSprite.revive();
						charSprite.char = char;
						charSprite.alpha = 1;
					}

					charSprite.x = xPos;
					charSprite.y = yPos + maxHeight - charSprite.height;
					add(charSprite);

					xPos += charSprite.width;
					charCount++;
			}
		}
	}

	override function toString()
	{
		return "InputItem, " + FlxStringUtil.getDebugString([
			LabelValuePair.weak("x", x),
			LabelValuePair.weak("y", y),
			LabelValuePair.weak("text", text)
		]);
	}
}

class AtlasChar extends FlxSprite
{
	public var char(default, set):String;

	public function new(x = 0.0, y = 0.0, atlas:FlxAtlasFrames, char:String)
	{
		super(x, y);
		frames = atlas;
		this.char = char;
		antialiasing = true;
	}

	function set_char(value:String)
	{
		if (this.char != value)
		{
			var prefix = getAnimPrefix(value);
			animation.addByPrefix("anim", prefix, 24);
			animation.play("anim");
			updateHitbox();
		}

		return this.char = value;
	}

	function getAnimPrefix(char:String)
	{
		return switch (char)
		{
			/*case "×": '-times-';
				case "<3": '-heart-';
				case ">:(": '-angry-';
				case "<-": '-left-';
				case "->": '-right-'; */

			case "\\": '-slash-backward-';
			case "/": '-slash-forward-';
			default: char;
		}
	}
}

class AtlasFontData
{
	public static var upperChar = ~/^[A-Z]\d+$/;
	public static var lowerChar = ~/^[a-z]\d+$/;

	public var atlas:FlxAtlasFrames;
	public var maxHeight:Float = 0.0;
	public var caseAllowed:Case = Both;

	public function new(name:AtlasFont)
	{
		atlas = Paths.getSparrowAtlas("fonts/" + name.getName().formatToPath());
		atlas.parent.destroyOnNoUse = false;
		atlas.parent.persist = true;

		var containsUpper = false;
		var containsLower = false;

		for (frame in atlas.frames)
		{
			maxHeight = Math.max(maxHeight, frame.frame.height);

			if (!containsUpper)
				containsUpper = upperChar.match(frame.name);

			if (!containsLower)
				containsLower = lowerChar.match(frame.name);
		}

		if (containsUpper != containsLower)
			caseAllowed = containsUpper ? Upper : Lower;
	}
}

enum Case
{
	Both;
	Upper;
	Lower;
}

enum AtlasFont
{
	Default;
	Bold;
}

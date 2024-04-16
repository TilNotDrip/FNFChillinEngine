package objects;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxStringUtil;

class Alphabet extends FlxTypedSpriteGroup<AtlasChar>
{
	static var fonts = new Map<AtlasFont, AtlasFontData>();
	static var casesAllowed = new Map<AtlasFont, Case>();
	public var text(default, set):String = "";
	
	var font:AtlasFontData;

	// for menu shit
	public var targetY:Float = 0;
	public var isMenuItem:Bool = false;

	public var text:String = "";

	private var _finalText:String = "";
	private var _curText:String = "";

	public var widthOfWords:Float = FlxG.width;

	private var yMulti:Float = 1;

	private var lastSprite:AlphaCharacter;
	private var xPosResetted:Bool = false;
	private var lastWasSpace:Bool = false;

	private var lastSplittedWords:Array<String> = [];
	private var splitWords:Array<String> = [];

	private var isBold:Bool = false;

	public function new(x:Float = 0.0, y:Float = 0.0, text:String = "", ?bold:Bool = false, typed:Bool = false)
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
			return value; // cancel redraw
		
		if (caseValue.indexOf(caseText) == 0)
		{
			// new text is just old text with additions at the end, append the difference
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
		doSplitWords();

		var xPos:Float = 0;
		var curRow:Int = 0;

		for (character in splitWords)
		{
			if (AlphaCharacter.alphabet.indexOf(character.toLowerCase()) != -1)
			{
				if (lastSprite != null)
					xPos = lastSprite.x + lastSprite.width;

				if (lastWasSpace)
				{
					xPos += 40;
					lastWasSpace = false;
				}

				var letter:AlphaCharacter = new AlphaCharacter(xPos, 55 * curRow);

				if (isBold)
					letter.createBold(character);
				else
					letter.createLetter(character);

				add(letter);

				lastSprite = letter;
			} 
			else
			{
				switch(character.toLowerCase())
				{
					case '\n':
						curRow++;
					case ' ':
						lastWasSpace = true;
				}
			}
		}
	}

	private function doSplitWords():Void
	{
		lastSplittedWords = splitWords.copy();
		splitWords = _finalText.split("");
	}

	public var personTalking:String = 'gf';

	public function startTypedText():Void
	{
		_finalText = text;
		doSplitWords();

		var loopNum:Int = 0;

		var xPos:Float = 0;
		var curRow:Int = 0;

		new FlxTimer().start(0.05, function(tmr:FlxTimer)
		{
			if (_finalText.fastCodeAt(loopNum) == "\n".code)
			{
				yMulti += 1;
				xPosResetted = true;
				xPos = 0;
				curRow += 1;
			}

			if (splitWords[loopNum] == " ")
			{
				lastWasSpace = true;
			}

			var isNumber:Bool = AlphaCharacter.numbers.indexOf(splitWords[loopNum]) != -1;
			var isSymbol:Bool = AlphaCharacter.symbols.indexOf(splitWords[loopNum]) != -1;

			if (AlphaCharacter.alphabet.indexOf(splitWords[loopNum].formatToPath()) != -1 || isNumber || isSymbol)
			{
				if (lastSprite != null && !xPosResetted)
				{
					lastSprite.updateHitbox();
					xPos += lastSprite.width + 3;
				}
				else
				{
					xPosResetted = false;
				}

				if (lastWasSpace)
				{
					xPos += 20;
					lastWasSpace = false;
				}

				var letter:AlphaCharacter = new AlphaCharacter(xPos, 55 * yMulti);
				if (isBold)
				{
					letter.createBold(splitWords[loopNum]);
				}
				else
				{
					if (isNumber)
					{
						letter.createNumber(splitWords[loopNum]);
					}
					else if (isSymbol)
					{
						letter.createSymbol(splitWords[loopNum]);
					}
					else
					{
						letter.createLetter(splitWords[loopNum]);
					}

					letter.x += 90;
				}

				add(letter);

				lastSprite = letter;
			}

			loopNum += 1;

			tmr.time = FlxG.random.float(0.04, 0.09);
		}, splitWords.length);
	}

	override public function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			y = CoolUtil.coolLerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
			x = CoolUtil.coolLerp(x, (targetY * 20) + 90, 0.16);
		}
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
		// `countLiving` returns -1 if group is empty
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
			switch(splitValues[i])
			{
				case " ":
				{
					xPos += 40;
				}
				case "\n":
				{
					xPos = 0;
					yPos += maxHeight;
				}
				case char:
				{
					var charSprite:AtlasChar;
					if (group.members.length <= charCount)
						charSprite = new AtlasChar(atlas, char);
					else
					{
						charSprite = group.members[charCount];
						charSprite.revive();
						charSprite.char = char;
						charSprite.alpha = 1;//gets multiplied when added
					}
					charSprite.x = xPos;
					charSprite.y = yPos + maxHeight - charSprite.height;
					add(charSprite);
					
					xPos += charSprite.width;
					charCount++;
				}
			}
		}
	}
	
	override function toString()
	{
		return "InputItem, " + FlxStringUtil.getDebugString(
			[ LabelValuePair.weak("x", x)
			, LabelValuePair.weak("y", y)
			, LabelValuePair.weak("text", text)
			]
		);
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
			case '-': '-dash-';
			case '.': '-period-';
			case ",": '-comma-';
			case "'": '-apostraphie-';
			case "?": '-question mark-';
			case "!": '-exclamation point-';
			case "\\": '-back slash-';
			case "/": '-forward slash-';
			case "*": '-multiply x-';
			case "“": '-start quote-';
			case "”": '-end quote-';
			default: char;
		}
	}
}

private class AtlasFontData
{
	static public var upperChar = ~/^[A-Z]\d+$/;
	static public var lowerChar = ~/^[a-z]\d+$/;
	
	public var atlas:FlxAtlasFrames;
	public var maxHeight:Float = 0.0;
	public var caseAllowed:Case = Both;
	
	public function new (name:AtlasFont)
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
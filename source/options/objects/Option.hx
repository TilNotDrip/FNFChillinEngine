package options.objects;

import flixel.group.FlxSpriteGroup;
import objects.menu.Checkbox;
import objects.menu.MenuAlphabet;

class Option extends FlxSpriteGroup
{
	public var description:String;
	public var varName:String;
	public var type:OptionVarType;
	public var value:Dynamic;

	public var selections:Array<String>;

	public var numType:Dynamic;

	public var minimumValue:Dynamic;
	public var maximumValue:Dynamic;

	public var onChange:Void->Void = null;

	public var optionTxt:MenuAlphabet;

	private var checkbox:Checkbox;
	private var selection:Alphabet;
	private var number:Alphabet;

	public function new(name:String, description:String, varName:String, type:OptionVarType)
	{
		this.description = description;
		this.varName = varName;
		this.type = type;

		value = ChillSettings.get(varName);

		super(x, y);

		optionTxt = new MenuAlphabet(0, 0, name, BOLD);
		add(optionTxt);

		switch (type)
		{
			case CHECKBOX:
				checkbox = new Checkbox();
				checkbox.sprTracker = optionTxt;
				checkbox.sprOffsetX = 50;
				checkbox.check(ChillSettings.get(varName));
				checkbox.animation.finish();
				add(checkbox);

			case SLIDER:

			case SELECTION:
				selection = new Alphabet(optionTxt.x + optionTxt.width + 50, 0, '< $value >', DEFAULT);
				add(selection);

			case NUMBER:
				number = new Alphabet(optionTxt.x + optionTxt.width + 50, 0, '< $value >', DEFAULT);
				add(number);
		}
	}

	override function update(elapsed:Float)
	{
		switch (type)
		{
			case CHECKBOX:
			case SLIDER:
			case SELECTION:
				selection.setPosition((optionTxt.x + optionTxt.width) + 50, optionTxt.y + 0);
			case NUMBER:
				number.setPosition((optionTxt.x + optionTxt.width) + 50, optionTxt.y + 0);
		}

		super.update(elapsed);
	}

	public function press()
	{
		value = !value;
		ChillSettings.set(varName, value);

		checkbox.check(value);

		if (onChange != null)
			onChange();
	}

	public function changeValue(change:Dynamic)
	{
		if (type == NUMBER)
		{
			var newValue:Dynamic = change + ChillSettings.get(varName);

			if (maximumValue <= newValue || minimumValue <= newValue)
				ChillSettings.set(varName, newValue);

			number.text = '< ' + ChillSettings.get(varName) + ' >';
		}
		else if (type == SELECTION)
		{
			var curSelectedNum:Int = selections.indexOf(ChillSettings.get(varName));

			curSelectedNum += change;

			if (curSelectedNum < 0)
				curSelectedNum = selections.length - 1;

			if (curSelectedNum >= selections.length)
				curSelectedNum = 0;

			ChillSettings.set(varName, selections[curSelectedNum]);
			selection.text = '< ' + ChillSettings.get(varName) + ' >';
		}

		if (onChange != null)
			onChange();
	}
}

enum abstract OptionVarType(Int)
{
	var CHECKBOX = 0;
	var SLIDER = 1;
	var SELECTION = 2;
	var NUMBER = 3;
}

// I dont wanna add this to todo but I wanna add this
class Category extends FlxSprite {}

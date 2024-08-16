package funkin.objects.menu;

import flixel.group.FlxSpriteGroup;

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

	public var optionTxt:Alphabet;

	var checkbox:Checkbox;
	var selection:Alphabet;
	var number:Alphabet;

	public function new(name:String, description:String, varName:String, type:OptionVarType)
	{
		this.description = description;
		this.varName = varName;
		this.type = type;

		value = FunkinOptions.get(varName);

		super(x, y);

		optionTxt = new Alphabet(0, 0, name, Bold);
		add(optionTxt);

		switch (type)
		{
			case CHECKBOX:
				checkbox = new Checkbox(optionTxt.x + optionTxt.width + 50, 0);
				checkbox.check(FunkinOptions.get(varName));
				checkbox.animation.finish();
				add(checkbox);

			case SELECTION:
				selection = new Alphabet(optionTxt.x + optionTxt.width + 50, 0, '< $value >', Default);
				add(selection);

			case NUMBER:
				number = new Alphabet(optionTxt.x + optionTxt.width + 50, 0, '< $value >', Default);
				add(number);

			default:
		}
	}

	override public function update(elapsed:Float):Void
	{
		switch (type)
		{
			case CHECKBOX:
				checkbox.setPosition(optionTxt.x + optionTxt.width + 50, optionTxt.y);

			case SELECTION:
				selection.setPosition((optionTxt.x + optionTxt.width) + 50, optionTxt.y);

			case NUMBER:
				number.setPosition((optionTxt.x + optionTxt.width) + 50, optionTxt.y);

			default:
		}

		super.update(elapsed);
	}

	public function press()
	{
		value = !value;

		FunkinOptions.set(varName, value);

		checkbox.check(value);

		if (onChange != null)
			onChange();
	}

	public function changeValue(change:Dynamic)
	{
		switch (type)
		{
			case NUMBER:
				var newValue:Dynamic = change + FunkinOptions.get(varName);

				if (maximumValue >= newValue && minimumValue <= newValue)
					FunkinOptions.set(varName, newValue);

				number.text = '< ' + FunkinOptions.get(varName) + ' >';

			case SELECTION:
				var curSelectedNum:Int = selections.indexOf(FunkinOptions.get(varName));

				curSelectedNum += change;

				if (curSelectedNum < 0)
					curSelectedNum = selections.length - 1;

				if (curSelectedNum >= selections.length)
					curSelectedNum = 0;

				FunkinOptions.set(varName, selections[curSelectedNum]);
				selection.text = '< ' + FunkinOptions.get(varName) + ' >';

			default:
		}

		if (onChange != null)
			onChange();
	}
}

enum abstract OptionVarType(String)
{
	var CHECKBOX = 'checkbox';
	var SLIDER = 'slider';
	var SELECTION = 'selection';
	var NUMBER = 'number';
}

// I dont wanna add this to todo but I wanna add this
class Category extends FlxSprite {}

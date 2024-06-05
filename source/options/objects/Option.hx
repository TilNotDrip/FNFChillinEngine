package options.objects;

import objects.menu.Checkbox;
import flixel.group.FlxSpriteGroup;

class Option extends FlxSpriteGroup
{
    public var description:String;
    public var varName:String;
    public var category:OptionType;
    public var type:OptionVarType;
    public var value:Dynamic;

    public var selections:Array<String>;

    public var numType:Dynamic;

    public var minimumValue:Dynamic;
    public var maximumValue:Dynamic;

    public var onChange:Void->Void = null;

    private var checkbox:Checkbox;
    private var selection:Alphabet;
    private var number:Alphabet;

    public function new(name:String, description:String, varName:String, category:OptionType, type:OptionVarType)
    {
        this.description = description;
        this.varName = varName;
        this.category = category;
        this.type = type;

        value = ChillSettings.get(varName, category);

        super(x, y);

        var optionTxt:Alphabet = new Alphabet(0, 0, name, BOLD);
        add(optionTxt);

        switch(type)
        {
            case CHECKBOX:
                checkbox = new Checkbox();
                checkbox.sprTracker = optionTxt;
                checkbox.sprOffsetX = 50;
                checkbox.check(ChillSettings.get(varName, category));
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

    public function press()
    {
        value = !value;
        ChillSettings.set(varName, category, value);

        checkbox.check(value);

        if(onChange != null)
            onChange();
    }

    public function changeValue(change:Dynamic)
    {
        if (type == NUMBER)
        {
            var newValue:Dynamic = change + ChillSettings.get(varName, category);

            if (maximumValue <= newValue || minimumValue <= newValue)
                ChillSettings.set(varName, category, newValue);

            number.text = '< ' + ChillSettings.get(varName, category) + ' >';
        }
        else if (type == SELECTION)
        {
            var curSelectedNum:Int = selections.indexOf(ChillSettings.get(varName, category));

            curSelectedNum += change;

            if (curSelectedNum < 0)
                curSelectedNum = selections.length - 1;

            if (curSelectedNum >= selections.length)
                curSelectedNum = 0;

            ChillSettings.set(varName, category, selections[curSelectedNum]);
            selection.text = '< ' + ChillSettings.get(varName, category) + ' >';
        }

        if(onChange != null)
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
class Category extends FlxSprite
{
    
}
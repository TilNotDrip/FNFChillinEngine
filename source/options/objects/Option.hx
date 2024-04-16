package options.objects;

import flixel.group.FlxSpriteGroup;

class Option extends FlxSpriteGroup
{
    public var description:String;
    public var varName:String;
    public var category:OptionType;
    public var type:OptionVarType;
    public var value:Dynamic;

    public var numType:Dynamic;

    public var minimumValue:Dynamic;
    public var maximumValue:Dynamic;

    public var onChange:Void->Void = null;

    private var checkbox:Checkbox;
    private var number:Alphabet;

    public function new(name:String, description:String, varName:String, category:OptionType, type:OptionVarType)
    {
        this.description = description;
        this.varName = varName;
        this.category = category;
        this.type = type;

        value = ChillSettings.get(varName, category);

        super(x, y);

        var optionTxt:Alphabet = new Alphabet(0, 0, name, Bold);
        add(optionTxt);

        switch(type)
        {
            case CHECKBOX:
                checkbox = new Checkbox(optionTxt.x + optionTxt.width + 50, 0);
                checkbox.check(ChillSettings.get(varName, category));
                add(checkbox);

            case SLIDER:
                trace('slider!');

            case SELECTION:
                trace('selection!');

            case NUMBER:
                number = new Alphabet(optionTxt.x + optionTxt.width + 50, 0, value, Default);
                add(number);
        }
    }

    public function press()
    {
        if(type != CHECKBOX)
        {
            FlxG.log.error('Press can be used on checkboxes only.');
            return;
        }

        value = !value;
        ChillSettings.set(varName, category, value);

        checkbox.check(value);

        if(onChange != null) //I WISH THIS COULD CHECK FOR ITSELF
            onChange();
    }

    public function changeValue(change:Dynamic)
    {
        var newValue:Dynamic = change + ChillSettings.get(varName, category);

        if (maximumValue <= newValue || minimumValue <= newValue)
            ChillSettings.set(varName, category, newValue);

        switch(type)
        {
            case CHECKBOX:
                throw 'changeValue cant be used on press';
            case SELECTION:
                throw 'changeValue cant be used on selection';
            case SLIDER:
                throw 'changeValue cant be used on sliders';
            case NUMBER:
                number.text = newValue;
        }

        if(onChange != null) //I WISH THIS COULD CHECK FOR ITSELF
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
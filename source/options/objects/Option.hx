package options.objects;

import flixel.group.FlxSpriteGroup;

class Option extends FlxSpriteGroup
{
    public var varName:String;
    public var category:String;
    public var type:Dynamic;

    public var minimumValue:Dynamic;
    public var maxValue:Dynamic;

    public var onPress:Dynamic->Void;

    public function new(x:Float, y:Float, name:String, varName:String, category:String, type:Dynamic)
    {
        this.varName = varName;
        this.category = category;
        this.type = type;

        super(x, y);

        var option:Alphabet = new Alphabet(x, y, name, true, false);
        add(option);

        //if(type == CHECKBOX)
    }

    public function press(value:Dynamic)
    {
        ChillSettings.set(varName, category, value);

        if(onPress != null) //I WISH THIS COULD CHECK FOR ITSELF
            onPress(value);
    }
}

enum abstract OptionType(Int)
{
	var CHECKBOX = 0;
    var SLIDER = 1;
    var SELECTION = 1;
}
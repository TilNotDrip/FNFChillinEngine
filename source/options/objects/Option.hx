package options.objects;

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

        var optionTxt:Alphabet = new Alphabet(0, 0, name, Bold);
        add(optionTxt);

        switch(type)
        {
            case CHECKBOX:
                checkbox = new Checkbox(optionTxt.x + optionTxt.width + 50, 0);
                checkbox.check(ChillSettings.get(varName, category));
                add(checkbox);

            case SLIDER:

            case SELECTION:
                selection = new Alphabet(optionTxt.x + optionTxt.width + 50, 0, '< $value >', Default);
                add(selection);

            case NUMBER:
                number = new Alphabet(optionTxt.x + optionTxt.width + 50, 0, '< $value >', Default);
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

class Checkbox extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        frames = Paths.getSparrowAtlas('menuUI/checkbox');
        animation.addByIndices('idle', 'Unselect', [13,13], '', 24, true);
        animation.addByIndices('idle selected', 'Press', [13,13], '', 24, true);
        animation.addByPrefix('checked', 'Press', 24, false);
        animation.addByPrefix('unchecked', 'Unselect', 24, false);

        setGraphicSize(Std.int(width * 0.2));
        updateHitbox();
    }

    public function check(value:Bool)
    {
        if(value)
        {
            animation.play('checked', true);
            animation.finishCallback = function(anim:String) {
                animation.play('idle selected', true);
                animation.finishCallback = null;
            }
        }
        else
        {
            animation.play('unchecked', true);

            animation.finishCallback = function(anim:String) {
                animation.play('idle', true);
                animation.finishCallback = null;
            }
        }
    }
}

// I dont wanna add this to todo but I wanna add this
class Category extends FlxSprite
{
    
}
package options.objects;

import flixel.group.FlxSpriteGroup;

class Option extends FlxSpriteGroup
{
    public var varName:String;
    public var category:String;
    public var type:OptionType;
    public var value:Dynamic;

    public var minimumValue:Dynamic;
    public var maxValue:Dynamic;

    public var onPress:Dynamic->Void;

    private var checkbox:FlxSprite = null;

    public function new(x:Float, y:Float, name:String, varName:String, category:String, type:OptionType)
    {
        this.varName = varName;
        this.category = category;
        this.type = type;
        value = ChillSettings.get(varName, category);

        super(x, y);

        var option:Alphabet = new Alphabet(x, y, name, true, false);
        add(option);

        switch(type)
        {
            case CHECKBOX:
                checkbox = new FlxSprite(option.x + option.width + 50);
                checkbox.frames = Paths.getSparrowAtlas('menuUI/checkbox');
                checkbox.animation.addByIndices('idle', 'Unselect', [13,13], '', 24, true);
                checkbox.animation.addByIndices('idle selected', 'Press', [13,13], '', 24, true);
                checkbox.animation.addByPrefix('checked', 'Press', 24, false);
                checkbox.animation.addByPrefix('unchecked', 'Unselect', 24, false);
                if(ChillSettings.get(varName, category))  
                    checkbox.animation.play('idle selected', true);
                else
                    checkbox.animation.play('idle', true);

                add(checkbox);

                checkbox.setGraphicSize(Std.int(checkbox.width * 0.2));
                checkbox.updateHitbox();

            case SLIDER:
                trace('slider!');

            case SELECTION:
                trace('selection!');
        }
        
    }

    public function press(value:Dynamic)
    {
        ChillSettings.set(varName, category, value);

        switch(type)
        {
            case CHECKBOX:
                if(value == true)
                {
                    checkbox.animation.play('checked', true);
                    checkbox.animation.finishCallback = function(anim:String) {
                        checkbox.animation.play('idle selected', true);
                        checkbox.animation.finishCallback = null;
                    }
                }
                else if(value == false)
                {
                    checkbox.animation.play('unchecked', true);

                    checkbox.animation.finishCallback = function(anim:String) {
                        checkbox.animation.play('idle', true);
                        checkbox.animation.finishCallback = null;
                    }
                }

            case SLIDER:
                trace('slider!');

            case SELECTION:
                trace('selection!');
        }

        this.value = value;

        if(onPress != null) //I WISH THIS COULD CHECK FOR ITSELF
            onPress(value);
    }
}

enum abstract OptionType(Int)
{
	var CHECKBOX = 0;
    var SLIDER = 1;
    var SELECTION = 2;
}
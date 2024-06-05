package addons;

class Modifiers
{
    public static var modifiers(get, never):Array<ModifierData>;
    public static var scoreModifier(get, never):Float;

    public static var activeModifiers:Array<ModifierData> = [];

    private static function get_modifiers():Array<ModifierData>
    {
        var modifierss:Array<ModifierData> = [];

        modifierss.push({
            name: 'Instakill on Miss',
            nameID: 'instakill',
            mod: 2
        });

        modifierss.push({
            name: 'Health Drain',
            nameID: 'drain',
            mod: 1.2
        });

        return modifierss;
    }

    private static function get_scoreModifier():Float
    {
        var scoreMod:Float = 1;

        for(modifier in activeModifiers)
            scoreMod *= modifier.mod;

        return scoreMod;
    }

    public static function hasModifierOn(id:String)
    {
        for(modifier in activeModifiers)
        {
            if(modifier.nameID == id)
                return true;
        }

        return false;
    }
}

typedef ModifierData = 
{
    var name:String;
    var nameID:String;
    var mod:Float;
}
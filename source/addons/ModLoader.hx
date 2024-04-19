package addons;

class ModLoader
{
    function new() {} // fuck you flixel

    public static function modFile(path:String):Array<String>
    {
        return ['mods/$path'];
    }
}
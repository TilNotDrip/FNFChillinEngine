package addons;

import sys.FileSystem;

class ModLoader
{
    function new() {}

    public static var disabledList:Array<String> = [
        'SundayNightChillin' // hahahahahaha json
    ];

    public static var ignorePath:Array<String> = [
        'data',
        'images',
        'fonts',
        'music',
        'sounds',
        'videos'
    ];

    public static function modFile(path:String):Array<String>
    {
        var theMods:Array<String> = [];
        for(daMod in FileSystem.readDirectory('mods/'))
        {
            if(!ignorePath.contains(daMod) && disabledList.contains(daMod)) theMods.push('mods/$daMod/$path');
        }
        theMods.push('mods/$path');
        return ['mods/$path'];
    }
}
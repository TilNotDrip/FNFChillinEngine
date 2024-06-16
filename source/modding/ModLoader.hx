package modding;

#if sys
import sys.FileSystem;
#end

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
        /*#if sys
        for(daMod in FileSystem.readDirectory('mods/'))
            if(!ignorePath.contains(daMod) && !disabledList.contains(daMod)) theMods.push('mods/$daMod/$path');
        #end*/
        theMods.push('mods/$path');
        return theMods;
    }
}
package addons;

import addons.Song;

import flixel.util.FlxSave;

class Week
{
    public static var weeks(get, never):Array<Week>;

    @:noCompletion
    private static function get_weeks():Array<Week>
    {
        var daWeekThing:Array<Week> = [];

        // Tutorial
        daWeekThing[0] = new Week('tutorial', ['Tutorial'], ['Easy', 'Normal', 'Hard']);
        daWeekThing[0].characters = [null, 'bf', 'gf'];
        daWeekThing[0].motto = 'Teaching Time';
        daWeekThing[0].color = 0xff9271fd;

        // Week 1
<<<<<<< Updated upstream
        daWeekThing[1] = new Week('week1', [['Bopeebo', false], ['Fresh', false], ['Dad Battle', false]], ['Easy', 'Normal', 'Hard', 'Erect', 'Nightmare']);
=======
        daWeekThing[1] = new Week('week1', ['Bopeebo', 'Fresh', 'Dad Battle'], ['Easy', 'Normal', 'Hard']);
>>>>>>> Stashed changes
        daWeekThing[1].characters = ['dad', 'bf', 'gf'];
        daWeekThing[1].motto = 'Daddy Dearest';
        daWeekThing[1].color = 0xff9271fd;

        // Week 2
        daWeekThing[2] = new Week('week2', ['Spookeez', 'South', 'Monster'], ['Easy', 'Normal', 'Hard']);
        daWeekThing[2].characters = ['spooky', 'bf', 'gf'];
        daWeekThing[2].motto = 'Spooky Month';
        daWeekThing[2].color = 0xff223344;

        // Week 3
<<<<<<< Updated upstream
        daWeekThing[3] = new Week('week3', [['Pico', false], ['Philly Nice', false], ['Blammed', false]], ['Easy', 'Normal', 'Hard', 'Erect', 'Nightmare']);
=======
        daWeekThing[3] = new Week('week3', ['Pico', 'Philly Nice', 'Blammed'], ['Easy', 'Normal', 'Hard']);
>>>>>>> Stashed changes
        daWeekThing[3].characters = ['pico', 'bf', 'gf'];
        daWeekThing[3].motto = 'PICO';
        daWeekThing[3].color = 0xFF941653;

        // Week 4
        daWeekThing[4] = new Week('week4', ['Satin Panties', 'High', 'MILF'], ['Easy', 'Normal', 'Hard']);
        daWeekThing[4].characters = ['mom', 'bf', 'gf'];
        daWeekThing[4].motto = 'MOMMY MUST MURDER';
        daWeekThing[4].color = 0xFFfc96d7;

        // Week 5
        daWeekThing[5] = new Week('week5', ['Cocoa', 'Eggnog', 'Winter Horrorland'], ['Easy', 'Normal', 'Hard']);
        daWeekThing[5].characters = ['parents-christmas', 'bf', 'gf'];
        daWeekThing[5].motto = 'RED SNOW';
        daWeekThing[5].color = 0xFFa0d1ff;

        // Week 6
<<<<<<< Updated upstream
        daWeekThing[6] = new Week('week6', [['Senpai', false], ['Roses', false], ['Thorns', false]], ['Easy', 'Normal', 'Hard', 'Erect', 'Nightmare']);
=======
        daWeekThing[6] = new Week('week6', ['Senpai', 'Roses', 'Thorns'], ['Easy', 'Normal', 'Hard']);
>>>>>>> Stashed changes
        daWeekThing[6].characters = ['senpai', 'bf', 'gf'];
        daWeekThing[6].motto = 'hating simulator ft. moawling';
        daWeekThing[6].color = 0xffff78bf;

        // Week 7
        daWeekThing[7] = new Week('week7', ['Ugh', 'Guns', 'Stress'], ['Easy', 'Normal', 'Hard']);
        daWeekThing[7].characters = ['tankman', 'bf', 'gf'];
        daWeekThing[7].motto = 'Tankman ft. Johnny Utah';
        daWeekThing[7].color = 0xfff6b604;

        // Weekend 1
        daWeekThing[8] = new Week('weekend1', ['Darnell', 'Lit Up', '2Hot', 'Blazin\''], ['Easy', 'Normal', 'Hard']);
        daWeekThing[8].characters = ['dad', 'pico', 'gf'];
        daWeekThing[8].motto = 'DUE DEBTS';
        daWeekThing[8].color = 0xFF413CAE;

        // Test
        if (ChillSettings.get('devMode', OTHER))
        {
            var idk:Week = new Week('test', ['Test'], ['Normal']);
            idk.explicitSongs = ['Test'];
            idk.characters = ['bf', 'bf', 'gf'];
            idk.motto = '[PLACEHOLDER]';
            idk.color = 0xffffffff;
            daWeekThing.push(idk);
        }

        return daWeekThing;
    }

    /**
     * @param name Name of the week.
     */
    public var name:String = '';

    /**
     * @param characters Characters to show up on Story Menu (Leave `null` for it not to show up.)
     */
    public var characters:Array<String>;

    /**
     * @param color The background color for story mode. `A = Alpha | R = Red | G = Green | B = Blue` Goes by 0xAARRGGBB
     */
    public var color:FlxColor = 0xFFF9CF51;

    /**
     * @param motto The text that shows up on the top right in Story Menu.
     */
    public var motto:String;

    /**
     * @param songs Songs inside the week and if its Explicit or not (e.g. ['The Cuss Song', 'No Swearing'])
     */
    public var songs:Array<String> = [];

    /**
     * @param explicitSongs Songs that are Explicit (e.g. ['The Cuss Song'])
     */
     public var explicitSongs:Array<String> = [];

    /**
     * @param difficuilties Difficulties avaliable for the week.
     */
    public var difficulties:Array<String> = [];

    /**
     * @param icons Icons to be used in Freeplay. You do not need to set these as the new function does it anyways.
     */
    public var icons:Array<String> = [];

    /**
     * Determines whether you have to beat the week before to be able to play this one. (HAS NO EFFECT YET!)
     */
    public var locked/*(get, set)*/:Bool; // i love being on crack -til
    /*private var lockedSave:FlxSave = new FlxSave();

    private function get_locked():Bool
    {
        lockedSave.bind('locks', CoolTools.getSavePath());
        return lockedSave.data.lockedWeeks.get(name);
    }

    private function set_locked(value:Bool)
    {
        lockedSave.bind('locks', CoolTools.getSavePath());
        lockedSave.data.lockedWeeks.set(name, value);
        lockedSave.flush();
        return lockedSave.data.lockedWeeks.get(name);
    }*/

    /**
     * Makes a new week for the game!
     * Example Week:
     * ```haxe
     * var myWeek = new Week('myWeek', ['Swear Song', 'Clean Song'], ['Difficulty 1', 'Difficulty 2']);
     * myWeek.explicitSongs = ['Swear Song'];
     * myWeek.characters = ['opponent', 'player', 'gf'];
     * myWeek.color = 0xAARRGGBB;
     * myWeek.motto = 'My Motto Here';
     * daWeekThing.push(myWeek);
     * ```
     * 
     * @param name Name of the week.
     * @param songs Songs inside the week and if its Explicit or not (e.g. [['The Cuss Song', true], ['No Swearing']
     * @param difficulties Difficulties avaliable for the week.
     */
    public function new(name:String, songs:Array<String>, difficulties:Array<String>)
    {
        this.name = name;
        this.songs = songs;
        this.difficulties = difficulties;

        for(song in songs)
        {
            var songySong:SwagSong = Song.loadFromJson(difficulties[0], song);
            var daIcon:String = songySong.player2;

            if (daIcon != 'bf-pixel' && daIcon != 'bf-old' && daIcon != 'bf-old-pixel')
                daIcon = daIcon.split('-')[0].trim();

            icons.push(daIcon);
        }
    }
}
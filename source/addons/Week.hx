package addons;

import addons.Song;

class Week
{
    public static var weeks(get, never):Array<Week>;

    @:noCompletion
    static function get_weeks():Array<Week>
    {
        var daWeekThing:Array<Week> = [];

        // Tutorial
        daWeekThing[0] = new Week('tutorial', ['Tutorial'], ['Easy', 'Normal', 'Hard']);
        daWeekThing[0].characters = [null, 'bf', 'gf'];
        daWeekThing[0].motto = 'LEFT, RIGHT!';
        daWeekThing[0].color = 0xff9271fd;

        // Week 1
        daWeekThing[1] = new Week('week1', ['Bopeebo', 'Fresh', 'Dad Battle'], ['Easy', 'Normal', 'Hard']);
        daWeekThing[1].characters = ['dad', 'bf', 'gf'];
        daWeekThing[1].motto = 'Daddy Dearest';
        daWeekThing[1].color = 0xff9271fd;

        // Week 2
        daWeekThing[2] = new Week('week2', ['Spookeez', 'South', 'Monster'], ['Easy', 'Normal', 'Hard']);
        daWeekThing[2].characters = ['spooky', 'bf', 'gf'];
        daWeekThing[2].motto = 'Spooky Month';
        daWeekThing[2].color = 0xff223344;

        // Week 3
        daWeekThing[3] = new Week('week3', ['Pico', 'Philly', 'Blammed'], ['Easy', 'Normal', 'Hard']);
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
        daWeekThing[6] = new Week('week6', ['Senpai', 'Roses', 'Thorns'], ['Easy', 'Normal', 'Hard']);
        daWeekThing[6].characters = ['senpai', 'bf', 'gf'];
        daWeekThing[6].motto = 'hating simulator ft. moawling';
        daWeekThing[6].color = 0xffff78bf;

        // Week 7
        daWeekThing[7] = new Week('week7', ['Ugh', 'Guns', 'Stress'], ['Easy', 'Normal', 'Hard']);
        daWeekThing[7].characters = ['tankman', 'bf', 'gf'];
        daWeekThing[7].motto = 'TANKMAN';
        daWeekThing[7].color = 0xfff6b604;

        // Test
        #if debug
        var idk:Week = new Week('test', ['Test'], ['Normal']);
        idk.characters = ['bf', 'bf', 'gf'];
        idk.color = 0x00ffffff;
        idk.motto = '[PLACEHOLDER]';
        daWeekThing.push(idk);
        #end

        return daWeekThing;
    }

    public var name:String = '';
    public var characters:Array<String>;
    public var color:FlxColor;
    public var motto:String;
    public var songs:Array<String> = [];
    public var difficulties:Array<String> = [];
    public var icons:Array<String> = [];
    public var locked:Bool = false;

    function set_locked(value:Bool)
    {
        FlxG.save.data.lockedWeeks.set(name, value);
        return FlxG.save.data.lockedWeeks.get(name);
    }

    function get_locked(value:Bool) return FlxG.save.data.lockedWeeks.get(name);

    public function new(name:String, songs:Array<String>, difficulties:Array<String>)
    {
        this.name = name;
        this.songs = songs;
        this.difficulties = difficulties;

        for(song in songs) {
            
            var songySong:SwagSong = Song.loadFromJson(difficulties[0].formatToPath(), song.formatToPath());
            var daIcon:String = songySong.player2;

            if (daIcon != 'bf-pixel' && daIcon != 'bf-old' && daIcon != 'bf-old-pixel')
                daIcon = daIcon.split('-')[0].trim();

            icons.push(daIcon);
        }
    }
}
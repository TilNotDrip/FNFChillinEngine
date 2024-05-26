package states.tools;

import addons.Song.SwagSong;
import haxe.Json;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;
import lime.utils.Assets;

class ConvertingSongs extends MusicBeatState
{
    var curSelected:Int = -1;
    private var _file:FileReference;

    var songs:Array<Array<String>> = [['Bopeebo', 'Erect'], ['Fresh', 'Erect'], ['Dad Battle', 'Erect']];

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if(controls.ACCEPT)
        {
            curSelected++;
            convert();
        }
    }

    private function onSaveComplete(_):Void
    {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
        FlxG.log.notice("Successfully saved LEVEL DATA.");
    }
    
    private function onSaveCancel(_):Void
    {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
    }
    
    private function onSaveError(_):Void
    {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
        FlxG.log.error("Problem saving Level data");
    }

    function convert()
    {
        var song:Array<String> = songs[curSelected];

        var _song:SwagSong = Song.autoSelectJson(song[0].formatToPath(), song[1].formatToPath());

        var json = {
            "song": _song
        };
        
        var data:String = Json.stringify(json, '\t');

        FlxG.log.error(song[0].formatToPath());
            
        _file = new FileReference();
		_file.addEventListener(Event.COMPLETE, onSaveComplete);
		_file.addEventListener(Event.CANCEL, onSaveCancel);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file.save(data.trim(), song[0].formatToPath() + '-' + song[1].formatToPath() + ".json");
    }
}
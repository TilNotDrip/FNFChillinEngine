typedef SwagEvent =
{
    var name:String;
    var params:Array<String>;
<<<<<<< Updated upstream:source/addons/SongEvent.hx
    var type:SongEventType;
    var time:String;
}

class SongEvent extends MyAsshole
=======
    var strumTime:String;
}

class Event
>>>>>>> Stashed changes:source/addons/Event.hx
{
    public function new(name:String, params:Array<String>)
    {
        updateEventData(name, params);
    }

    public var needsParams:Bool = true;
    public var eventTypes:Array<EventType>;
    public function updateEventData(name:String, parameters:Array<String>)
    {

    }
}

enum abstract EventType(String)
{
	var X    = 'list';
	var Y    = 0x10;
	var XY   = 0x11;
	var NONE = 0x00;
}
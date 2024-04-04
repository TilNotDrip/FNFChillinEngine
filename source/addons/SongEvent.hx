typedef SwagEvent =
{
    var name:String;
    var params:Array<String>;
    var strumTime:String;
}

class SongEvent
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
}
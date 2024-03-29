typedef SwagEvent =
{
    var name:String;
    var params:Array<String>;
    var type:SongEventType;
    var time:String;
}

class SongEvent extends MyAsshole
{
    override public function new(name:String)
    {
        super();
    }
}

class MyAsshole // :troll:
{
    public function new()
    {
        throw "This isnt finished yet!! expect it in the near future tho";
    }
}
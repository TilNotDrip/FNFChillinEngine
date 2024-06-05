package addons;

import flixel.util.FlxSignal.FlxTypedSignal;
import haxe.net.WebSocket;
import haxe.net.WebSocketServer;

class FunkinServer 
{
    private static var server:WebSocketServer;
    private static var socket:WebSocket;

    public static var isHost(get, never):Bool;

    public static var data(default, set):ClientParams;
    public static var opponentData:ClientParams;

    public static var onEvent:FlxTypedSignal<ClientEvent->Void> = new FlxTypedSignal<ClientEvent->Void>();

    public static function hostServer(ip:String, port:Int, ?code:String = '') 
    {
        server = WebSocketServer.create(ip, port, 1, true);
        trace('Server ready!');

        FlxG.signals.preUpdate.add(update);
    }
    
    public static function joinServer(ip:String, port:Int) 
    {
        socket = WebSocket.create("ws://" + ip + ":" + port + "/", ['echo-protocol'], false);
        trace('Server connected!');

        var isOpened:Bool = false;

        socket.onopen = function() {
            isOpened = true;
        }

        while(!isOpened)
        {
            // stupid way to hold the code from running
            // but... it could 
            Sys.sleep(0.1);
        }

        data = {
            name: '',
            events: []
        };

        socket.onmessageString = onMessage;
    }

    private static function get_isHost():Bool
    {
        return (server != null);
    }

    static var listeningSockets:Array<WebSocket> = [];
    static var messagesToSendQueue:Array<String> = [];
    private static function update()
    {
        if(isHost)
        {
            try {
                var daSocket:WebSocket = server.accept();
    
                if(daSocket != null)
                {
                    listeningSockets.push(daSocket);
                    daSocket.onmessageString = onMessage;
                }
            
                for(socketyy in listeningSockets)
                {
                    if(messagesToSendQueue[0] != null)
                        socketyy.sendString(messagesToSendQueue[0]);

                    socketyy.process();
    
                    /*if(socketyy.readyState == Closed)
                        listeningSockets.remove(socketyy);*/
                }

                if(messagesToSendQueue[0] != null)
                    messagesToSendQueue.remove(messagesToSendQueue[0]);
            } catch(e) {
                trace('Error while updating server sockets: ' + e);
            }
        }
        else
            socket.process();
    }

    static var oldEvents:Array<ClientEvent>;
    private static function onMessage(message:String)
    {
        opponentData = cast haxe.Json.parse(message);

        if(opponentData.events != oldEvents)
        {
            opponentData.events.sort((a, b) -> Std.int(a.time - b.time));
            for(event in opponentData.events)
            {
                if(!oldEvents.contains(event))
                    onEvent.dispatch(event);
            }
        }

        oldEvents = opponentData.events;
    }

    public static function addEvent(event:String, paramse:Array<String>)
    {
        if(data.events == null)
            data.events = [];

        data.events.push({event: event, params: paramse, time: Date.now().getTime()});
    }

    private static function set_data(value:ClientParams):ClientParams 
    {
        if(!isHost)
            socket.sendString(haxe.Json.stringify(value));
        else
            messagesToSendQueue.push(haxe.Json.stringify(value));

        return value;
    }
}

typedef ClientParams = 
{
    var name:String;
    var events:Array<ClientEvent>;
}

typedef ClientEvent =
{
    var event:String;
    var params:Array<String>;
    var time:Float;
}


package states.menus;

import flixel.graphics.FlxGraphic;

import haxe.Json;

import openfl.display.BitmapData;

class CreditsState extends MusicBeatState
{
    static var curSelected:Int = 0;
    static var reloaded:Int = 0;

    var description:Alphabet;

    public var contribList:Array<{ // my god
        var login:String;
        @:optional var id:Int;
        @:optional var node_id:String;
        var avatar_url:String;
        @:optional var gravatar_url:String;
        @:optional var url:String;
        var html_url:String;
        @:optional var followers_url:String;
        @:optional var following_url:String;
        @:optional var gists_url:String;
        @:optional var starred_url:String;
        @:optional var subscriptions_url:String;
        @:optional var organizations_url:String;
        @:optional var repos_url:String;
        @:optional var events_url:String;
        @:optional var received_events_url:String;
        @:optional var type:String;
        @:optional var site_admin:Bool;
        @:optional var contributions:Int;
    }>;

    private var peopleArray:Array<Alphabet> = [];
    private var iconArray:Array<FlxSprite> = [];

    private var peopleLikeJson:Array<String> = [
        'dot-json1969'
    ];
    override public function create()
    {
        changeWindowName('Credits Menu');

        #if DISCORD
		DiscordRPC.details = 'Credits Menu';
		#end

        var contribGet = new haxe.Http('https://api.github.com/repos/TechnikTil/FNFChillinEngine/contributors');
        contribGet.setHeader("User-Agent", "request");

        contribGet.onData = function(data:String) {
            contribList = cast Json.parse(data);
        }

        contribGet.onError = function(error:String) 
        {
			FlxG.log.error('Error loading people. Reason: ' + error);
            reloaded++;
            if(reloaded >= 5)
                FlxG.switchState(new MainMenuState());
            else
                FlxG.resetState();
		}

        contribGet.request();

        contribList.push({
            login: '.json',
            avatar_url: 'https://cdn.discordapp.com/avatars/1115022846041804820/1da21a6cbe7b90145577af30f7dd4f03?size=1024', 
            html_url: 'https://twitter.com/gameboy1969'
        });

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuUI/menuBG'));
        bg.screenCenter();
        add(bg);

        for(user in contribList)
            if(peopleLikeJson.contains(user.login))
                contribList.remove(user);

        for(i in 0...contribList.length)
        {
            var user = contribList[i];

            var songText:Alphabet = new Alphabet(0, (70 * i) + 30, user.login, Bold);
            songText.isMenuItem = true;
            songText.targetY = i;

            var icon:FlxSprite = new FlxSprite().loadGraphic(fromWeb(user.avatar_url));
            icon.setGraphicSize(130, 130);
            icon.updateHitbox();
            icon.scrollFactor.set();

            peopleArray.push(songText);
            iconArray.push(icon);

            add(songText);
            add(icon);
        }

        description = new Alphabet(0, 0, '', Default);
        description.updateHitbox();
        description.y = FlxG.height - description.height - 100;
        description.screenCenter(X);
        description.offset.x = -(description.width / 2);
        description.scrollFactor.set();
        add(description);

        changeSelection();

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        
        for(i in 0...peopleArray.length)
        {
            iconArray[i].x = peopleArray[i].x + peopleArray[i].width + 10;
            iconArray[i].y = peopleArray[i].y - 30;
        }

        if (controls.UI_UP_P)
			changeSelection(-1);
		if (controls.UI_DOWN_P)
			changeSelection(1);

        if (controls.ACCEPT)
            CoolUtil.openURL(contribList[curSelected].html_url);

        if (controls.BACK)
            FlxG.switchState(new MainMenuState());
    }

    private function changeSelection(change:Int = 0)
	{
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = contribList.length - 1;

		if (curSelected >= contribList.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in iconArray)
			item.alpha = 0.6;

		iconArray[curSelected].alpha = 1;

		for (item in peopleArray)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}

        description.text = "Contributions: " + contribList[curSelected].contributions;
        description.updateHitbox();
        description.y = FlxG.height - description.height - 100;
        description.screenCenter(X);
	}

    public static function fromWeb(url:String):FlxGraphic
    {
        var daGraphic:FlxGraphic = null;

        var request = new haxe.Http(url);
		request.setHeader("User-Agent", "request");

        request.onBytes = function(bytes) 
        {
            daGraphic = FlxGraphic.fromBitmapData(BitmapData.fromBytes(bytes));
		}

		request.onError = function(error:String) 
        {
			FlxG.log.error('Error loading graphic for ' + url + '. Reason: ' + error);
		}

        request.request();

        return daGraphic;
    }
}
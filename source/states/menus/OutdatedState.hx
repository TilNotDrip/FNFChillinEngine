package states.menus;

class OutdatedState extends MusicBeatState
{
	static var curSelected:Int = 0;
	var options:FlxText;

	var daOptions:Array<String> = [
		#if windows 'Update Automatically', #end
		'Update Manually',
		'Exit'
	];

	override public function create()
	{
		changeWindowName('Outdated!');

		#if DISCORD
		DiscordRPC.details = 'Outdated Screen';
		#end

		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Hey there! You are currently playing an outdated version of Chillin' Engine
			You are on v" + Application.current.meta.get('version') + " while the newest is vvardontexist
			\n
			Select option:
			\n",
		32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.updateHitbox();
		txt.screenCenter(X);
		add(txt);

		options = new FlxText(0, 0, FlxG.width, '', 32);
		options.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		options.updateHitbox();
		options.screenCenter(X);
		add(options);

		txt.y = (FlxG.height / 2) - txt.height;

	}

	override public function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			switch(daOptions[curSelected])
			{
				case 'Update Automatically':
					var pathToGame:String = Sys.programPath().replace('ChillinEngine.exe', '').replace('\\', '/');
					var gameEdition:String = 'Windows';
					var newVersion:String = 'vardontexist';

					/*#if 32bit
					gameEdition += '-32';
					#end*/ //HOWWW

					var fullCommand:String = 'color a && ' +
					'title Downloading Chillin Engine Update... [DO NOT CLOSE] && ' +
					'curl -L https://github.com/TechnikTil/FNFChillinEngine/releases/download/${newVersion}/${gameEdition}.zip -O ${pathToGame}/release.zip && ' +
					'powershell -command ""Expand-Archive -Force \'${pathToGame}/release.zip\' \'${pathToGame}/release\'"" && ' +
					'title Installing Chillin Engine Update... [DO NOT CLOSE] && ' +
					'move /Y \'${pathToGame}/release/*\' \'${pathToGame}\' && ' +
					'title Deleting Chillin Engine Update remains... [DO NOT CLOSE] && ' +
					'del ${pathToGame}/release && ' +
					'title Restarting Chillin Engine... [DO NOT CLOSE] && ' +
					'start ${pathToGame}/ChillinEngine.exe && ' +
					'title Have a great day! -Til && ' +
					'exit';


					new sys.io.Process('start', ['cmd', '/k "$fullCommand"'], true);
					Sys.exit(0);

				case 'Update Manually':
					CoolUtil.openURL('https://github.com/TechnikTil/FNFChillinEngine/releases');
					FlxG.switchState(new TitleState());

				case 'Exit':
					FlxG.switchState(new TitleState());


			}
		}

		if(controls.UI_UP)
			changeSelection(-1);

		if(controls.UI_DOWN)
			changeSelection(1);

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());

		super.update(elapsed);
	}

	private function changeSelection(change:Int = 0)
	{
        curSelected += change;

		var limit:Int = 1;

		#if windows 
		limit = 2;
		#end

		if (curSelected < 0)
			curSelected = limit;

		if (curSelected > limit)
			curSelected = 0;

		var daText:String = '';

		for(i in 0...daOptions.length)
		{
			if(i == curSelected) 
				daText += '<';

			daText += daOptions[i];

			if(i == curSelected) 
				daText += '>';
		}

		options.updateHitbox();
		options.screenCenter(X);
		options.y = (FlxG.height / 2);
	}
}

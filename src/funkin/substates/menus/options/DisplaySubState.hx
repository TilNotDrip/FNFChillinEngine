package funkin.substates.menus.options;

class DisplaySubState extends BaseOptionsSubState
{
	override public function create():Void
	{
		#if FUNKIN_DISCORD_RPC
		DiscordRPC.state = 'Display';
		#end

		var fps:Option = new Option('FPS', 'How much frames the game runs per second.', 'fps', NUMBER);
		fps.numType = Int;
		fps.minimumValue = 30;
		#if !html5 fps.maximumValue = 360; #else fps.maximumValue = 60; #end
		fps.onChange = changeFPS;
		addOption(fps);

		var fpsCounter:Option = new Option('FPS Counter', 'Shows the FPS Counter in the Top Left Corner.', 'fpsCounter', CHECKBOX);
		fpsCounter.onChange = displayFPS;
		addOption(fpsCounter);

		var fullscreen:Option = new Option('Fullscreen', 'Puts the game in fullscreen.', 'fullscreen', CHECKBOX);
		fullscreen.onChange = changeFullscreen;
		addOption(fullscreen);

		var antialiasing:Option = new Option('Antialiasing', 'Whether objects have antialiasing or not.', 'antialiasing', CHECKBOX);
		antialiasing.onChange = changeAntialiasing;
		addOption(antialiasing);

		var flashingLights:Option = new Option('Flashing Lights', 'Whether flashing lights are shown or not.', 'flashingLights', CHECKBOX);
		addOption(flashingLights);

		super.create();
	}

	function changeFPS():Void
	{
		FlxG.updateFramerate = FunkinOptions.get('fps');
		FlxG.drawFramerate = FunkinOptions.get('fps');
	}

	function displayFPS():Void
	{
		if (Main.fpsCounter != null)
			Main.fpsCounter.visible = FunkinOptions.get('fpsCounter');
	}

	function changeFullscreen():Void
		FlxG.fullscreen = FunkinOptions.get('fullscreen');

	function changeAntialiasing():Void
		FlxSprite.defaultAntialiasing = FunkinOptions.get('antialiasing');
}

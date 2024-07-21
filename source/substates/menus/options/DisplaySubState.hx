package substates.menus.options;

class DisplaySubState extends BaseSubState
{
	override public function create()
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

	private function changeFPS()
	{
		FlxG.updateFramerate = ChillSettings.get('fps');
		FlxG.drawFramerate = ChillSettings.get('fps');
	}

	private function displayFPS()
	{
		if (Main.fpsCounter != null)
			Main.fpsCounter.visible = ChillSettings.get('fpsCounter');
	}

	private function changeFullscreen()
		FlxG.fullscreen = ChillSettings.get('fullscreen');

	private function changeAntialiasing()
		FlxSprite.defaultAntialiasing = ChillSettings.get('antialiasing');
}

package utils;

import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
	private var controls(get, never):Controls;

	inline private function get_controls():Controls
		return PlayerSettings.players[0].controls;

	public function new():Void
	{
		#if FUNKIN_DISCORD_RPC
		DiscordRPC.clearValues();
		DiscordRPC.largeImageKey = 'logo';
		DiscordRPC.largeImageText = 'Friday Night Funkin\'; Chillin Engine: V' + Application.current.meta.get('version');
		#end

		FlxG.fixedTimestep = false;

		super();
	}

	override public function create():Void
	{
		Conductor.stepSignal.add(stepHit);
		Conductor.beatSignal.add(beatHit);
		Conductor.sectionSignal.add(sectionHit);

		super.create();
	}

	public function stepHit():Void {}

	public function beatHit():Void {}

	public function sectionHit():Void {}

	override public function destroy():Void
	{
		Conductor.destroy();
		super.destroy();
	}

	public function changeWindowName(windowName:String = ''):Void
		Application.current.window.title = Application.current.meta.get('name') + (windowName == '' ? '' : ' - ') + windowName;

	public function quickMakeBG():FlxSprite
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.content.image('menuUI/menuBG'));
		bg.color = 0xFFFDE871;
		bg.scrollFactor.set();
		bg.screenCenter();
		add(bg);
		return bg;
	}
}

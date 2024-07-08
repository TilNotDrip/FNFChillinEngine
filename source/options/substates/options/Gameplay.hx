package options.substates.options;

import display.FPS;
import openfl.Lib;
import options.objects.Option;

class Gameplay extends BaseSubState
{
	override public function create()
	{
		#if DISCORD
		DiscordRPC.state = 'Gameplay';
		#end

		var camZoom:Option = new Option('Camera Zooming', '', 'camZoom', GAMEPLAY, CHECKBOX);
		addOption(camZoom);

		var hudType:Option = new Option('Hud Type', '', 'hudType', GAMEPLAY, SELECTION);
		hudType.selections = ['Score Txt Only', 'Score / Rating Counter / Health'];
		addOption(hudType);

		var ghostTapping:Option = new Option('Ghost Tapping', '', 'ghostTapping', GAMEPLAY, CHECKBOX);
		addOption(ghostTapping);

		var downScroll:Option = new Option('Downscroll', '', 'downScroll', GAMEPLAY, CHECKBOX);
		addOption(downScroll);

		var middleScroll:Option = new Option('Middlescroll', '', 'middleScroll', GAMEPLAY, CHECKBOX);
		addOption(middleScroll);

		var noteSplashes:Option = new Option('Note Splashes', '', 'noteSplashes', GAMEPLAY, CHECKBOX);
		addOption(noteSplashes);

		var cutscenes:Option = new Option('Cutscenes', '', 'cutscenes', GAMEPLAY, CHECKBOX);
		addOption(cutscenes);

		super.create();
	}
}

package options.substates.options;

import display.FPS;
import openfl.Lib;
import options.objects.Option;

class Gameplay extends BaseSubState
{
	override public function create()
	{
		#if FUNKIN_DISCORD_RPC
		DiscordRPC.state = 'Gameplay';
		#end

		var camZoom:Option = new Option('Camera Zooming', '', 'camZoom', CHECKBOX);
		addOption(camZoom);

		var hudType:Option = new Option('Hud Type', '', 'hudType', SELECTION);
		hudType.selections = ['Simple', 'Complex'];
		addOption(hudType);

		var ghostTapping:Option = new Option('Ghost Tapping', '', 'ghostTapping', CHECKBOX);
		addOption(ghostTapping);

		var downScroll:Option = new Option('Downscroll', '', 'downScroll', CHECKBOX);
		addOption(downScroll);

		var middleScroll:Option = new Option('Middlescroll', '', 'middleScroll', CHECKBOX);
		addOption(middleScroll);

		var noteSplashes:Option = new Option('Note Splashes', '', 'noteSplashes', CHECKBOX);
		addOption(noteSplashes);

		var cutscenes:Option = new Option('Cutscenes', '', 'cutscenes', CHECKBOX);
		addOption(cutscenes);

		super.create();
	}
}

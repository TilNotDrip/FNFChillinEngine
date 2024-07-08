package stages;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import objects.game.Character;
import stages.bgs.*;

class StageBackend extends FlxBasic
{
	public static function findStageByName(name:String):StageBackend
	{
		// Will get better functionality soon!!

		var daStage:StageBackend = switch (name)
		{
			case 'spooky': new Spooky();
			case 'philly': new Philly();
			case 'limo': new Limo();
			case 'mall': new Mall();
			case 'mallEvil': new MallEvil();
			case 'school': new School();
			case 'schoolEvil': new SchoolEvil();
			case 'tank': new Tank();
			case 'streets': new Streets();
			default: new FunkinStage();
		}

		daStage.name = name;

		return daStage;
	}

	private var game:PlayState = PlayState.game;

	public var name:String = 'unknown';

	private var members:Array<FlxBasic> = [];

	// Main Stage Variables
	public var zoom:Float = 1.05;
	public var pixel:Bool = false;
	public var startCallback:Void->Void = null;
	public var endCallback:Void->Void = null;

	// PlayState / MusicBeatState Variables
	private var camGAME(get, never):FlxCamera;
	private var camHUD(get, never):FlxCamera;
	private var camDIALOGUE(get, never):FlxCamera;

	private var inCutscene(get, set):Bool;

	private var dialogue(get, never):Array<String>;

	private var curSong:String = PlayState.SONG.metadata.song;

	private var isStoryMode:Bool = PlayState.isStoryMode;

	private var gf(get, never):Character;
	private var opponent(get, never):Character;
	private var player(get, never):Character;

	public var gfGroup(get, never):FlxTypedSpriteGroup<Character>;
	public var opponentGroup(get, never):FlxTypedSpriteGroup<Character>;
	public var playerGroup(get, never):FlxTypedSpriteGroup<Character>;

	private var camFollow(get, never):FlxObject;

	// New Function
	public function new()
	{
		super();

		create();
	}

	// PlayState / MusicBeatState Functions
	public function create() {}

	public function createPost() {}

	private function startCountdown()
		return PlayState.game.startCountdown();

	override public function update(elapsed:Float) {}

	public function cameraMovement(char:Character) {}

	public function stepHit() {}

	public function beatHit() {}

	public function sectionHit() {}

	// Adding / Removing n stuff
	private function add(object:FlxBasic)
	{
		members.push(object);
		PlayState.game.add(object);
	}

	private function remove(object:FlxBasic)
	{
		members.push(object);
		PlayState.game.remove(object);
	}

	private function insert(position:Int, object:FlxBasic)
	{
		members.push(object);
		PlayState.game.insert(position, object);
	}

	private function addBehindGF(object:FlxBasic)
	{
		insert(PlayState.game.members.indexOf(gfGroup), object);
	}

	private function addBehindOpponent(object:FlxBasic)
	{
		insert(PlayState.game.members.indexOf(opponentGroup), object);
	}

	private function addBehindPlayer(object:FlxBasic)
	{
		insert(PlayState.game.members.indexOf(playerGroup), object);
	}

	// Other Functions
	public function endingStuff()
	{
		if (endCallback != null && !PlayState.seenEndCutscene && ChillSettings.get('cutscenes', GAMEPLAY))
		{
			endCallback();
			PlayState.seenEndCutscene = true;
		}
		else
			return PlayState.game.endSong();
	}

	public function endingVideo() {}

	// Functions for getting/setting PlayState / MusicBeatState vars
	inline private function get_camGAME():FlxCamera
		return PlayState.game.camGAME;

	inline private function get_camHUD():FlxCamera
		return PlayState.game.camHUD;

	inline private function get_camDIALOGUE():FlxCamera
		return PlayState.game.camDIALOGUE;

	inline private function get_inCutscene():Bool
		return PlayState.game.inCutscene;

	inline private function set_inCutscene(value:Bool)
	{
		PlayState.game.inCutscene = value;
		return value;
	}

	inline private function get_dialogue():Array<String>
		return PlayState.game.dialogue;

	inline private function get_gf():Character
		return PlayState.game.gf;

	inline private function get_opponent():Character
		return PlayState.game.dad;

	inline private function get_player():Character
		return PlayState.game.boyfriend;

	inline private function get_gfGroup():FlxTypedSpriteGroup<Character>
		return PlayState.game.gfGroup;

	inline private function get_opponentGroup():FlxTypedSpriteGroup<Character>
		return PlayState.game.dadGroup;

	inline private function get_playerGroup():FlxTypedSpriteGroup<Character>
		return PlayState.game.boyfriendGroup;

	inline private function get_camFollow():FlxObject
		return PlayState.game.camFollow;

	override public function set_visible(value:Bool)
	{
		for (spr in members)
			spr.visible = value;

		return super.set_visible(value);
	}
}

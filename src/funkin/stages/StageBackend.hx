package funkin.stages;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxPoint;
import funkin.objects.game.Character;

class StageBackend extends FlxBasic
{
	public static var stage:StageBackend;

	var game:PlayState = PlayState.instance;

	// Main Stage Variables
	public var DAD_POSITION:Array<Float> = [100.0, 100.0];
	public var GF_POSITION:Array<Float> = [400.0, 130.0];
	public var BF_POSITION:Array<Float> = [770.0, 450.0];

	public var zoom:Float = 1.05;
	public var ui:String = 'funkin';
	public var startCallback:Void->Void = null;
	public var endCallback:Void->Void = null;

	// PlayState / MusicBeatState Variables
	var camGAME(get, never):FlxCamera;
	var camHUD(get, never):FlxCamera;
	var camDIALOGUE(get, never):FlxCamera;

	var inCutscene(get, set):Bool;

	var dialogue(get, never):Array<String>;

	var curSong:String = PlayState.SONG.song;

	var isStoryMode:Bool = PlayState.isStoryMode;

	var gf(get, never):Character;
	var opponent(get, never):Character;
	var player(get, never):Character;

	public var gfGroup(get, never):FlxTypedSpriteGroup<Character>;
	public var opponentGroup(get, never):FlxTypedSpriteGroup<Character>;
	public var playerGroup(get, never):FlxTypedSpriteGroup<Character>;

	var camFollow(get, never):FlxObject;

	public var curStep:Int = 0;
	public var curBeat:Int = 0;
	public var curSection:Int = 0;

	// New Function
	public function new()
	{
		super();

		stage = this;
		create();
	}

	// PlayState / MusicBeatState Functions
	public function create() {}

	public function createPost() {}

	function startCountdown()
		return PlayState.instance.startCountdown();

	public function cameraMovement(char:Character) {}

	public function stepHit() {}

	public function beatHit() {}

	public function sectionHit() {}

	// Adding / Removing n stuff
	function add(object:FlxBasic)
		PlayState.instance.add(object);

	function remove(object:FlxBasic)
		PlayState.instance.remove(object);

	function insert(position:Int, object:FlxBasic)
		PlayState.instance.insert(position, object);

	function addBehindGF(object:FlxBasic)
	{
		insert(PlayState.instance.members.indexOf(gfGroup), object);
	}

	function addBehindOpponent(object:FlxBasic)
	{
		insert(PlayState.instance.members.indexOf(opponentGroup), object);
	}

	function addBehindPlayer(object:FlxBasic)
	{
		insert(PlayState.instance.members.indexOf(playerGroup), object);
	}

	// Other Functions
	public function endingStuff()
	{
		if (endCallback != null && !PlayState.seenEndCutscene && FunkinOptions.get('cutscenes'))
		{
			endCallback();
			PlayState.seenEndCutscene = true;
		}
		else
			return PlayState.instance.endSong();
	}

	public function endingVideo() {}

	// Functions for getting/setting PlayState / MusicBeatState vars
	inline function get_camGAME():FlxCamera
		return PlayState.instance.camGAME;

	inline function get_camHUD():FlxCamera
		return PlayState.instance.camHUD;

	inline function get_camDIALOGUE():FlxCamera
		return PlayState.instance.camDIALOGUE;

	inline function get_inCutscene():Bool
		return PlayState.instance.inCutscene;

	inline function set_inCutscene(value:Bool)
	{
		PlayState.instance.inCutscene = value;
		return value;
	}

	inline function get_dialogue():Array<String>
		return PlayState.instance.dialogue;

	inline function get_gf():Character
		return PlayState.instance.gf;

	inline function get_opponent():Character
		return PlayState.instance.dad;

	inline function get_player():Character
		return PlayState.instance.boyfriend;

	inline function get_gfGroup():FlxTypedSpriteGroup<Character>
		return PlayState.instance.gfGroup;

	inline function get_opponentGroup():FlxTypedSpriteGroup<Character>
		return PlayState.instance.dadGroup;

	inline function get_playerGroup():FlxTypedSpriteGroup<Character>
		return PlayState.instance.boyfriendGroup;

	inline function get_camFollow():FlxObject
		return PlayState.instance.camFollow;
}

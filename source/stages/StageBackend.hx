package stages;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxObject;

import flixel.addons.transition.FlxTransitionableState;

import flixel.math.FlxPoint;

import objects.Character;

class StageBackend extends FlxBasic
{
    public static var stage:StageBackend; 
    private var game:PlayState = PlayState.game;

    // Main Stage Variables
    public var zoom:Float = 1.05;
    public var pixel:Bool = false;
    public var hasCutscene = false;
    public var hasEndCutscene = false;

    // PlayState / MusicBeatState Variables
    private var camGAME(get, never):FlxCamera;
    private var camHUD(get, never):FlxCamera;
    private var camDIALOGUE(get, never):FlxCamera;

    private var inCutscene(get, set):Bool;

    private var dialogue(get, never):Array<String>;

    private var curSong:String = PlayState.SONG.song;

    private var isStoryMode:Bool = PlayState.isStoryMode;

    private var gf(get, never):Character;
    private var opponent(get, never):Character;
    private var player(get, never):Character;

    private var camFollow(get, never):FlxObject;
    private var camPos(get, never):FlxPoint;

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

    public function createPost()
        if (hasCutscene && !PlayState.seenCutscene)
            PlayState.seenCutscene = true;

    private function startCountdown() return PlayState.game.startCountdown();

    override public function update(elapsed:Float) {}

    public function cameraMovement(char:Character) {}

    public function endSong() {}

    public function stepHit() {}
    public function beatHit() {}
    public function sectionHit() {}

    // Adding / Removing n stuff
    private function add(object:FlxBasic) PlayState.game.add(object);
    private function remove(object:FlxBasic) PlayState.game.remove(object);
    private function insert(position:Int, object:FlxBasic) PlayState.game.insert(position, object);

    private function addBehindGF(object:FlxBasic) {
        insert(PlayState.game.members.indexOf(gf), object);
    }
    private function addBehindOpponent(object:FlxBasic) {
        insert(PlayState.game.members.indexOf(opponent), object);
    }
    private function addBehindPlayer(object:FlxBasic) {
        insert(PlayState.game.members.indexOf(player), object);
    }

    // Other Functions
    public function endingStuff()
    {
        if (hasEndCutscene && !PlayState.seenCutscene)
            return endSong();
        else
            return PlayState.game.endSong();
    }

    public function endingVideo() {}

    // Functions for getting/setting PlayState / MusicBeatState vars
    inline private function get_camGAME():FlxCamera return PlayState.game.camGAME;
    inline private function get_camHUD():FlxCamera return PlayState.game.camHUD;
    inline private function get_camDIALOGUE():FlxCamera return PlayState.game.camDIALOGUE;

    inline private function get_inCutscene():Bool return PlayState.game.inCutscene;
    inline private function set_inCutscene(value:Bool)
    {
        PlayState.game.inCutscene = value;
        return value;
    }

    inline private function get_dialogue():Array<String> return PlayState.game.dialogue;

    inline private function get_gf():Character return PlayState.game.gf;
    inline private function get_opponent():Character return PlayState.game.dad;
    inline private function get_player():Character return PlayState.game.boyfriend;

    inline private function get_camFollow():FlxObject return PlayState.game.camFollow;
    inline private function get_camPos():FlxPoint return PlayState.game.camPos;
}
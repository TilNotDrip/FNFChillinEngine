package stages;

import flixel.FlxBasic;

import flixel.addons.transition.FlxTransitionableState;

import objects.Character;

class StageBackend extends FlxBasic
{
    public static var stage:StageBackend; 

    // Main Stage Variables
    public var zoom:Float = 1.05;
    public var pixel:Bool = false;
    public var hasCutscene = false;
    public var hasEndCutscene = false;

    public function new()
    {
        super();

        stage = this;
        create();
    }

    // PlayState / MusicBeatState Variables
    public var curStep:Int = 0;
    public var curBeat:Int = 0;

    // PlayState / MusicBeatState Functions
    public function create() {}

    public function createPost()
        if (hasCutscene && !PlayState.seenCutscene)
            PlayState.seenCutscene = true;

    override public function update(elapsed:Float) {}
    public function cameraMovement(char:Character) {}

    public function endSong() {}

    public function stepHit() {}
    public function beatHit() {}

    // Adding / Removing n stuff
    private function add(object:FlxBasic) PlayState.game.add(object);
    private function remove(object:FlxBasic) PlayState.game.remove(object);
    private function insert(position:Int, object:FlxBasic) PlayState.game.insert(position, object);

    private function addBehindGF(object:FlxBasic) {
        insert(PlayState.game.members.indexOf(PlayState.game.gf), object);
    }
    private function addBehindDad(object:FlxBasic) {
        insert(PlayState.game.members.indexOf(PlayState.game.dad), object);
    }
    private function addBehindBF(object:FlxBasic) {
        insert(PlayState.game.members.indexOf(PlayState.game.boyfriend), object);
    }

    // Other Functions
    public function endingStuff()
    {
        if (hasEndCutscene && !PlayState.seenCutscene)
            return endSong();
        else
            return PlayState.game.endSong();
    }
}
package stages;

import flixel.FlxBasic;

import objects.Character;

class StageBackend extends FlxBasic
{
    var zoom:Float = 1;
    var pixel:Bool = false;

    public function new()
    {
        super();
    }

    public function create() {}
    override public function update(elapsed:Float) {}
    public function stepHit(curStep:Int) {}
    public function beatHit(curBeat:Int) {}

    public function cameraMovement(char:Character) {}
}
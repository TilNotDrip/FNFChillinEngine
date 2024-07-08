package addons;

interface IEventReceiver
{
	public function create():Void;
	public function update(elapsed:Float):Void;

	public function cameraMovement(char:Character):Void;

	public function stepHit():Void;
	public function beatHit():Void;
	public function sectionHit():Void;

	public function startCountdown():Dynamic;
	public function endSong():Dynamic;
}

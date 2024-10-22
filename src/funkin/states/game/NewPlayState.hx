package funkin.states.game;

import funkin.objects.game.Stage;

class NewPlayState extends MusicBeatState
{
	public static var instance:NewPlayState;

	public var curSong:NewSong;

	/**
	 * The current stage displayed.
	 */
	public var curStage:Stage;

	/**
	 * The player's current health.
	 */
	public var health(default, set):Float = Constants.HEALTH_STARTING;

	/**
	 * The player's current health for displaying.
	 */
	public var healthLerp(default, set):Float = Constants.HEALTH_STARTING;

	override public function create():Void
	{
		instance = this;

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		updateHealth();

		super.update(elapsed);
	}

	function updateHealth():Void
	{
		if (healthLerp != health)
			healthLerp = FlxMath.lerp(healthLerp, health, 0.15);
	}

	function set_health(value:Float):Float
	{
		if (health > Constants.HEALTH_MAX || health < Constants.HEALTH_MIN)
			return health;

		return health = value;
	}

	function set_healthLerp(value:Float):Float
	{
		healthLerp = value;
		return healthLerp;
	}
}

typedef PlayStateParams =
{
	var minimalMode:Bool;
}

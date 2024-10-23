package funkin.states.game;

import funkin.objects.game.HealthBar;
import funkin.objects.game.Stage;

class NewPlayState extends MusicBeatState
{
	/**
	 * The current instance of this class.
	 * TODO: explain more
	 */
	public static var instance:NewPlayState;

	/**
	 * The current song properties.
	 */
	public var curSong:NewSong;

	/**
	 * The current stage displayed.
	 */
	public var curStage:Stage;

	/**
	 * The healthbar displayed at the top or bottom of your screen.
	 */
	public var healthBar:HealthBar;

	/**
	 * The player's current health.
	 */
	public var health(default, set):Float = Constants.HEALTH_STARTING;

	/**
	 * The player's current health for displaying.
	 */
	public var healthLerp(default, set):Float = Constants.HEALTH_STARTING;

	/**
	 * The camera that displays objects like the stage and characters.
	 */
	public var camGAME:FlxCamera;

	/**
	 * The camera that displays objects like UI elements.
	 */
	public var camHUD:FlxCamera;

	override public function create():Void
	{
		instance = this;

		initCameras();

		super.create();
	}

	function initCameras():Void
	{
		camGAME = new FlxCamera();
		FlxG.cameras.reset(camGAME);

		camHUD = new FlxCamera();
		camHUD.bgColor = 0x0;
		FlxG.cameras.add(camHUD);
	}

	override public function update(elapsed:Float):Void
	{
		updateHealth();
		deathCheck();

		super.update(elapsed);
	}

	function updateHealth():Void
	{
		if (healthLerp != health)
			healthLerp = FlxMath.lerp(healthLerp, health, 0.15);
	}

	function deathCheck():Void
	{
		if (health <= Constants.HEALTH_MIN)
		{
			// GameOverSubState logic here
		}
	}

	function set_health(value:Float):Float
	{
		if (value > Constants.HEALTH_MAX)
			return Constants.HEALTH_MAX;
		else if (value < Constants.HEALTH_MIN)
			return Constants.HEALTH_MIN;

		return health = value;
	}

	function set_healthLerp(value:Float):Float
	{
		healthLerp = value;
		healthBar.health = healthLerp;
		return healthLerp;
	}
}

typedef PlayStateParams =
{
	var minimalMode:Bool;
	var chartingMode:Bool;
}

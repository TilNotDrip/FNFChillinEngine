package funkin.stages.bgs;

import funkin.objects.game.BGSprite;

class FunkinStage extends StageBackend
{
	override public function create()
	{
		zoom = 0.9;

		var bg:BGSprite = new BGSprite('stage/stageback', -600, -200, 0.9, 0.9);
		add(bg);

		var stageFront:BGSprite = new BGSprite('stage/stagefront', -650, 600, 0.9, 0.9);
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		add(stageFront);
	}

	override public function createPost()
	{
		var stageCurtains:BGSprite = new BGSprite('stage/stagecurtains', -500, -300, 1.3, 1.3);
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		add(stageCurtains);
	}
}

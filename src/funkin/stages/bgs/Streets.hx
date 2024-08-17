package funkin.stages.bgs;

import funkin.objects.game.BGSprite;
import flixel.addons.display.FlxTiledSprite;

class Streets extends StageBackend
{
	// BG things
	var scrollingSky:FlxTiledSprite;
	var phillyCars:BGSprite;
	var phillyCars2:BGSprite;

	override public function create()
	{
		zoom = 0.77;

		scrollingSky = new FlxTiledSprite(Paths.content.imageGraphic('phillyStreets/phillySkybox'), 2922, 718, true, false);
		scrollingSky.setPosition(-650, -375);
		scrollingSky.scrollFactor.set(0.1, 0.1);
		scrollingSky.scale.set(0.65, 0.65);
		add(scrollingSky);

		var phillySkyline:BGSprite = new BGSprite('phillyStreets/phillySkyline', -545, -273, 0.2, 0.2);
		add(phillySkyline);

		var phillyForegroundCity:BGSprite = new BGSprite('phillyStreets/phillyForegroundCity', 625, 94, 0.3, 0.3);
		add(phillyForegroundCity);

		var phillyConstruction:BGSprite = new BGSprite('phillyStreets/phillyConstruction', 1800, 364, 0.7, 1);
		add(phillyConstruction);

		var phillyHighwayLights:BGSprite = new BGSprite('phillyStreets/phillyHighwayLights', 284, 305, 1, 1);
		add(phillyHighwayLights);

		var phillyHighwayLights_lightmap:BGSprite = new BGSprite('phillyStreets/phillyHighwayLights_lightmap', 284, 305, 1, 1);
		phillyHighwayLights_lightmap.blend = ADD;
		add(phillyHighwayLights_lightmap);

		var phillyHighway:BGSprite = new BGSprite('phillyStreets/phillyHighway', 139, 209, 1, 1);
		add(phillyHighway);

		var phillySmog:BGSprite = new BGSprite('phillyStreets/phillySmog', -6, 245, 0.8, 1);
		add(phillySmog);

		phillyCars = new BGSprite('phillyStreets/phillyCars', 1748, 818, 0.9, 1, ['car1', 'car2', 'car3', 'car4']);
		add(phillyCars);

		phillyCars2 = new BGSprite('phillyStreets/phillyCars', 1748, 818, 0.9, 1, ['car1', 'car2', 'car3', 'car4']);
		phillyCars2.flipX = true;
		add(phillyCars2);

		var phillyTraffic:BGSprite = new BGSprite('phillyStreets/phillyTraffic', 1840, 608, 0.9, 1, ['redtogreen', 'greentored']);
		add(phillyTraffic);

		var phillyTraffic_lightmap:BGSprite = new BGSprite('phillyStreets/phillyTraffic_lightmap', 1840, 608, 0.9, 1);
		phillyTraffic_lightmap.blend = ADD;
		add(phillyTraffic_lightmap);

		var phillyForeground:BGSprite = new BGSprite('phillyStreets/phillyForeground', 88, 317, 1, 1);
		add(phillyForeground);
	}

	override public function createPost()
	{
		var spraycanPile:BGSprite = new BGSprite('SpraycanPile', 920, 1045, 1, 1);
		add(spraycanPile);

		playerGroup.setPosition(2151, 1228);
		playerGroup.x -= 219.5 * 2;
		playerGroup.y -= 785;

		opponentGroup.setPosition(900, 1110);
		opponentGroup.x -= 219.5;
		opponentGroup.y -= 785;
		opponentGroup.y += 350;

		gfGroup.setPosition(1453, 900);
		gfGroup.x -= 219.5;
		gfGroup.y -= 785;
		gfGroup.y += 350;
	}

	override public function update(elapsed:Float)
	{
		if (scrollingSky != null)
			scrollingSky.scrollX -= elapsed * 22;
	}
}

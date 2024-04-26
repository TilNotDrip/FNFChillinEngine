package objects.menu;

import flixel.addons.transition.FlxTransitionableState;

import flixel.effects.FlxFlicker;

class MenuItem extends FlxSprite
{
	public var name:String;

	public function new(y:Float, name:String)
	{
		this.name = name;

		super(null, y);

		frames = Paths.getSparrowAtlas('menuUI/items/' + name);
		animation.addByPrefix('idle', name + ' idle', 24);
		animation.addByPrefix('selected', name + ' selected', 24);
		scrollFactor.set(0, 0.17);
		animation.play('idle');
		screenCenter(X);
	}

	public function press()
	{
		FlxTransitionableState.skipNextTransIn = false;
		FlxTransitionableState.skipNextTransOut = false;

		if (ChillSettings.get('flashingLights', DISPLAY))
			FlxFlicker.flicker(this, 1, 0.06, false, false);

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			switch (name)
			{
				case 'story-mode':
					FlxG.switchState(new StoryMenuState());
				case 'freeplay':
					FlxG.switchState(new FreeplayState());
				case 'donate':
					CoolUtil.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game/');
					FlxG.resetState();
				case 'options':
					FlxG.switchState(new options.states.OptionsState());
			}
		});
	}
}
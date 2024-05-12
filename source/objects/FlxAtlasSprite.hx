package objects;

import flixel.util.FlxSignal.FlxTypedSignal;
import flxanimate.FlxAnimate;
import flxanimate.FlxAnimate.Settings;
import flxanimate.frames.FlxAnimateFrames;
import openfl.display.BitmapData;
import openfl.utils.Assets;

/**
 * A sprite which provides convenience functions for rendering a texture atlas with animations.
 */
class FlxAtlasSprite extends FlxAnimate
{
  static final SETTINGS:Settings =
    {
      // ?ButtonSettings:Map<String, flxanimate.animate.FlxAnim.ButtonSettings>,
      FrameRate: 24.0,
      // ?OnComplete:Void -> Void,
      ShowPivot: #if debug false #else false #end,
      Antialiasing: true,
      ScrollFactor: null,
      // Offset: new FlxPoint(0, 0), // This is just FlxSprite.offset
    };

  /**
   * Signal dispatched when an animation finishes playing.
   */
  public var onAnimationFinish:FlxTypedSignal<String->Void> = new FlxTypedSignal<String->Void>();

  /**
   * Signal dispatched when an animation goes to the next frame.
   */
  public var onAnimationFrame:FlxTypedSignal<Int->Void> = new FlxTypedSignal<Int->Void>();

  var currentAnimation:String;

  var canPlayOtherAnims:Bool = true;

  public function new(x:Float, y:Float, ?path:String, ?settings:Settings)
  {
    if (settings == null) settings = SETTINGS;

    if (path == null)
    {
      throw 'Null path specified for FlxAtlasSprite!';
    }

    super(x, y, path, settings);

    if (this.anim.curInstance == null)
    {
      throw 'FlxAtlasSprite not initialized properly. Are you sure the path (${path}) exists?';
    }

    onAnimationFinish.add(cleanupAnimation);

    // This defaults the sprite to play the first animation in the atlas,
    // then pauses it. This ensures symbols are intialized properly.
    this.anim.play('');
    this.anim.pause();
  }

  /**
   * @return A list of all the animations this sprite has available.
   */
  public function listAnimations():Array<String>
  {
    if (this.anim == null) return [];
    var labels:Array<String> = []; 
    for(frame in this.anim.getFrameLabels())
      labels.push(frame.name);

    return labels;


    //return this.anim.getFrameLabels();
    // return [""];

    // Dear EliteMasterEric,
    // stop being on the kickstarter crack.
    // Before, this function was just return anim.getFrameLabels().
    // But...
    // THESE ARE FUCKING FLXKEYFRAMES, NOT STRINGS!!!!
    // SO NOW I GOTTA USE A FUCKING LOOP TO GET THE ACTUAL NAME,
    // WHICH WILL SLOW DOWN THE COMPLETION TIME EVEN MOREEE.
    // I am using https://github.com/FunkinCrew/flxanimate/:17e0d59fdbc2b6283a5c0e4df41f1c7f27b71c49, WHICH IS THE ONE YALL USE.
  }

  /**
   * @param id A string ID of the animation.
   * @return Whether the animation was found on this sprite.
   */
  public function hasAnimation(id:String):Bool
  {
    return getLabelIndex(id) != -1;
  }

  /**
   * @return The current animation being played.
   */
  public function getCurrentAnimation():String
  {
    return this.currentAnimation;
  }

  /**
   * `anim.finished` always returns false on looping animations,
   * but this function will return true if we are on the last frame of the looping animation.
   */
  public function isLoopFinished():Bool
  {
    if (this.anim == null) return false;
    if (!this.anim.isPlaying) return false;

    // Reverse animation finished.
    if (this.anim.reversed && this.anim.curFrame == 0) return true;
    // Forward animation finished.
    if (!this.anim.reversed && this.anim.curFrame >= (this.anim.length - 1)) return true;

    return false;
  }

  public var loop:Bool = false;

  /**
   * Plays an animation.
   * @param id A string ID of the animation to play.
   * @param restart Whether to restart the animation if it is already playing.
   * @param ignoreOther Whether to ignore all other animation inputs, until this one is done playing
   * @param loop Whether to loop the animation
   * NOTE: `loop` and `ignoreOther` are not compatible with each other!
   */
  public function playAnimation(id:String, restart:Bool = false, ignoreOther:Bool = false, ?loop:Bool = false):Void
  {
    if (loop == null) loop = false;

    this.loop = loop;

    // Skip if not allowed to play animations.
    if ((!canPlayOtherAnims && !ignoreOther)) return;

    if (id == null || id == '') id = this.currentAnimation;

    if (this.currentAnimation == id && !restart)
    {
      if (anim.isPlaying)
      {
        // Skip if animation is already playing.
        return;
      }
      else
      {
        // Resume animation if it's paused.
        anim.play('', false, false);
      }
    }

    // Skip if the animation doesn't exist
    if (!hasAnimation(id))
    {
      trace('Animation ' + id + ' not found');
      return;
    }

    // Prevent other animations from playing if `ignoreOther` is true.
    if (ignoreOther) canPlayOtherAnims = false;

    // Move to the first frame of the animation.
    goToFrameLabel(id);
    this.currentAnimation = id;
  }

  var lastFrame:Int = 0;
  public var runLabelFunctions:Bool = true;
  override public function update(elapsed:Float)
  {
    super.update(elapsed);

    if(anim.curFrame != lastFrame)
    {
      var frame:Int = anim.curFrame;
      var id:String = anim.curSymbol.name;
      var offset = loop ? 0 : -1;

      onAnimationFrame.dispatch(frame);

      if(runLabelFunctions)
      {
        var frameLabel = anim.getFrameLabel(id);
        if (frameLabel != null && frame == (frameLabel.duration + offset) + frameLabel.index)
        {
          if (loop)
          {
            playAnimation(id, true, false, true);
          }
          else
          {
            onAnimationFinish.dispatch(id);
          }
      }
      }
      else
      {
        if(anim.curFrame >= (anim.length - 1))
          onAnimationFinish.dispatch(id);
      }

      //trace('yo new frame');

      lastFrame = frame;
    }
  }

  /**
   * Stops the current animation.
   */
  public function stopAnimation():Void
  {
    if (this.currentAnimation == null) return;

    this.anim.removeAllCallbacksFrom(getNextFrameLabel(this.currentAnimation));

    goToFrameIndex(0);
  }

  function addFrameCallback(label:String, callback:Void->Void):Void
  {
    var frameLabel = this.anim.getFrameLabel(label);
    frameLabel.add(callback);
  }

  function goToFrameLabel(label:String):Void
  {
    this.anim.goToFrameLabel(label);
  }

  function getNextFrameLabel(label:String):String
  {
    return listAnimations()[(getLabelIndex(label) + 1) % listAnimations().length];
  }

  function getLabelIndex(label:String):Int
  {
    return listAnimations().indexOf(label);
  }

  function goToFrameIndex(index:Int):Void
  {
    this.anim.curFrame = index;
  }

  public function cleanupAnimation(_:String):Void
  {
    canPlayOtherAnims = true;
    // this.currentAnimation = null;
    this.anim.pause();
  }
}

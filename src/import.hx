// HEY!! Before adding something here, if you use the modding api, add it to the list in HScript.hx!
#if !macro
// Stuff from Haxelibs
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
// Stuff from Chillin' Engine/Base Friday Night Funkin' itself
import funkin.util.*;
import funkin.util.Controls;
import funkin.util.CoolUtil;
#if FUNKIN_MOD_SUPPORT
import funkin.modding.*;
#end
import funkin.objects.*;
import funkin.options.ChillSettings;
import funkin.states.game.GameBackend;
import funkin.states.game.PlayState;
import funkin.states.menus.StoryMenuState;
import funkin.states.menus.FreeplayState;
import funkin.states.menus.MainMenuState;
import funkin.states.LoadingState;

// Using
using StringTools;
using funkin.util.CoolTools;
#end

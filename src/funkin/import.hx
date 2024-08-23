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
// Stuff from Chillin' Engine/Friday Night Funkin' itself
#if FUNKIN_DISCORD_RPC
import funkin.api.DiscordRPC;
#end
import funkin.data.FunkinControls;
import funkin.data.FunkinHighscore;
import funkin.data.FunkinOptions;
import funkin.objects.Alphabet;
import funkin.objects.FlxVideo;
import funkin.states.LoadingState;
import funkin.states.game.PlayState;
import funkin.states.menus.FreeplayState;
import funkin.states.menus.MainMenuState;
import funkin.states.menus.StoryMenuState;
import funkin.util.Conductor;
import funkin.util.Constants;
import funkin.util.Controls;
import funkin.util.CoolUtil;
import funkin.util.DateUtil;
import funkin.util.MathUtil;
import funkin.util.paths.Paths;
import lime.app.Application;

// Using
using StringTools;
using funkin.util.CoolTools;
#end

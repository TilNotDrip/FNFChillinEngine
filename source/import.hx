// HEY!! Before adding something here, if you use the modding api, add it to the list in HScript.hx!
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
#if FUNKIN_DISCORD_RPC
import api.DiscordRPC;
#end
#if FUNKIN_MOD_SUPPORT
import modding.HScript;
import modding.ModHandler;
#end
import modding.Module; // im going to use this for some other things
import objects.*;
import options.ChillSettings;
import states.game.GameBackend;
import states.game.PlayState;
import states.menus.StoryMenuState;
import states.menus.FreeplayState;
import states.menus.MainMenuState;
import states.LoadingState;
import structures.ModStructures;
import utils.*;
import utils.Controls;
import utils.CoolUtil;
import utils.paths.Paths;

// Using
using StringTools;
using utils.CoolTools;

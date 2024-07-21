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
import data.ChillSettings;
import data.Highscore;
import data.PlayerSettings;
#if FUNKIN_MOD_SUPPORT
import modding.HScript;
import modding.ModHandler;
#end
import modding.Module;
import objects.*;
import states.game.GameBackend;
import states.game.PlayState;
import states.menus.FreeplayState;
import states.menus.StoryMenuState;
import states.menus.MainMenuState;
import states.LoadingState;
import states.MusicBeatState;
import substates.menus.StickerSubState;
import substates.MusicBeatSubstate;
import structures.ModStructures;
import utils.Conductor;
import utils.Constants;
import utils.Controls;
import utils.CoolUtil;
import utils.LerpTween;
import utils.paths.Paths;

// Using
using StringTools;
using utils.CoolTools;

// HEY!! Before adding something here, if you use the modding api, add it to the list in HScript.hx!

// Stuff from Haxelibs
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
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
import addons.*;
import addons.Controls;
import addons.CoolUtil;

#if discord_rpc
import addons.discord.LegacyDiscord as DiscordClient;
#end

import objects.*;

import options.ChillSettings;

import states.game.GameBackend;
import states.game.PlayState;

import states.menus.StoryMenuState;
import states.menus.FreeplayState;
import states.menus.MainMenuState;

import states.LoadingState;

// Using
using StringTools;
using addons.CoolTools;
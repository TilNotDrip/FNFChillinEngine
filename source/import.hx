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

// Stuff from TechNotDrip Engine/Base Friday Night Funkin' itself
import addons.*;
import addons.Controls;

#if discord_rpc
import addons.discord.LegacyDiscord as DiscordClient;
#end

#if DISCORD
import addons.discord.Discord;
#end

import objects.Alphabet;
import objects.BGSprite;

import options.PreferencesMenu;

import states.PlayState;
import states.LoadingState;

// String Tools!
using StringTools;

// Cool Thingies
import addons.CoolUtil;
using addons.CoolTools;
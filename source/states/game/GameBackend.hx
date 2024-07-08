package states.game;

import addons.Section.SwagSection;
import addons.Song.SwagSong;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.addons.effects.FlxTrail;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.ui.FlxBar;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
#if hxvlc
import hxvlc.flixel.FlxVideo;
#end
import objects.game.*;
import stages.StageBackend;
import stages.bgs.*;
import states.tools.*;
import substates.*;

// gonna rewrite this for PlayState and ChartTestState
class GameBackend extends MusicBeatState
{
	public static var SONG:SwagSong;
	public static var difficulty:String = 'Normal';

	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;

	public static var daPixelZoom:Float = 6;

	public var isPixel:Bool = false;

	public var vocals:FlxSound;
	public var vocalsFinished:Bool = false;

	public var camGAME:FlxCamera;
	public var camHUD:FlxCamera;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	public var strumLineNotes:FlxTypedGroup<Strums>;

	public var playerStrums:Strums;
	public var playerSplashes:FlxTypedGroup<NoteSplash>;

	public var opponentStrums:Strums;
	public var opponentSplashes:FlxTypedGroup<NoteSplash>;

	public static var game:GameBackend;

	override public function create()
	{
		game = this;

		super.create();
	}
}

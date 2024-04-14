package states.tools;

import flixel.util.FlxSort;
import addons.SongEvent.SwagEvent;
import addons.Conductor.BPMChangeEvent;
import addons.Section.SwagSection;
import addons.Song.SwagSong;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;

import flixel.ui.FlxButton;

import haxe.Json;

import objects.game.HealthIcon;
import objects.game.Note;

import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;

class ChartingState extends MusicBeatState
{
	var _file:FileReference;

	var UI_box:FlxUITabMenu;

	var curSec:Int = 0;

	public static var lastSection:Int = 0;

	var bpmTxt:FlxText;

	var strumLine:FlxSprite;
	var curSong:String = 'Test';
	var amountSteps:Int = 0;
	var bullshitUI:FlxGroup;

	var highlight:FlxSprite;

	var GRID_SIZE:Int = 40;

	var dummyArrow:FlxSprite;

	var curRenderedNotes:FlxTypedGroup<Note>;
	var curRenderedSustains:FlxTypedGroup<FlxSprite>;
	var curRenderedEvents:FlxTypedGroup<FlxSprite>;

	var gridBG:FlxSprite;

	var _song:SwagSong;
	var _events:Array<SwagEvent>;

	var typingShits:Array<FlxUIInputText> = [];
	var curSelectedNote:Array<Dynamic>;
	var curSelectedEvent:SwagEvent;

	var tempBpm:Float = 0;

	var vocals:FlxSound;
	var hitsound:FlxSound;

	var leftIcon:HealthIcon;
	var rightIcon:HealthIcon;

	override function create()
	{
		if (PlayState.SONG != null)
		{
			_song = PlayState.SONG;
			_events = PlayState.songEvents;
		}
		else
		{
			_song = {
				song: 'Test',
				notes: [],
				bpm: 150,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
				player3: 'gf',
				stage: '',
				speed: 1,
				validScore: false
			};
		}

		FlxG.mouse.visible = true;
		//how to get package name thingy? idk
		FlxG.save.bind('chillinengine', Application.current.meta.get('company'));

		tempBpm = _song.bpm;

		changeWindowName('Charting Menu - ' + _song.song);

		curSection = lastSection;

		var actualBG:FlxSprite = new FlxSprite(Paths.image('menuUI/menuDesat'));
		actualBG.scale.set(1.2, 1.2);
		actualBG.updateHitbox();
		actualBG.screenCenter();
		actualBG.scrollFactor.set(0.005, 0.005);
		actualBG.color = 0xFF414141;
		add(actualBG);

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16);

		var eventStrip:FlxSprite = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE, GRID_SIZE * 16, true, 0xffd9d5d5, 0xffe7e6e6);
		eventStrip.x = -GRID_SIZE;

		var actualGridBG:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(GRID_SIZE, GRID_SIZE, GRID_SIZE * 9, GRID_SIZE * 2, true, 0xffe7e6e6, 0xffd9d5d5), Y);
		actualGridBG.setPosition(gridBG.x - GRID_SIZE, gridBG.y);
		actualGridBG.alpha = 0.7;

		add(gridBG);
		add(eventStrip);
		add(actualGridBG);

		leftIcon = new HealthIcon('bf');
		rightIcon = new HealthIcon('dad');
		leftIcon.scrollFactor.set(1, 1);
		rightIcon.scrollFactor.set(1, 1);

		leftIcon.setGraphicSize(0, 45);
		rightIcon.setGraphicSize(0, 45);

		add(leftIcon);
		add(rightIcon);

		leftIcon.setPosition(0, -100);
		rightIcon.setPosition(gridBG.width / 2, -100);

		var gridBlackLine:FlxBackdrop = new FlxBackdrop(FlxG.bitmap.create(2, Std.int(gridBG.height), FlxColor.BLACK, false, null), Y);
		gridBlackLine.x = gridBG.x + GRID_SIZE * 4;
		add(gridBlackLine);

		var gridBlackLineAgain:FlxBackdrop = new FlxBackdrop(FlxG.bitmap.create(2, Std.int(gridBG.height), FlxColor.BLACK, false, null), Y);
		add(gridBlackLineAgain);

		curRenderedNotes = new FlxTypedGroup<Note>();
		curRenderedSustains = new FlxTypedGroup<FlxSprite>();
		curRenderedEvents = new FlxTypedGroup<FlxSprite>();

		addSection();

		updateGrid();

		loadSong(_song.song);
		Conductor.changeBPM(_song.bpm);
		Conductor.mapBPMChanges(_song);

		bpmTxt = new FlxText(1000, 50, 0, "", 16);
		bpmTxt.scrollFactor.set();
		add(bpmTxt);

		strumLine = new FlxSprite(GRID_SIZE * 4, 50).makeGraphic(Std.int(GRID_SIZE * 8), 4);
		add(strumLine);

		dummyArrow = new FlxSprite().makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		var tabs = [
			{name: "Song", label: 'Song'},
			{name: "Section", label: 'Section'},
			{name: "Event", label: 'Event'},
			{name: "Note", label: 'Note'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(300, 400);
		UI_box.x = FlxG.width / 2;
		UI_box.y = 20;
		add(UI_box);

		addSongUI();
		addSectionUI();
		addNoteUI();
		addEventUI();

		add(curRenderedNotes);
		add(curRenderedSustains);
		add(curRenderedEvents);

		changeSection();
		super.create();
	}

	function addSongUI():Void
	{
		var UI_songTitle = new FlxUIInputText(10, 10, 70, _song.song, 8);
		typingShits[0] = UI_songTitle;

		var check_voices = new FlxUICheckBox(10, 25, null, null, "Has voice track", 100);
		check_voices.checked = _song.needsVoices;
		check_voices.callback = function()
		{
			_song.needsVoices = check_voices.checked;
			trace('CHECKED!');
		};

		var check_mute_inst = new FlxUICheckBox(10, 300, null, null, "Mute Instrumental (in editor)", 100);
		check_mute_inst.checked = false;
		check_mute_inst.callback = function()
		{
			var vol:Float = 1;

			if (check_mute_inst.checked)
				vol = 0;

			FlxG.sound.music.volume = vol;
		};

		var check_mute_voices = new FlxUICheckBox(140, 300, null, null, "Mute Voices (in editor)", 100);
		check_mute_voices.checked = false;
		check_mute_voices.callback = function()
		{
			var vol:Float = 1;

			if (check_mute_voices.checked)
				vol = 0;

			vocals.volume = vol;
		};

		var check_hitsound = new FlxUICheckBox(10, 330, null, null, "Play Hitsounds (in editor)", 100);
		check_hitsound.checked = false;
		check_hitsound.callback = function()
		{
			var vol:Float = 0;

			if (check_hitsound.checked)
				vol = 1;

			hitsound.volume = vol;
		};

		var saveButton:FlxButton = new FlxButton(110, 8, "Save Song", saveLevel);

		var saveEventButton:FlxButton = new FlxButton(saveButton.x + saveButton.width + 10, saveButton.y, "Save Events", saveEvents);

		var reloadSong:FlxButton = new FlxButton(saveEventButton.x, saveEventButton.y + 30, "Reload Audio", function()
		{
			loadSong(_song.song.formatToPath());
		});

		var reloadSongJson:FlxButton = new FlxButton(reloadSong.x, reloadSong.y + 30, "Reload JSON", function()
		{
			loadJson(_song.song.formatToPath());
		});

		var loadAutosaveBtn:FlxButton = new FlxButton(reloadSongJson.x, reloadSongJson.y + 30, 'load autosave', loadAutosave);

		var stepperSpeed:FlxUINumericStepper = new FlxUINumericStepper(10, 80, 0.1, 1, 0.1, 10, 2);
		stepperSpeed.value = _song.speed;
		stepperSpeed.name = 'song_speed';

		var stepperBPM:FlxUINumericStepper = new FlxUINumericStepper(10, 65, 1, 100, 1, 999, 3);
		stepperBPM.value = Conductor.bpm;
		stepperBPM.name = 'song_bpm';

		var characters:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));
		var stages:Array<String> = CoolUtil.coolTextFile(Paths.txt('stageList'));

		var player1DropDown = new FlxUIDropDownMenu(10, loadAutosaveBtn.y + 30, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player1 = characters[Std.parseInt(character)];
			updateHeads();
		});
		player1DropDown.selectedLabel = _song.player1;

		var player2DropDown = new FlxUIDropDownMenu(140, loadAutosaveBtn.y + 30, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player2 = characters[Std.parseInt(character)];
			updateHeads();
		});
		player2DropDown.selectedLabel = _song.player2;

		var player3DropDown = new FlxUIDropDownMenu(140, loadAutosaveBtn.y + 60, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player3 = characters[Std.parseInt(character)];
			updateHeads();
		});
		player3DropDown.selectedLabel = _song.player3;


		var stageDropDown = new FlxUIDropDownMenu(10, loadAutosaveBtn.y + 60, FlxUIDropDownMenu.makeStrIdLabelArray(stages, true), function(stage:String)
		{
			_song.stage = stages[Std.parseInt(stage)];
		});

		stageDropDown.selectedLabel = _song.stage;

		var tab_group_song = new FlxUI(null, UI_box);
		tab_group_song.name = "Song";
		tab_group_song.add(UI_songTitle);

		tab_group_song.add(check_voices);
		tab_group_song.add(check_mute_inst);
		tab_group_song.add(check_mute_voices);
		tab_group_song.add(check_hitsound);
		tab_group_song.add(saveButton);
		tab_group_song.add(saveEventButton);
		tab_group_song.add(reloadSong);
		tab_group_song.add(reloadSongJson);
		tab_group_song.add(loadAutosaveBtn);
		tab_group_song.add(stepperBPM);
		tab_group_song.add(stepperSpeed);
		tab_group_song.add(stageDropDown);
		tab_group_song.add(player3DropDown);
		tab_group_song.add(player1DropDown);
		tab_group_song.add(player2DropDown);

		UI_box.addGroup(tab_group_song);
		UI_box.scrollFactor.set();

		FlxG.camera.follow(strumLine);
	}

	var stepperLength:FlxUINumericStepper;
	var check_mustHitSection:FlxUICheckBox;
	var check_changeBPM:FlxUICheckBox;
	var stepperSectionBPM:FlxUINumericStepper;
	var check_altAnim:FlxUICheckBox;

	function addSectionUI():Void
	{
		var tab_group_section = new FlxUI(null, UI_box);
		tab_group_section.name = 'Section';

		stepperLength = new FlxUINumericStepper(10, 10, 4, 0, 0, 999, 0);
		stepperLength.value = _song.notes[curSec].lengthInSteps;
		stepperLength.name = "section_length";

		stepperSectionBPM = new FlxUINumericStepper(10, 80, 1, Conductor.bpm, 1, 999, 3);
		stepperSectionBPM.value = Conductor.bpm;
		stepperSectionBPM.name = 'section_bpm';

		var stepperCopy:FlxUINumericStepper = new FlxUINumericStepper(110, 130, 1, 1, -999, 999, 0);

		var copyButton:FlxButton = new FlxButton(10, 130, "Copy last section", function()
		{
			copySection(Std.int(stepperCopy.value));
		});

		var clearSectionButton:FlxButton = new FlxButton(10, 150, "Clear Section", clearSection);

		var clearSongButton:FlxButton = new FlxButton(10, 170, "Clear Song", clearSong);

		var swapSection:FlxButton = new FlxButton(10, 190, "Swap section", function()
		{
			for (i in 0..._song.notes[curSec].sectionNotes.length)
			{
				var note = _song.notes[curSec].sectionNotes[i];
				note[1] = (note[1] + 4) % 8;
				_song.notes[curSec].sectionNotes[i] = note;
				updateGrid();
			}
		});

		check_mustHitSection = new FlxUICheckBox(10, 30, null, null, "Must hit section", 100);
		check_mustHitSection.name = 'check_mustHit';
		check_mustHitSection.checked = true;

		check_altAnim = new FlxUICheckBox(10, 400, null, null, "Alt Animation", 100);
		check_altAnim.name = 'check_altAnim';

		check_changeBPM = new FlxUICheckBox(10, 60, null, null, 'Change BPM', 100);
		check_changeBPM.name = 'check_changeBPM';

		tab_group_section.add(stepperLength);
		tab_group_section.add(stepperSectionBPM);
		tab_group_section.add(stepperCopy);
		tab_group_section.add(check_mustHitSection);
		tab_group_section.add(check_altAnim);
		tab_group_section.add(check_changeBPM);
		tab_group_section.add(copyButton);
		tab_group_section.add(clearSectionButton);
		tab_group_section.add(clearSongButton);
		tab_group_section.add(swapSection);

		UI_box.addGroup(tab_group_section);
	}

	var stepperSusLength:FlxUINumericStepper;

	function addNoteUI():Void
	{
		var tab_group_note = new FlxUI(null, UI_box);
		tab_group_note.name = 'Note';

		stepperSusLength = new FlxUINumericStepper(10, 10, Conductor.stepCrochet / 2, 0, 0, Conductor.stepCrochet * 16);
		stepperSusLength.value = 0;
		stepperSusLength.name = 'note_susLength';

		var applyLength:FlxButton = new FlxButton(100, 10, 'Apply');

		tab_group_note.add(stepperSusLength);
		tab_group_note.add(applyLength);

		UI_box.addGroup(tab_group_note);
	}

	var eventDropDown:FlxUIDropDownMenu;

	function addEventUI():Void
	{
		var tab_group_event = new FlxUI(null, UI_box);
		tab_group_event.name = 'Event';

		var ohMyGod:Array<String> = [];
		for(i in SongEvent.events) ohMyGod.push(i[0]);

		var eventDescription:FlxText = new FlxText(10, 200, 0, " ", 8);
		eventDescription.scrollFactor.set();

		eventDropDown = new FlxUIDropDownMenu(10, 60, FlxUIDropDownMenu.makeStrIdLabelArray(ohMyGod, true), function(name:String)
		{
			if(curSelectedEvent != null) 
			{
				curSelectedEvent.name = SongEvent.events[Std.parseInt(name)][0];
				eventDescription.text = SongEvent.events[Std.parseInt(name)][1];
			}
			
		});
		eventDropDown.selectedLabel = ' ';

		eventDescription.fieldWidth = eventDropDown.width;

		var parameterValue:FlxUINumericStepper = new FlxUINumericStepper(10, 120, 1, 0, 0, 9);
		parameterValue.value = 0;
		parameterValue.name = 'event_paramNumber';

		var parameterType = new FlxUIInputText(10, 140, 70, '', 8);
		parameterType.callback = function(value:String, action:String) {
			if(curSelectedEvent != null) curSelectedEvent.value = value;
		}
		typingShits[1] = parameterType;

		tab_group_event.add(eventDropDown);
		tab_group_event.add(parameterValue);
		tab_group_event.add(parameterType);
		tab_group_event.add(eventDescription);

		UI_box.addGroup(tab_group_event);
	}

	function updateEventUI()
	{
		if(curSelectedEvent != null)
		{
			eventDropDown.selectedLabel = curSelectedEvent.name;
			typingShits[1].text = curSelectedEvent.value;
		} 
		else 
		{
			eventDropDown.selectedLabel = ' ';
		}
	}

	function loadSong(daSong:String):Void
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}

		FlxG.sound.playMusic(Paths.inst(daSong), 0.6);

		vocals = new FlxSound().loadEmbedded(Paths.voices(daSong));
		FlxG.sound.list.add(vocals);

		hitsound = new FlxSound().loadEmbedded(Paths.sound('hitsound'));
		FlxG.sound.list.add(hitsound);

		FlxG.sound.music.pause();
		vocals.pause();
		hitsound.pause();

		FlxG.sound.music.onComplete = function()
		{
			vocals.pause();
			vocals.time = 0;
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
			changeSection();
		};
	}

	function generateUI():Void
	{
		while (bullshitUI.members.length > 0)
		{
			bullshitUI.remove(bullshitUI.members[0], true);
		}

		var title:FlxText = new FlxText(UI_box.x + 20, UI_box.y + 20, 0);
		bullshitUI.add(title);
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if (id == FlxUICheckBox.CLICK_EVENT)
		{
			var check:FlxUICheckBox = cast sender;
			var label = check.getLabel().text;
			switch (label)
			{
				case 'Must hit section':
					_song.notes[curSec].mustHitSection = check.checked;

					updateHeads();

				case 'Change BPM':
					_song.notes[curSec].changeBPM = check.checked;
					FlxG.log.add('changed bpm shit');
				case "Alt Animation":
					_song.notes[curSec].altAnim = check.checked;
			}
		}
		else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			FlxG.log.add(wname);
			if (wname == 'section_length')
			{
				_song.notes[curSec].lengthInSteps = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'song_speed')
			{
				_song.speed = nums.value;
			}
			else if (wname == 'song_bpm')
			{
				tempBpm = nums.value;
				Conductor.mapBPMChanges(_song);
				Conductor.changeBPM(nums.value);
			}
			else if (wname == 'note_susLength')
			{
				if(curSelectedNote != null)
					curSelectedNote[2] = nums.value;

				updateGrid();
			}
			else if (wname == 'section_bpm')
			{
				_song.notes[curSec].bpm = nums.value;
				updateGrid();
			}
		}
	}

	var updatedSection:Bool = false;

	function sectionStartTime():Float
	{
		var daBPM:Float = _song.bpm;
		var daPos:Float = 0;
		for (i in 0...curSec)
		{
			if (_song.notes[i].changeBPM)
			{
				daBPM = _song.notes[i].bpm;
			}
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}

	var alreadyPlayedNotes:Array<Note> = [];
	override function update(elapsed:Float)
	{
		curStep = recalculateSteps();

		Conductor.songPosition = FlxG.sound.music.time;
		_song.song = typingShits[0].text;

		strumLine.y = getYfromStrum((Conductor.songPosition - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSec].lengthInSteps));

		if (FlxG.keys.justPressed.X)
			toggleAltAnimNote();

		if (curBeat % 4 == 0 && curStep >= 16 * (curSec + 1))
		{
			trace(curStep);
			trace((_song.notes[curSec].lengthInSteps) * (curSec + 1));
			trace('DUMBSHIT');

			if (_song.notes[curSec + 1] == null)
			{
				addSection();
			}

			changeSection(curSec + 1, false);
		}

		FlxG.watch.addQuick('daSection', curSection);
		FlxG.watch.addQuick('daBeat', curBeat);
		FlxG.watch.addQuick('daStep', curStep);
		FlxG.watch.addQuick('curEvent', curSelectedEvent);

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(curRenderedNotes))
			{
				curRenderedNotes.forEach(function(note:Note)
				{
					if (FlxG.mouse.overlaps(note))
					{
						if (FlxG.keys.pressed.CONTROL)
						{
							selectNote(note);
							trace('Selected note');
						}
						else
						{
							trace('tryin to delete note...');
							deleteNote(note);
						}
					}
				});
			}
			else
			{
				if (FlxG.mouse.x > gridBG.x
					&& FlxG.mouse.x < gridBG.x + gridBG.width
					&& FlxG.mouse.y > gridBG.y
					&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSec].lengthInSteps))
				{
					addNote();
				}
			}

			if (FlxG.mouse.overlaps(curRenderedEvents))
			{
				curRenderedEvents.forEach(function(event:FlxSprite)
				{
					if (FlxG.mouse.overlaps(event))
					{
						if (FlxG.keys.pressed.CONTROL)
						{
							selectEvent(spriteToEvent.get(event));
						}
						else
						{
							trace('tryin to delete note...');
							deleteEvent(spriteToEvent.get(event));
						}
					}
				});
			}
			else
			{
				if (FlxG.mouse.x > gridBG.x - GRID_SIZE
					&& FlxG.mouse.x < gridBG.x
					&& FlxG.mouse.y > gridBG.y
					&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSec].lengthInSteps))
				{
					addEvent();
				}
			}
		}

		curRenderedNotes.forEach(function(note:Note)
		{
			if(FlxG.sound.music.playing && Conductor.songPosition >= note.strumTime && alreadyPlayedNotes.indexOf(note) == -1)
			{
				hitsound.play(true);
				alreadyPlayedNotes.push(note);
			}
		});

		if (FlxG.mouse.x > gridBG.x - GRID_SIZE
			&& FlxG.mouse.x < gridBG.x + gridBG.width
			&& FlxG.mouse.y > gridBG.y
			&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSec].lengthInSteps))
		{
			dummyArrow.x = Math.floor(FlxG.mouse.x / GRID_SIZE) * GRID_SIZE;
			if (FlxG.keys.pressed.SHIFT)
				dummyArrow.y = FlxG.mouse.y;
			else
				dummyArrow.y = Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.mouse.visible = false;
			lastSection = curSec;

			PlayState.SONG = _song;
			FlxG.sound.music.stop();
			vocals.stop();
			LoadingState.loadAndSwitchState(new PlayState());
		}

		if (FlxG.keys.justPressed.E)
		{
			changeNoteSustain(Conductor.stepCrochet);
		}
		if (FlxG.keys.justPressed.Q)
		{
			changeNoteSustain(-Conductor.stepCrochet);
		}

		if (FlxG.keys.justPressed.TAB)
		{
			if (FlxG.keys.pressed.SHIFT)
			{
				UI_box.selected_tab -= 1;
				if (UI_box.selected_tab < 0)
					UI_box.selected_tab = 2;
			}
			else
			{
				UI_box.selected_tab += 1;
				if (UI_box.selected_tab >= 3)
					UI_box.selected_tab = 0;
			}
		}

		var noFocused:Bool = true;
		for(typingShit in typingShits)
		{
			if(typingShit.hasFocus) noFocused = false;
		}

		if (noFocused)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				if (FlxG.sound.music.playing)
				{
					FlxG.sound.music.pause();
					vocals.pause();
				}
				else
				{
					vocals.play();
					FlxG.sound.music.play();

					while (alreadyPlayedNotes.length > 0)
					{
						alreadyPlayedNotes.remove(alreadyPlayedNotes[0]);
					}

					curRenderedNotes.forEach(function(note:Note)
					{
						if(Conductor.songPosition >= note.strumTime) 
							alreadyPlayedNotes.push(note);
					});
				}
			}

			if (FlxG.keys.justPressed.R)
			{
				if (FlxG.keys.pressed.SHIFT)
					resetSection(true);
				else
					resetSection();
			}

			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				FlxG.sound.music.time -= (FlxG.mouse.wheel * Conductor.stepCrochet * 0.4);
				vocals.time = FlxG.sound.music.time;
			}

			if (!FlxG.keys.pressed.SHIFT)
			{
				if (FlxG.keys.pressed.W || FlxG.keys.pressed.S)
				{
					FlxG.sound.music.pause();
					vocals.pause();

					var daTime:Float = 700 * FlxG.elapsed;

					if (FlxG.keys.pressed.W)
					{
						FlxG.sound.music.time -= daTime;
					}
					else
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
			else
			{
				if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.S)
				{
					FlxG.sound.music.pause();
					vocals.pause();

					var daTime:Float = Conductor.stepCrochet * 2;

					if (FlxG.keys.justPressed.W)
					{
						FlxG.sound.music.time -= daTime;
					}
					else
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
		}

		_song.bpm = tempBpm;

		var shiftThing:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftThing = 4;
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
			changeSection(curSec + shiftThing);
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
			changeSection(curSec - shiftThing);

		bpmTxt.text = bpmTxt.text = Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2))
			+ " / "
			+ Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2))
			+ "\nSection: "
			+ curSec;

		_events.sort(sortEvents);

		super.update(elapsed);
	}

	function changeNoteSustain(value:Float):Void
	{
		if (curSelectedNote != null)
		{
			if (curSelectedNote[2] != null)
			{
				curSelectedNote[2] += value;
				curSelectedNote[2] = Math.max(curSelectedNote[2], 0);
			}
		}

		updateNoteUI();
		updateGrid();
	}

	function toggleAltAnimNote():Void
	{
		if (curSelectedNote != null)
		{
			if (curSelectedNote[3] != null)
			{
				trace('ALT NOTE SHIT');
				curSelectedNote[3] = !curSelectedNote[3];
				trace(curSelectedNote[3]);
			}
			else
				curSelectedNote[3] = true;
		}
	}

	function recalculateSteps():Int
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (FlxG.sound.music.time > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((FlxG.sound.music.time - lastChange.songTime) / Conductor.stepCrochet);
		updateBeat();

		return curStep;
	}

	function resetSection(songBeginning:Bool = false):Void
	{
		updateGrid();

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = sectionStartTime();

		if (songBeginning)
		{
			FlxG.sound.music.time = 0;
			curSec = 0;
		}

		vocals.time = FlxG.sound.music.time;
		updateStep();

		updateGrid();
		updateSectionUI();
	}

	function changeSection(sec:Int = 0, ?updateMusic:Bool = true):Void
	{
		trace('changing section' + sec);

		

		if (_song.notes[sec] != null)
		{
			curSec = sec;

			updateGrid();

			if (updateMusic)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				FlxG.sound.music.time = sectionStartTime();
				vocals.time = FlxG.sound.music.time;
				updateStep();
			}

			updateGrid();
			updateSectionUI();
		}
	}

	function copySection(?sectionNum:Int = 1)
	{
		var daSec = FlxMath.maxInt(curSec, sectionNum);

		for (note in _song.notes[daSec - sectionNum].sectionNotes)
		{
			var strum = note[0] + Conductor.stepCrochet * (_song.notes[daSec].lengthInSteps * sectionNum);

			var copiedNote:Array<Dynamic> = [strum, note[1], note[2]];
			_song.notes[daSec].sectionNotes.push(copiedNote);
		}

		updateGrid();
	}

	function updateSectionUI():Void
	{
		var sec = _song.notes[curSec];

		stepperLength.value = sec.lengthInSteps;
		check_mustHitSection.checked = sec.mustHitSection;
		check_altAnim.checked = sec.altAnim;
		check_changeBPM.checked = sec.changeBPM;
		stepperSectionBPM.value = sec.bpm;

		updateHeads();
	}

	function updateHeads():Void
	{
		if (check_mustHitSection.checked)
		{
			leftIcon.changeIcon(_song.player1);
			rightIcon.changeIcon(_song.player2);
		}
		else
		{
			leftIcon.changeIcon(_song.player2);
			rightIcon.changeIcon(_song.player1);
		}
	}

	function updateNoteUI():Void
	{
		if (curSelectedNote != null)
			stepperSusLength.value = curSelectedNote[2];
	}

	var spriteToEvent:Map<FlxSprite, SwagEvent> = new Map();
	function updateGrid():Void
	{
		while (curRenderedNotes.members.length > 0)
		{
			curRenderedNotes.remove(curRenderedNotes.members[0], true);
		}

		while (curRenderedSustains.members.length > 0)
		{
			curRenderedSustains.remove(curRenderedSustains.members[0], true);
		}

		while (curRenderedEvents.members.length > 0)
		{
			curRenderedEvents.remove(curRenderedEvents.members[0], true);
		}

		var sectionInfo:Array<Dynamic> = _song.notes[curSec].sectionNotes;

		if (_song.notes[curSec].changeBPM && _song.notes[curSec].bpm > 0)
		{
			Conductor.changeBPM(_song.notes[curSec].bpm);
			FlxG.log.add('CHANGED BPM!');
		}
		else
		{
			var daBPM:Float = _song.bpm;
			for (i in 0...curSec)
				if (_song.notes[i].changeBPM)
					daBPM = _song.notes[i].bpm;
			Conductor.changeBPM(daBPM);
		}

		for (i in sectionInfo)
		{
			var daNoteInfo = i[1];
			var daStrumTime = i[0];
			var daSus = i[2];

			var note:Note = new Note(daStrumTime, daNoteInfo % 4, PlayState.isPixel);
			note.sustainLength = daSus;
			note.setGraphicSize(GRID_SIZE, GRID_SIZE);
			note.updateHitbox();
			note.x = Math.floor(daNoteInfo * GRID_SIZE);
			note.y = Math.floor(getYfromStrum((daStrumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSec].lengthInSteps)));

			curRenderedNotes.add(note);

			if (daSus > 0)
			{
				var sustainVis:FlxSprite = new FlxSprite(note.x + (GRID_SIZE / 2) - 4,
					note.y + GRID_SIZE).makeGraphic(8, Math.floor(FlxMath.remapToRange(daSus, 0, Conductor.stepCrochet * 16, 0, gridBG.height)));
				curRenderedSustains.add(sustainVis);
			}
		}

		for(i in _events)
		{
			if(i.strumTime >= sectionStartTime() && i.strumTime <= sectionStartTime() + (Conductor.stepCrochet * _song.notes[curSec].lengthInSteps)) 
			{
				var event:FlxSprite = new FlxSprite(-GRID_SIZE);
				event.loadGraphic(Paths.image('charting/event'));
				event.y = Math.floor(getYfromStrum((i.strumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSec].lengthInSteps)));
				curRenderedEvents.add(event);
				spriteToEvent.set(event, i);
			}
		}
	}

	private function addSection(lengthInSteps:Int = 16):Void
	{
		var sec:SwagSection = {
			lengthInSteps: lengthInSteps,
			bpm: _song.bpm,
			changeBPM: false,
			mustHitSection: true,
			sectionNotes: [],
			typeOfSection: 0,
			altAnim: false
		};

		_song.notes.push(sec);
	}

	function selectNote(note:Note):Void
	{
		for (i in _song.notes[curSec].sectionNotes)
		{
			if (i.strumTime == note.strumTime && i.noteData == note.noteData)
			{
				curSelectedNote = i;
				trace('found note');
			}
		}

		updateGrid();
		updateNoteUI();
	}

	function deleteNote(note:Note):Void
	{
		for (i in _song.notes[curSec].sectionNotes)
		{
			if (i[0] == note.strumTime && i[1] % 4 == note.noteData)
			{
				_song.notes[curSec].sectionNotes.remove(i);
			}
		}

		updateEventUI();
		updateGrid();
	}

	function selectEvent(event:SwagEvent):Void
	{
		curSelectedEvent = event;

		updateEventUI();
		updateGrid();
	}

	function deleteEvent(event:SwagEvent):Void
	{
		_events.remove(event);

		updateGrid();
	}

	function sortEvents(Obj1:SwagEvent, Obj2:SwagEvent)
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function clearSection():Void
	{
		_song.notes[curSec].sectionNotes = [];

		updateGrid();
	}

	function clearSong():Void
	{
		for (daSection in 0..._song.notes.length)
		{
			_song.notes[daSection].sectionNotes = [];
		}

		updateGrid();
	}

	private function addNote():Void
	{
		var noteStrum = getStrumTime(dummyArrow.y) + sectionStartTime();
		var noteData = Math.floor(FlxG.mouse.x / GRID_SIZE);
		var noteSus = 0;
		var noteAlt = false;

		_song.notes[curSec].sectionNotes.push([noteStrum, noteData, noteSus, noteAlt]);

		curSelectedNote = _song.notes[curSec].sectionNotes[_song.notes[curSec].sectionNotes.length - 1];

		if (FlxG.keys.pressed.CONTROL)
		{
			_song.notes[curSec].sectionNotes.push([noteStrum, (noteData + 4) % 8, noteSus, noteAlt]);
		}

		trace(noteStrum);
		trace(curSec);

		updateGrid();
		updateNoteUI();

		autosaveSong();
	}

	private function addEvent():Void
	{
		var eventStrum = getStrumTime(dummyArrow.y) + sectionStartTime();

		var outOfWombEvent:SwagEvent = {strumTime: eventStrum, name: '', value: ''};
		if(curSelectedEvent != null)
		{
			outOfWombEvent.name = curSelectedEvent.name;
			outOfWombEvent.value = curSelectedEvent.value;
		}
		_events.push(outOfWombEvent);
		curSelectedEvent = outOfWombEvent;

		updateGrid();
		updateEventUI();
		autosaveSong();
	}

	function getStrumTime(yPos:Float):Float
	{
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.stepCrochet);
	}

	function getYfromStrum(strumTime:Float):Float
	{
		return FlxMath.remapToRange(strumTime, 0, 16 * Conductor.stepCrochet, gridBG.y, gridBG.y + gridBG.height);
	}

	private var daSpacing:Float = 0.3;

	function loadLevel():Void
	{
		trace(_song.notes);
	}

	function getNotes():Array<Dynamic>
	{
		var noteData:Array<Dynamic> = [];

		for (i in _song.notes)
		{
			noteData.push(i.sectionNotes);
		}

		return noteData;
	}

	function loadJson(song:String):Void
	{
		PlayState.SONG = Song.loadFromJson(PlayState.difficulty.formatToPath(), song.formatToPath());
		LoadingState.loadAndSwitchState(new ChartingState());
	}

	function loadAutosave():Void
	{
		PlayState.SONG = Song.parseJSONshit(FlxG.save.data.autosave);
		FlxG.resetState();
	}

	function autosaveSong():Void
	{
		FlxG.save.data.autosave = Json.stringify({
			"song": _song
		});
		FlxG.save.flush();
	}

	private function saveLevel()
	{
		var json = {
			"song": _song
		};

		var data:String = Json.stringify(json);

		if ((data != null) && (data.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), PlayState.difficulty.formatToPath() + ".json");
		}
	}

	private function saveEvents()
	{
		var json = {
			"events": _events
		};

		var data:String = Json.stringify(json);

		if ((data != null) && (data.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), "events.json");
		}
	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}

	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}
}

# Chillin' Engine - Todo List
<!-- TODO: Organize this better, maybe alphabetical order and add Sections to the _Size_ Changes (or add sections and put _Size_ Changes inside the sections for each one. And also a name list e.g. songName == Song being played || player == Boyfriend / Player || user == The person playing this game. -->
## Big Changes
 - [ ] Credits Menu (not GitHub Contributors menu :D)
 - [ ] Controller Support
 - [ ] Converter that converts Base FNF things to Chillin ([will be making an application for that and other engines too.](https://github.com/TilNotDrip/Funkin-Converter))
 - [ ] Discord Game SDK (making it a haxelib, dunno if it will be finished tho.)
 - [ ] Erect Remixes
 - [x] Full Options Menu Rework
 - [ ] Lyrics (Preferably not an event instead a json that gets loaded like FNFever)
 - [ ] Modding API
 - [ ] Results Screen
 - [ ] Stats Menu
 - [x] Title Screen Softcoded
 - [ ] Weekend 1

## Medium Changes
 - [x] Misses and Accuracy
 - [x] Make events
 - [ ] Make Accuracy more milisecond based than using ratings
 - [x] Pixel Note Splashes (`impact 1` animations)
 - [x] Pixel Note Splashes (`impact 2` animations)
 - [ ] Seperate Voices File (`Voices.ext` => `Voices-dadName.ext / Voices-Opponent.ext`, `Voices-bfName.ext  / Voices-Player.ext`, `Voices-gf.ext / Voices-Spectator.ext`)
 - [x] Botplay
 - [x] Old BF icon but pixel for pixel stages
 - [x] Put song watermark ingame
 - [x] Make GF Changable via Song Metadata
 - [ ] Outdated Warning
 - [x] Make Stages into their own hx file
 - [ ] Character Editor becomes usable
 - [ ] Fix things with diff in Story Menu
 - [ ] Fix Scaling with Chars in Story Menu
 - [ ] RGB Pallete for Notes + Note Splashes
 - [ ] Sustain Note Covers (https://twitter.com/FNF_Developers/status/1774200908806525366)
 - [ ] Opponents have their own note colors
 - [x] Seperate Saves from Each Other (Like highscores are in its own .sol file in the appdata and settings has its own .sol)
 - [ ] Seperate Song Sections and Song Data from each other (Like in the songs `songname-metadata.json` it will have the player opponent stage gf n stuff in there and then theres the `songname-chart.json`.)
 - [ ] Character JSONs
 - [ ] Make Animation Priority (e.g. if one animation priority is 0 but the one trying to play next is 1 then it will play that one but if the next animation trying to play is 0 but the animation being played is 1 then it wont play at all. if one animation priority is 1 and the next one trying to play is 1 then it may rely on forced in the playAnim. idk yet tho)
 - [ ] Health Icon JSONs
 - [ ] Stage JSONs (When we get a modding api.)
 - [ ] Week 7 Cutscenes without a video.
 - [ ] Story Menu Softcoded (Week Data and the character positions go inside that data too)
 - [ ] Multisparrow support for characters.
 - [ ] Crash Handler
 - [ ] Caching System
 - [ ] Christmas UI for Week 5

## Small Changes
 - [x] Tutorial Voices are in its own `Voices.ogg` file
 - [x] When events done, make pickle in stress event based <!-- pickle? oh hell naw - crusher. oh yesssss pico but pickle -Til-->
 - [x] Ghost Tapping
 - [x] Strums Glow Dad
 - [x] Healthbar Colors (Done for now ig)
 - [x] Custom FPS (`FPS`, `MEMORY`, and `STATE`)
 - [ ] Make FPS more accurate (maybe memory too if possible) and add a border around the Counter
 - [x] Seperate Menu Character assets
 - [x] Seperate Main Menu assets
 - [x] Seperate Story Menu UI assets
 - [x] Change Window Title (e.g on Story Menu: `Friday Night Funkin'; Chillin' Engine - Story Menu`) <!-- It was TechNotDrip at the time of typing that -->
 - [x] Make Philly window lights white so i can just change colors throughout the code
 - [ ] BF doesn't ascend when he's opponent
 - [ ] Add Skip Cutscene feature
 - [x] Daddy Dearest extended Left Pose
 - [x] Seperate Death Sprites from Boyfriend's Spritesheet

# Chillin' Engine - Options Todo List <!-- These are just what options we r gunna add (assuming til wil aggree with me (crusher)) its not for the whole menu itself tho -->

## Controls
 - [ ] ok this is prettyt self explanitory just port the original controls to new one
 - [ ] Optional but Hey! button and when pressed makes bf go Hey! mid-game

## Audio (THIS WHOLE SECTION IS OPTIONAL BUT WOULD BE KINDA COOL)
 - [ ] Master Volume (Hitting - and + basically in game)
 - [ ] Sound Effects
 - [ ] Game Music (Music in PlayState)
 - [ ] Menu Music (Menus and Pause Music)
 - [ ] Cutscenes (Week 5, 6 & 7)

## Display
 - [x] Fullscreen
 - [ ] Game Resolution (Optional and might break things but would be cool)
 - [x] FPS
 - [x] FPS Counter
 - [x] Antialiasing
 - [x] Flashing Lights <!-- is all she ever wanted (yeah) | Beggin' on her knees to be popular | That's her dream, to be popular (hey) | Kill anyone to be popular (hm) | Sell her soul to be popular | Popular, just to be popular (uh-huh) | Everybody scream 'cause she popular (hey) | She mainstream 'cause she popular | Never be free 'cause she popular -->

## Gameplay
 - [ ] Note Colours (Make a seperate menu maybe + Optional)
 - [ ] Opponent Custom Colours
 - [x] Ghost Tapping
 - [x] Downscroll
 - [ ] Middlescroll
 - [x] Camera Zoom
 - [x] Note Splashes
 - [x] Cutscenes
 - [ ] Easter Eggs (Optional but said EE's are BF Old Icon, Gitaroo Pause and Old Game Over)
 - [ ] ok i dunnow hat to call this either but its the UI stuff witht ext but leaving this disabled keeps only Healthbar and Notes and whatnot


## Flixel (or we can put this under **Other** as well)
 - [x] Auto Pause
 - [x] System Cursor

## Other
 - [x] Discord (Self explanitory)
 - [ ] Safe Mode (Prevents mods from messing with your computer like shutting it down for example or writing files (Just need to figure out how to prevent it first))
 - [x] Dev Mode (Enables stuff like chart editor and animation debug and the Test song (maybe))


# Chillin' Engine - Chart Editor Todo List <!-- Stuff we NEED for the chart editor -->
 - [ ] Infinite Scrolling through Chart
 - [ ] Note Menu rework
 - [ ] Hitsounds
 - [ ] Play2Chart (play imaginary notes and convert them to a chart)
 - [ ] Note quantization.
 - [ ] Note selection
 - [ ] Playtest

# Chillin' Engine - Mod Support Todo List
 - [ ] Asset Merging / Replacing System
 - [ ] Custom Options
 - [ ] Global Scripts (scripts that run thru the whole game regardless of what state your in.)
 - [ ] Mods Menu
package options.substates.options;

import display.FPS;

import openfl.Lib;

import options.objects.Option;

class Other extends BaseSubState
{
    override function create()
    {
        #if discord_rpc
        var discordRPC:Option = new Option('Discord Rich Presence', 'Displays this game on your Discord Profile.', 'discordRPC', 'other', CHECKBOX);
        discordRPC.onChange = discordRPCChange;
        addOption(discordRPC);
        #end

        #if MOD_SUPPORT
        var safeMode:Option = new Option('Safe Mode', 'Prevents mods from doing harmful stuff to your computer.', 'safeMode', 'other', CHECKBOX);
        addOption(safeMode);
        #end

        var devMode:Option = new Option('Developer Mode', 'Let\'s you access developer tools like Charting Menu.', 'devMode', 'other', CHECKBOX);
        addOption(devMode);

        super.create();
    }

    #if discord_rpc
    function discordRPCChange()
    {
        if (ChillSettings.get('discordRPC', 'other'))
            DiscordClient.initialize();
        else
            DiscordClient.shutdown();
    }
    #end
}
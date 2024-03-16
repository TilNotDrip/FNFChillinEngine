//hxcpp include should be first
#include <hxcpp.h>
#include "discord.h"

struct DiscordState {
    discord::User currentUser;

    std::unique_ptr<discord::Core> core;
};

namespace linc
{
    namespace discord_rpc
    {
        DiscordState state{};
        discord::Activity activity{};
        discord::LobbyTransaction lobby{};

        void init(int64_t _clientID)
        {
            discord::Core* core{};
            auto result = discord::Core::Create(_clientID, DiscordCreateFlags_NoRequireDiscord, &core);
            state.core.reset(core);
            if (!state.core) {
                std::cout << "Failed to instantiate discord core! (err " << static_cast<int>(result)
                          << ")\n";
                std::exit(-1);
            }
        }

        void process()
        {
            
            DiscordProcess.state.core->RunCallbacks();
        }

        void update_presence(
            const char* _state, const char* _details,
            int64_t _startTimestamp, int64_t _endTimestamp,
            const char* _largeImageKey, const char* _largeImageText,
            const char* _smallImageKey, const char* _smallImageText,
            const char* _partyID, int _partySize, int _partyMax, const char* _partyPrivacy, const char* _activityType,
            const char* _matchSecret, const char* _joinSecret, const char* _spectateSecret,
            void (*_onJoin)(const char* joinSecret),
            void (*_onSpectate)(const char* spectateSecret),
            void (*_onRequest)(const char* username)
            )
        {
            activity.SetDetails(_details);
            activity.SetState(_state);

            activity.GetAssets().SetSmallImage(_smallImageKey);
            activity.GetAssets().SetSmallText(_smallImageText);
            activity.GetAssets().SetLargeImage(_largeImageKey);
            activity.GetAssets().SetLargeText(_largeImageText);

            activity.GetSecrets().SetJoin(_joinSecret);
            activity.GetSecrets().SetMatch(_matchSecret);
            activity.GetSecrets().SetSpectate(_spectateSecret);

            activity.GetParty().GetSize().SetCurrentSize(_partySize);
            activity.GetParty().GetSize().SetMaxSize(_partyMax);
            activity.GetParty().SetId(_partyID);
            switch (_partyPrivacy) {
                case "public":
                    activity.GetParty().SetPrivacy(discord::ActivityPartyPrivacy::Public);
                case "private":
                    activity.GetParty().SetPrivacy(discord::ActivityPartyPrivacy::Private);
            }

            

            switch (_activityType) {
                case "playing":
                    activity.SetType(discord::ActivityType::Playing);
                case "streaming":
                    activity.SetType(discord::ActivityType::Streaming);
                case "listening":
                    activity.SetType(discord::ActivityType::Listening);
                case "watching":
                    activity.SetType(discord::ActivityType::Watching);
            }


            activity.GetTimestamps().SetStart(_startTimestamp);
            activity.GetTimestamps().SetEnd(_endTimestamp);

            state.core->ActivityManager().UpdateActivity(activity, [](discord::Result result) {
                std::cout << ((result == discord::Result::Ok) ? "Succeeded" : "Failed")
                          << " updating activity!\n";
            });
        }

        void update_presence(
            const char* _state, const char* _details,
            int64_t _startTimestamp, int64_t _endTimestamp,
            const char* _largeImageKey, const char* _largeImageText,
            const char* _smallImageKey, const char* _smallImageText,
            const char* _partyID, int _partySize, int _partyMax, const char* _matchSecret, const char* _joinSecret, const char* _spectateSecret,
            int8_t _instance)
        {
            DiscordRichPresence discordPresence;
            memset(&discordPresence, 0, sizeof(discordPresence));
            discordPresence.state   = _state;
            discordPresence.details = _details;
            discordPresence.startTimestamp = _startTimestamp;
            discordPresence.endTimestamp   = _endTimestamp;
            discordPresence.largeImageKey  = _largeImageKey;
            discordPresence.largeImageText = _largeImageText;
            discordPresence.smallImageKey  = _smallImageKey;
            discordPresence.smallImageText = _smallImageText;
            discordPresence.partyId   = _partyID;
            discordPresence.partySize = _partySize;
            discordPresence.partyMax  = _partyMax;
            discordPresence.matchSecret    = _matchSecret;
            discordPresence.joinSecret     = _joinSecret;
            discordPresence.spectateSecret = _spectateSecret;
            discordPresence.instance = _instance;
            Discord_UpdatePresence(&discordPresence);
        }
    }
}

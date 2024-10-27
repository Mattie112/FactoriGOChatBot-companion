local baseFolder = "factorigo-chat-bot/"
local baseFile = "factorigo-chat-bot.log"

local function log_message(msg)
    msg = game.tick .. " " .. msg
    helpers.write_file(
        baseFolder .. baseFile,
        "[FactoriGOChatBot]: " .. serpent.line(msg, {comment = false}) .. "\n",
        true
    )
end

script.on_event(
    defines.events.on_research_finished,
    function(event)
        local research_name = event.research.name
        log_message("[RESEARCH_FINISHED:" .. research_name .. "]")
    end
)

script.on_event(
    defines.events.on_research_started,
    function(event)
        local research_name = event.research.name
        log_message("[RESEARCH_STARTED:" .. research_name .. "]")
    end
)

script.on_event(
    defines.events.on_rocket_launched,
    function(event)
        storage.rocketLaunched = storage.rocketLaunched or 0
        storage.rocketLaunched = storage.rocketLaunched + 1
        log_message("[ROCKET_LAUNCHED:" .. storage.rocketLaunched .. "]")
    end
)

local function getAndStoreDeathCount(player_name, cause)
    storage.playerDeathCount = storage.playerDeathCount or {}
    storage.playerDeathCount[player_name] = storage.playerDeathCount[player_name] or {}

    storage.playerDeathCount[player_name][cause] = storage.playerDeathCount[player_name][cause] or 0
    storage.playerDeathCount[player_name][cause] = storage.playerDeathCount[player_name][cause] + 1

    storage.playerDeathCount[player_name]["total"] = storage.playerDeathCount[player_name]["total"] or 0
    storage.playerDeathCount[player_name]["total"] = storage.playerDeathCount[player_name]["total"] + 1

    return storage.playerDeathCount[player_name][cause], storage.playerDeathCount[player_name]["total"]
end

script.on_event(
    defines.events.on_pre_player_died,
    function(event)
        local player_index = event.player_index
        local player_name = game.get_player(player_index).name
        local cause = event.cause
        local causeText = ""
        if event.cause then
            causeText = event.cause.name
        end

        if causeText == "character" then
            causeText = event.cause.player.name
        end

        local count, total = getAndStoreDeathCount(player_name, causeText)

        log_message("[PLAYER_DIED:" .. player_name .. ":" .. causeText .. ":" .. count .. ":" .. total .. "]")
    end
)

local function initStorage()
    storage.playerDeathCount = storage.playerDeathCount or {}
    storage.rocketLaunched = storage.rocketLaunched or 0
end

-- Run this on startup
script.on_init(initStorage)

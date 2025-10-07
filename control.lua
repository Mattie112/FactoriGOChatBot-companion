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

local function check_force(force)
    for name in string.gmatch(settings.global["fgcb-allowed-forces"].value, "([^,]+)") do
        if force.name:lower() == name:lower() then
            return true
        end
    end
    return false
end

script.on_event(
    defines.events.on_research_finished,
    function(event)
        if not check_force(event.research.force) then return end
        local research_name = event.research.name
        log_message("[RESEARCH_FINISHED:" .. research_name .. "]")
    end
)

script.on_event(
    defines.events.on_research_started,
    function(event)
        if not check_force(event.research.force) then return end
        local research_name = event.research.name
        log_message("[RESEARCH_STARTED:" .. research_name .. "]")
    end
)

script.on_event(
    defines.events.on_rocket_launched,
    function(event)
        if not check_force(event.rocket.force) then return end
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
        local player = game.get_player(event.player_index)
        if not check_force(player.force) then return end
        local cause = event.cause
        local causeText = ""
        if event.cause then
            causeText = event.cause.name
        end

        if causeText == "character" then
            causeText = event.cause.player.name
        end

        local count, total = getAndStoreDeathCount(player.name, causeText)

        log_message("[PLAYER_DIED:" .. player.name .. ":" .. causeText .. ":" .. count .. ":" .. total .. "]")
    end
)

local function initStorage()
    storage.playerDeathCount = storage.playerDeathCount or {}
    storage.rocketLaunched = storage.rocketLaunched or 0
end

-- Run this on startup
script.on_init(initStorage)


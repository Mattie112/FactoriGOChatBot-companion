local baseFolder = "factorigo-chat-bot/"
local baseFile = "factorigo-chat-bot.log"

local function log_message(msg)
    msg = game.tick .. " " .. msg
    game.write_file(
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
        global.rocketLaunched = global.rocketLaunched or 0
        global.rocketLaunched = global.rocketLaunched + 1
        log_message("[ROCKET_LAUNCHED:" .. global.rocketLaunched .. "]")
    end
)

local function getAndStoreDeathCount(player_name, cause)
    global.playerDeathCount = global.playerDeathCount or {}
    global.playerDeathCount[player_name] = global.playerDeathCount[player_name] or {}

    global.playerDeathCount[player_name][cause] = global.playerDeathCount[player_name][cause] or 0
    global.playerDeathCount[player_name][cause] = global.playerDeathCount[player_name][cause] + 1

    global.playerDeathCount[player_name]["total"] = global.playerDeathCount[player_name]["total"] or 0
    global.playerDeathCount[player_name]["total"] = global.playerDeathCount[player_name]["total"] + 1

    return global.playerDeathCount[player_name][cause], global.playerDeathCount[player_name]["total"]
end

script.on_event(
    defines.events.on_player_died,
    function(event)
        local player_index = event.player_index
        local player_name = game.get_player(player_index).name
        local cause = event.cause
        if event.cause then
            cause = event.cause.name
        else
            cause = ""
        end

        if cause == "character" then
            cause = event.cause.player.name
        end

        local count, total = getAndStoreDeathCount(player_name, cause)

        log_message("[PLAYER_DIED:" .. player_name .. ":" .. cause .. ":" .. count .. ":" .. total .. "]")
    end
)

local function initStorage()
    global.playerDeathCount = global.playerDeathCount or {}
    global.rocketLaunched = 0
end

-- Run this on startup
script.on_init(initStorage)

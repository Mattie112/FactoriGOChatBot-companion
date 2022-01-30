local baseFolder = "factorigo-chat-bot/";
local baseFile = "factorigo-chat-bot.log"

local function log_message(msg)
    msg = game.tick .. " " .. msg
    game.write_file(baseFolder .. baseFile, "[FactoriGOChatBot]: " .. serpent.line(msg, { comment = false }), true)
end

script.on_event(defines.events.on_research_finished, function(event)
    local research_name = event.research.name
    log_message("[RESEARCH_FINISHED:" .. research_name .. "]")
end)

script.on_event(defines.events.on_research_started, function(event)
    local research_name = event.research.name
    log_message("[RESEARCH_STARTED:" .. research_name .. "]")
end)

script.on_event(defines.events.on_rocket_launched, function(event)
    log_message("[ROCKET_LAUNCHED]")
end)

script.on_event(defines.events.on_player_died, function(event)
    local player_index = event.player_index
    local player_name = game.get_player(player_index).name
    log_message("[PLAYER_DIED:" .. player_name .. "]")
end)

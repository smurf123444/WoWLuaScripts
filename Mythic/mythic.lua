local constants = require("constants")
local endTimer = require("endTimer")

local function OnPlayerDeath(event, player)
    local penalty = 5000
    local existingPenalty = player:GetData("DeathPenalty") or 0
    player:SetData("DeathPenalty", existingPenalty + penalty)
    player:SendBroadcastMessage(string.format("5 seconds penalty added. Total penalty: %d seconds.", player:GetData("DeathPenalty")))
end

local function OnCreatureEnterCombat(event, creature, target)
    local range = 100
    local players = creature:GetPlayersInRange(range)
    local highestMythicLevel = 0
    for _, player in ipairs(players) do
        local playerMythicLevel = player:GetData("DEADMINES_MYTHIC_LEVEL")
        if playerMythicLevel > highestMythicLevel then
            highestMythicLevel = playerMythicLevel
        end
    end
    if not creature:GetData("OriginalMaxHealth") then
        creature:SetData("OriginalMaxHealth", creature:GetMaxHealth())
        creature:SetData("OriginalLevel", creature:GetLevel())
    end
    if not creature:GetData("MythicBuffed") or (highestMythicLevel > creature:GetData("MythicBuffedLevel")) then
        if constants.MYTHIC_TABLE[highestMythicLevel] then
            local originalHealth = creature:GetData("OriginalMaxHealth")
            local originalLevel = creature:GetData("OriginalLevel")
            creature:SetMaxHealth(originalHealth * constants.MYTHIC_TABLE[highestMythicLevel].healthMultiplier)
            creature:SetLevel(originalLevel + constants.MYTHIC_TABLE[highestMythicLevel].levelAddition)
            creature:SetData("MythicBuffed", true)
            creature:SetData("MythicBuffedLevel", highestMythicLevel)
            local newHealth = creature:GetMaxHealth()
            creature:SetHealth(newHealth)
            if constants.BUFFS[highestMythicLevel] then
                creature:CastSpell(creature, constants.BUFFS[highestMythicLevel], true)
            end
        end
    end
end

local function OnFinalBossDeath(event, creature, killer)
    endTimer.EndDungeonTimer(creature, killer)
end

function CheckArea(event, player, newArea)
    if constants.DUNGEON_MAP_ID == player:GetMapId() then
        local start_date = 0
        local query = CharDBQuery("SELECT week_start_date FROM mythic_weekly_progress WHERE player_id = " .. player:GetGUIDLow())
        if query then
            start_date = query:GetUInt32(0)
        else
            print("Error executing the query")
        end
        if start_date == 0 or start_date + 604800 < os.time(os.date("!*t")) then
            player:SendBroadcastMessage("New Week Started, Enjoy the dungeon!")
            CharDBExecute("UPDATE mythic_weekly_progress SET week_start_date = " .. os.time(os.date("!*t")) .. " WHERE player_id = " .. player:GetGUIDLow())
            constants.SetMythicLevelFromItem(player)
        else
            player:SendBroadcastMessage("Already Started for the Week... Come back next week for a reward.")
            player:SendBroadcastMessage("For Now, Enjoy the mythic level")
            constants.SetMythicLevelFromItem(player)
            return
        end
    else
        return
    end
end

RegisterPlayerEvent(6, OnPlayerDeath)
RegisterPlayerEvent(27, CheckArea)
RegisterCreatureEvent(639, 4, OnFinalBossDeath)
for _, creatureId in ipairs(constants.DEADMINES_NPC_LIST) do
    RegisterCreatureEvent(creatureId, 1, OnCreatureEnterCombat)
end
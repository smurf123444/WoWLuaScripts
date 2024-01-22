local constants = require("constants")
local endTimer = require("endTimer")

local function OnPlayerDeath(event, player)
    local penalty = 5000
    local existingPenalty = player:GetData("DeathPenalty") or 0
    player:SetData("DeathPenalty", existingPenalty + penalty)
    player:SendBroadcastMessage(string.format("5 seconds penalty added. Total penalty: %d seconds.",
        player:GetData("DeathPenalty")))
end

local function OnCreatureEnterCombat(event, creature, target)
    local range = 100
    local players = creature:GetPlayersInRange(range)
    local highestMythicLevel = 0
    for _, player in ipairs(players) do
        local playerMythicLevel = player:GetData("DEADMINES_MYTHIC_LEVEL")
        if playerMythicLevel and playerMythicLevel > highestMythicLevel then
            highestMythicLevel = playerMythicLevel
        elseif not playerMythicLevel then
            player:SendBroadcastMessage("MYTHIC LEVEL NOT SET")
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
    local start_date = 0
    local reward_date = 0
    local query = CharDBQuery("SELECT start_date, reward_date FROM mythic_weekly_progress WHERE player_id = " ..
    killer:GetGUIDLow())
    start_date = query:GetUInt32(0)
    reward_date = query:GetUInt32(1)
    if (start_date < reward_date + 604800) then
        killer:SendBroadcastMessage("Already Earned Reward for week..")
        return
    else
        endTimer.EndDungeonTimer(creature, killer)
        
    end
end

local function CheckArea(event, player, newArea)
    local DUNGEON_MAP_ID = constants.DUNGEON_MAP_ID
    if DUNGEON_MAP_ID == player:GetMapId() then
        local playerGUID = player:GetGUIDLow()
        local now = os.time(os.date("!*t"))
        CharDBExecute(
            "INSERT INTO mythic_weekly_progress (player_id, highest_level, reward_date, reward_id, start_date) " ..
            "VALUES (" .. playerGUID .. ", 0, 0, 0, "..now..") " ..
            "ON DUPLICATE KEY UPDATE player_id = " .. playerGUID
        )
        local query = CharDBQuery("SELECT reward_date, start_date FROM mythic_weekly_progress WHERE player_id = " .. playerGUID)
        local reward_date = query:GetUInt32(0)
        local start_date = query:GetUInt32(1)
        if not player:GetData("AREA_PROCESSED") and not player:GetData("MYTHIC_LEVEL_SET")  and (reward_date + 604800 < start_date) then
            player:SendBroadcastMessage("New Week Started, Enjoy the dungeon!")
            player:SetData("AREA_PROCESSED", true)
            constants.SetMythicLevelFromItem(player, start_date, reward_date)
            player:SetData("MYTHIC_LEVEL_SET", true)
        elseif player:GetData("AREA_PROCESSED")
        then
            player:SendBroadcastMessage("Area Processed")
            return
        end
    else
        player:SetData("AREA_PROCESSED", false)
    end
end

local function DroppedStoned(event, player, item)
    player:SetData("DEADMINES_MYTHIC_LEVEL", nil)
    player:SendBroadcastMessage("Your mythic level has been RESET to 0. You dropped the stone...")
end

local entries = constants.MYTHIC_KEYSTONE_ENTRIES

RegisterPlayerEvent(27, CheckArea)
RegisterPlayerEvent(6, OnPlayerDeath)
RegisterCreatureEvent(639, 4, OnFinalBossDeath)
for _, creatureId in ipairs(constants.DEADMINES_NPC_LIST) do
    RegisterCreatureEvent(creatureId, 1, OnCreatureEnterCombat)
end
for _, keystoneID in ipairs(entries) do
    RegisterItemEvent(keystoneID, 5, DroppedStoned)
end

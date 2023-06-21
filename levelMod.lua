local function runQueryOnLogin(event, player)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

    if resultSelect then
        local AttackLevel = resultSelect:GetInt32(1)
        local DefenceLevel = resultSelect:GetInt32(3)
        local StrengthLevel = resultSelect:GetInt32(5)
        local MagicLevel = resultSelect:GetInt32(7)
        local RangeLevel = resultSelect:GetInt32(9)
        local HitpointLevel = resultSelect:GetInt32(11)
        local PrayerLevel = resultSelect:GetInt32(13)

        local baseCombatLevel = math.max(AttackLevel + StrengthLevel, MagicLevel * 2, RangeLevel * 2)
        local combatLevel = math.floor((13 / 10) * baseCombatLevel + DefenceLevel + HitpointLevel + math.floor(PrayerLevel / 2))

        -- Perform insertion query
        player:SetLevel(combatLevel)

        -- Announce the level change to the player
        player:SendBroadcastMessage("Your combat level has been set to " .. combatLevel)
    else
        player:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end
end

RegisterPlayerEvent(6, runQueryOnLogin)

local function runQueryOnKill(event, creature, killer)



end

RegisterCreatureEvent(12345, 5, runQueryOnKill) -- Replace 12345 with the entry of the specific creature







--[[ local function runQueryOnLogin(event, player)
            -- Perform insertion query


    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries
    local characterName = '0' -- Replace 'GetString' with the appropriate function for your column type
    local RangeLevel = 0
    local RangeXP = 0
    if resultSelect then
        characterName = resultSelect:GetString(0) -- Replace 'GetString' with the appropriate function for your column type
        RangeLevel = resultSelect:GetInt32(1)
        RangeXP = resultSelect:GetInt32(1)
        -- Retrieve values for other columns using appropriate functions

        -- Process the retrieved data
        player:SendBroadcastMessage("Character: " .. characterName)

        player:SendAreaTriggerMessage("Character: " .. characterName)

        player:SendBroadcastMessage("Current Attack LeveL: " .. RangeLevel)

        player:SendAreaTriggerMessage("Current Attack Level': " .. RangeLevel)

        player:SendBroadcastMessage("Attack XP: " .. RangeXP + 30)

        player:SendAreaTriggerMessage("Attack XP': " .. RangeXP + 30)
   
        -- Fetch the next row
    else
        player:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end


    local newRangeLevel = RangeLevel + 1
    local queryUpdate = "UPDATE custom_levels SET RangeLevel = " .. newRangeLevel .. " WHERE characterName = 'yoyo'"
    CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries 

    local newRangeLevel = RangeLevel + 1
    local queryUpdate = "UPDATE custom_levels SET RangeXP = " .. newRangeLevel .. " WHERE characterName = 'yoyo'"
    CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries 




end

RegisterPlayerEvent(6, runQueryOnLogin)
 ]]
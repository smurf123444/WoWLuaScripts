local function runQueryOnKill(event, creature, killer)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

    if resultSelect then
        local RangeLevel = resultSelect:GetInt32(11)
        local RangeXP = resultSelect:GetInt32(12)


        killer:SendBroadcastMessage("Current Range Level: " .. RangeLevel)
        killer:SendAreaTriggerMessage("Current Range Level: " .. RangeLevel)
        killer:SendBroadcastMessage("Range XP: " .. RangeXP)

        -- Calculate XP gain based on creature difficulty
        local creatureDifficulty = creature:GetLevel() * 1.3 -- Adjust the difficulty factor as needed
        print("CREATURE DIFFICULTY: " .. creatureDifficulty)
        local xpGain = 4 + (creatureDifficulty * 2) -- Adjust the XP gain formula as needed
        
        -- Increase the Range XP by the calculated gain
        local newRangeXP = RangeXP + xpGain
        

        -- Update the Range XP in the database
        local queryUpdate = "UPDATE custom_levels SET RangeXP = " .. newRangeXP .. " WHERE characterName = 'yoyo'"
        CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

        -- Check if enough XP is reached to level up
        if newRangeXP >= (RangeLevel * 100) then -- Adjust the required XP threshold as needed
            local newRangeLevel = RangeLevel + 1 -- Increment the level by 1
            newRangeXP = newRangeXP - (RangeLevel * 100) -- Subtract the required XP from RangeXP

            -- Update the level and XP in the database
            local queryUpdateLevel = "UPDATE custom_levels SET RangeLevel = " .. newRangeLevel .. ", RangeXP = " .. newRangeXP .. " WHERE characterName = 'yoyo'"
            CharDBExecute(queryUpdateLevel) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

            killer:SendBroadcastMessage("Congratulations! You have leveled up!")
            killer:SendAreaTriggerMessage("Congratulations! You have leveled up!")
            killer:SendBroadcastMessage("New Range Level: " .. newRangeLevel)
            killer:SendAreaTriggerMessage("New Range Level: " .. newRangeLevel)
            killer:SendBroadcastMessage("Remaining Range XP: " .. newRangeXP)
            killer:SendAreaTriggerMessage("Remaining Range XP: " .. newRangeXP)
        end
    else
        killer:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end
end

RegisterCreatureEvent(19999, 4, runQueryOnKill) -- Replace 12345 with the entry of the specific creature

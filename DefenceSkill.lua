local function runQueryOnKill(event, creature, killer)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

    if resultSelect then
        local DefenceLevel = resultSelect:GetInt32(5)
        local DefenceXP = resultSelect:GetInt32(6)


        killer:SendBroadcastMessage("Current Defence Level: " .. DefenceLevel)
        killer:SendAreaTriggerMessage("Current Defence Level: " .. DefenceLevel)
        killer:SendBroadcastMessage("Defence XP: " .. DefenceXP)

        -- Calculate XP gain based on creature difficulty
        local creatureDifficulty = creature:GetLevel() * 1.3 -- Adjust the difficulty factor as needed
        print("CREATURE DIFFICULTY: " .. creatureDifficulty)
        local xpGain = 4 + (creatureDifficulty * 2) -- Adjust the XP gain formula as needed
        
        -- Increase the Defence XP by the calculated gain
        local newDefenceXP = DefenceXP + xpGain
        

        -- Update the Defence XP in the database
        local queryUpdate = "UPDATE custom_levels SET DefenceXP = " .. newDefenceXP .. " WHERE characterName = 'yoyo'"
        CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

        -- Check if enough XP is reached to level up
        if newDefenceXP >= (DefenceLevel * 100) then -- Adjust the required XP threshold as needed
            local newDefenceLevel = DefenceLevel + 1 -- Increment the level by 1
            newDefenceXP = newDefenceXP - (DefenceLevel * 100) -- Subtract the required XP from DefenceXP

            -- Update the level and XP in the database
            local queryUpdateLevel = "UPDATE custom_levels SET DefenceLevel = " .. newDefenceLevel .. ", DefenceXP = " .. newDefenceXP .. " WHERE characterName = 'yoyo'"
            CharDBExecute(queryUpdateLevel) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

            killer:SendBroadcastMessage("Congratulations! You have leveled up!")
            killer:SendAreaTriggerMessage("Congratulations! You have leveled up!")
            killer:SendBroadcastMessage("New Defence Level: " .. newDefenceLevel)
            killer:SendAreaTriggerMessage("New Defence Level: " .. newDefenceLevel)
            killer:SendBroadcastMessage("Remaining Defence XP: " .. newDefenceXP)
            killer:SendAreaTriggerMessage("Remaining Defence XP: " .. newDefenceXP)
        end
    else
        killer:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end
end

RegisterCreatureEvent(19999, 4, runQueryOnKill) -- Replace 12345 with the entry of the specific creature

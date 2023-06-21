local function runQueryOnKill(event, creature, killer)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

    if resultSelect then
        local StrengthLevel = resultSelect:GetInt32(7)
        local StrengthXP = resultSelect:GetInt32(8)


        killer:SendBroadcastMessage("Current Strength Level: " .. StrengthLevel)
        killer:SendAreaTriggerMessage("Current Strength Level: " .. StrengthLevel)
        killer:SendBroadcastMessage("Strength XP: " .. StrengthXP)

        -- Calculate XP gain based on creature difficulty
        local creatureDifficulty = creature:GetLevel() * 1.3 -- Adjust the difficulty factor as needed
        print("CREATURE DIFFICULTY: " .. creatureDifficulty)
        local xpGain = 4 + (creatureDifficulty * 2) -- Adjust the XP gain formula as needed
        
        -- Increase the Strength XP by the calculated gain
        local newStrengthXP = StrengthXP + xpGain
        

        -- Update the Strength XP in the database
        local queryUpdate = "UPDATE custom_levels SET StrengthXP = " .. newStrengthXP .. " WHERE characterName = 'yoyo'"
        CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

        -- Check if enough XP is reached to level up
        if newStrengthXP >= (StrengthLevel * 100) then -- Adjust the required XP threshold as needed
            local newStrengthLevel = StrengthLevel + 1 -- Increment the level by 1
            newStrengthXP = newStrengthXP - (StrengthLevel * 100) -- Subtract the required XP from StrengthXP

            -- Update the level and XP in the database
            local queryUpdateLevel = "UPDATE custom_levels SET StrengthLevel = " .. newStrengthLevel .. ", StrengthXP = " .. newStrengthXP .. " WHERE characterName = 'yoyo'"
            CharDBExecute(queryUpdateLevel) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

            killer:SendBroadcastMessage("Congratulations! You have leveled up!")
            killer:SendAreaTriggerMessage("Congratulations! You have leveled up!")
            killer:SendBroadcastMessage("New Strength Level: " .. newStrengthLevel)
            killer:SendAreaTriggerMessage("New Strength Level: " .. newStrengthLevel)
            killer:SendBroadcastMessage("Remaining Strength XP: " .. newStrengthXP)
            killer:SendAreaTriggerMessage("Remaining Strength XP: " .. newStrengthXP)
        end
    else
        killer:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end
end

RegisterCreatureEvent(19999, 4, runQueryOnKill) -- Replace 12345 with the entry of the specific creature

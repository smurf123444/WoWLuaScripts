local function runQueryOnKill(event, creature, killer)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

    if resultSelect then
        local HitpointLevel = resultSelect:GetInt32(13)
        local HitpointXP = resultSelect:GetInt32(14)


        killer:SendBroadcastMessage("Current Hitpoint Level: " .. HitpointLevel)
        killer:SendAreaTriggerMessage("Current Hitpoint Level: " .. HitpointLevel)
        killer:SendBroadcastMessage("Hitpoint XP: " .. HitpointXP)

        -- Calculate XP gain based on creature difficulty
        local creatureDifficulty = creature:GetLevel() * 1.3 -- Adjust the difficulty factor as needed
        print("CREATURE DIFFICULTY: " .. creatureDifficulty)
        local xpGain = 4 + (creatureDifficulty * 2) -- Adjust the XP gain formula as needed
        
        -- Increase the Hitpoint XP by the calculated gain
        local newHitpointXP = HitpointXP + xpGain
        

        -- Update the Hitpoint XP in the database
        local queryUpdate = "UPDATE custom_levels SET HitpointXP = " .. newHitpointXP .. " WHERE characterName = 'yoyo'"
        CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

        -- Check if enough XP is reached to level up
        if newHitpointXP >= (HitpointLevel * 100) then -- Adjust the required XP threshold as needed
            local newHitpointLevel = HitpointLevel + 1 -- Increment the level by 1
            newHitpointXP = newHitpointXP - (HitpointLevel * 100) -- Subtract the required XP from HitpointXP

            -- Update the level and XP in the database
            local queryUpdateLevel = "UPDATE custom_levels SET HitpointLevel = " .. newHitpointLevel .. ", HitpointXP = " .. newHitpointXP .. " WHERE characterName = 'yoyo'"
            CharDBExecute(queryUpdateLevel) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

            killer:SendBroadcastMessage("Congratulations! You have leveled up!")
            killer:SendAreaTriggerMessage("Congratulations! You have leveled up!")
            killer:SendBroadcastMessage("New Hitpoint Level: " .. newHitpointLevel)
            killer:SendAreaTriggerMessage("New Hitpoint Level: " .. newHitpointLevel)
            killer:SendBroadcastMessage("Remaining Hitpoint XP: " .. newHitpointXP)
            killer:SendAreaTriggerMessage("Remaining Hitpoint XP: " .. newHitpointXP)
        end
    else
        killer:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end
end

RegisterCreatureEvent(19999, 4, runQueryOnKill) -- Replace 12345 with the entry of the specific creature

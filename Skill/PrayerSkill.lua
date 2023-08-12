local function runQueryOnKill(event, creature, killer)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

    if resultSelect then
        local PrayerLevel = resultSelect:GetInt32(13)
        local PrayerXP = resultSelect:GetInt32(14)


        killer:SendBroadcastMessage("Current Prayer Level: " .. PrayerLevel)
        killer:SendAreaTriggerMessage("Current Prayer Level: " .. PrayerLevel)
        killer:SendBroadcastMessage("Prayer XP: " .. PrayerXP)

        -- Calculate XP gain based on creature difficulty
        local creatureDifficulty = creature:GetLevel() * 1.3 -- Adjust the difficulty factor as needed
        print("CREATURE DIFFICULTY: " .. creatureDifficulty)
        local xpGain = 4 + (creatureDifficulty * 2) -- Adjust the XP gain formula as needed
        
        -- Increase the Prayer XP by the calculated gain
        local newPrayerXP = PrayerXP + xpGain
        

        -- Update the Prayer XP in the database
        local queryUpdate = "UPDATE custom_levels SET PrayerXP = " .. newPrayerXP .. " WHERE characterName = 'yoyo'"
        CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

        -- Check if enough XP is reached to level up
        if newPrayerXP >= (PrayerLevel * 100) then -- Adjust the required XP threshold as needed
            local newPrayerLevel = PrayerLevel + 1 -- Increment the level by 1
            newPrayerXP = newPrayerXP - (PrayerLevel * 100) -- Subtract the required XP from PrayerXP

            -- Update the level and XP in the database
            local queryUpdateLevel = "UPDATE custom_levels SET PrayerLevel = " .. newPrayerLevel .. ", PrayerXP = " .. newPrayerXP .. " WHERE characterName = 'yoyo'"
            CharDBExecute(queryUpdateLevel) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

            killer:SendBroadcastMessage("Congratulations! You have leveled up!")
            killer:SendAreaTriggerMessage("Congratulations! You have leveled up!")
            killer:SendBroadcastMessage("New Prayer Level: " .. newPrayerLevel)
            killer:SendAreaTriggerMessage("New Prayer Level: " .. newPrayerLevel)
            killer:SendBroadcastMessage("Remaining Prayer XP: " .. newPrayerXP)
            killer:SendAreaTriggerMessage("Remaining Prayer XP: " .. newPrayerXP)
        end
    else
        killer:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end
end

RegisterCreatureEvent(19999, 4, runQueryOnKill) -- Replace 12345 with the entry of the specific creature

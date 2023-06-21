local function runQueryOnKill(event, creature, killer)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

    if resultSelect then
        local MagicLevel = resultSelect:GetInt32(9)
        local MagicXP = resultSelect:GetInt32(10)


        killer:SendBroadcastMessage("Current Magic Level: " .. MagicLevel)
        killer:SendAreaTriggerMessage("Current Magic Level: " .. MagicLevel)
        killer:SendBroadcastMessage("Magic XP: " .. MagicXP)

        -- Calculate XP gain based on creature difficulty
        local creatureDifficulty = creature:GetLevel() * 1.3 -- Adjust the difficulty factor as needed
        print("CREATURE DIFFICULTY: " .. creatureDifficulty)
        local xpGain = 4 + (creatureDifficulty * 2) -- Adjust the XP gain formula as needed
        
        -- Increase the Magic XP by the calculated gain
        local newMagicXP = MagicXP + xpGain
        

        -- Update the Magic XP in the database
        local queryUpdate = "UPDATE custom_levels SET MagicXP = " .. newMagicXP .. " WHERE characterName = 'yoyo'"
        CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

        -- Check if enough XP is reached to level up
        if newMagicXP >= (MagicLevel * 100) then -- Adjust the required XP threshold as needed
            local newMagicLevel = MagicLevel + 1 -- Increment the level by 1
            newMagicXP = newMagicXP - (MagicLevel * 100) -- Subtract the required XP from MagicXP

            -- Update the level and XP in the database
            local queryUpdateLevel = "UPDATE custom_levels SET MagicLevel = " .. newMagicLevel .. ", MagicXP = " .. newMagicXP .. " WHERE characterName = 'yoyo'"
            CharDBExecute(queryUpdateLevel) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

            killer:SendBroadcastMessage("Congratulations! You have leveled up!")
            killer:SendAreaTriggerMessage("Congratulations! You have leveled up!")
            killer:SendBroadcastMessage("New Magic Level: " .. newMagicLevel)
            killer:SendAreaTriggerMessage("New Magic Level: " .. newMagicLevel)
            killer:SendBroadcastMessage("Remaining Magic XP: " .. newMagicXP)
            killer:SendAreaTriggerMessage("Remaining Magic XP: " .. newMagicXP)
        end
    else
        killer:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end
end

RegisterCreatureEvent(19999, 4, runQueryOnKill) -- Replace 12345 with the entry of the specific creature

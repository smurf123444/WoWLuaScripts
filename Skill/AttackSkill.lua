local function runQueryOnKill(event, creature, killer)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

    if resultSelect then
        local AttackLevel = resultSelect:GetInt32(3)
        local AttackXp = resultSelect:GetInt32(4)


        killer:SendBroadcastMessage("Current Attack Level: " .. AttackLevel)
        killer:SendAreaTriggerMessage("Current Attack Level: " .. AttackLevel)
        killer:SendBroadcastMessage("Attack XP: " .. AttackXp)

        -- Calculate XP gain based on creature difficulty
        local creatureDifficulty = creature:GetLevel() * 1.3 -- Adjust the difficulty factor as needed
        print("CREATURE DIFFICULTY: " .. creatureDifficulty)
        local xpGain = 4 + (creatureDifficulty * 2) -- Adjust the XP gain formula as needed
        
        -- Increase the Attack XP by the calculated gain
        local newAttackXp = AttackXp + xpGain
        

        -- Update the Attack XP in the database
        local queryUpdate = "UPDATE custom_levels SET AttackXp = " .. newAttackXp .. " WHERE characterName = 'yoyo'"
        CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

        -- Check if enough XP is reached to level up
        if newAttackXp >= (AttackLevel * 100) then -- Adjust the required XP threshold as needed
            local newAttackLevel = AttackLevel + 1 -- Increment the level by 1
            newAttackXp = newAttackXp - (AttackLevel * 100) -- Subtract the required XP from AttackXp

            -- Update the level and XP in the database
            local queryUpdateLevel = "UPDATE custom_levels SET AttackLevel = " .. newAttackLevel .. ", AttackXp = " .. newAttackXp .. " WHERE characterName = 'yoyo'"
            CharDBExecute(queryUpdateLevel) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

            killer:SendBroadcastMessage("Congratulations! You have leveled up!")
            killer:SendAreaTriggerMessage("Congratulations! You have leveled up!")
            killer:SendBroadcastMessage("New Attack Level: " .. newAttackLevel)
            killer:SendAreaTriggerMessage("New Attack Level: " .. newAttackLevel)
            killer:SendBroadcastMessage("Remaining Attack XP: " .. newAttackXp)
            killer:SendAreaTriggerMessage("Remaining Attack XP: " .. newAttackXp)
        end
    else
        killer:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end
end

RegisterCreatureEvent(19999, 4, runQueryOnKill) -- Replace 12345 with the entry of the specific creature

local function runQueryOnLogin(event, go, player)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries
    local characterName = '0' -- Replace 'GetString' with the appropriate function for your column type
    local woodcuttingLevel = 0
    local woodcuttingXP = 0

    if resultSelect then
        characterName = resultSelect:GetString(0) -- Replace 'GetString' with the appropriate function for your column type
        woodcuttingLevel = resultSelect:GetInt32(1)
        woodcuttingXP = resultSelect:GetInt32(2) -- Retrieve the value from woodcuttingXP

        -- Process the retrieved data
        player:SendBroadcastMessage("Character: " .. characterName)
        player:SendAreaTriggerMessage("Character: " .. characterName)
        player:SendBroadcastMessage("Current Woodcutting Level: " .. woodcuttingLevel)
        player:SendAreaTriggerMessage("Current Woodcutting Level: " .. woodcuttingLevel)
        player:SendBroadcastMessage("Woodcutting XP: " .. woodcuttingXP)
        print(woodcuttingXP)
        local XpGainQuery = "UPDATE custom_levels SET WoodcuttingXP = " .. woodcuttingXP + 30 .. " WHERE characterName = 'yoyo'"
        CharDBExecute(XpGainQuery) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries
        -- Check if enough XP is reached to level up
        if woodcuttingXP >= 100 then -- Adjust the required XP threshold as needed
            local newwoodcuttingLevel = woodcuttingLevel + 1 -- Increment the level by 1
            local newwoodcuttingXP = woodcuttingXP - 100 -- Subtract the required XP from woodcuttingXP

            -- Update the level and XP in the database
            local queryUpdate = "UPDATE custom_levels SET WoodcuttingLevel = " .. newwoodcuttingLevel .. ", WoodcuttingXP = " .. newwoodcuttingXP .. " WHERE characterName = 'yoyo'"
            CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

            player:SendBroadcastMessage("Congratulations! You have leveled up!")
            player:SendAreaTriggerMessage("Congratulations! You have leveled up!")
            player:SendBroadcastMessage("New Woodcutting Level: " .. newwoodcuttingLevel)
            player:SendAreaTriggerMessage("New Woodcutting Level: " .. newwoodcuttingLevel)
            player:SendBroadcastMessage("Remaining Woodcutting XP: " .. newwoodcuttingXP)
            player:SendAreaTriggerMessage("Remaining Woodcutting XP: " .. newwoodcuttingXP)
        end
    else
        player:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end
end

RegisterGameObjectEvent(510002, 14, runQueryOnLogin) -- Replace 123 with the entry of your specific game object






--[[ local function runQueryOnLogin(event, player)
            -- Perform insertion query


    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries
    local characterName = '0' -- Replace 'GetString' with the appropriate function for your column type
    local woodcuttingLevel = 0
    local woodcuttingXP = 0
    if resultSelect then
        characterName = resultSelect:GetString(0) -- Replace 'GetString' with the appropriate function for your column type
        woodcuttingLevel = resultSelect:GetInt32(1)
        woodcuttingXP = resultSelect:GetInt32(1)
        -- Retrieve values for other columns using appropriate functions

        -- Process the retrieved data
        player:SendBroadcastMessage("Character: " .. characterName)

        player:SendAreaTriggerMessage("Character: " .. characterName)

        player:SendBroadcastMessage("Current Woodcutting LeveL: " .. woodcuttingLevel)

        player:SendAreaTriggerMessage("Current Woodcutting Level': " .. woodcuttingLevel)

        player:SendBroadcastMessage("Woodcutting XP: " .. woodcuttingXP + 30)

        player:SendAreaTriggerMessage("Woodcutting XP': " .. woodcuttingXP + 30)
   
        -- Fetch the next row
    else
        player:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end


    local newwoodcuttingLevel = woodcuttingLevel + 1
    local queryUpdate = "UPDATE custom_levels SET WoodcuttingLevel = " .. newwoodcuttingLevel .. " WHERE characterName = 'yoyo'"
    CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries 

    local newwoodcuttingLevel = woodcuttingLevel + 1
    local queryUpdate = "UPDATE custom_levels SET WoodcuttingXP = " .. newwoodcuttingLevel .. " WHERE characterName = 'yoyo'"
    CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries 




end

RegisterPlayerEvent(6, runQueryOnLogin)
 ]]
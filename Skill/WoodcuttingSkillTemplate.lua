local function calculateWoodcuttingXP(level)
    -- This function calculates the woodcutting XP required for a given level
    local xpTable = {0, 83, 174, 276, 388, 512, 650, 801, 969, 1154, 1358, 1584, 1833, 2107, 2411,
        2746, 3115, 3523, 3973, 4470, 5018, 5624, 6291, 7028, 7842, 8740, 9730, 10824, 12031,
        13363, 14833, 16456, 18247, 20224, 22406, 24815, 27473, 30408, 33648, 37224, 41171,
        45529, 50339, 55649, 61512, 67983, 75127, 83014, 91721, 101333, 111945, 123660, 136594,
        150872, 166636, 184040, 203254, 224466, 247886, 273742, 302288, 333804, 368599, 407015,
        449428, 496254, 547953, 605032, 668051, 737627, 814445, 899257, 992895, 1096278, 1210421,
        1336443, 1475581, 1629200, 1798808, 1986068, 2192818, 2421087, 2673114, 2951373, 3258594,
        3597792, 3972294, 4385776, 4842295, 5346332, 5902831, 6517253, 7195629, 7944614, 8771558,
        9684577, 10692629, 11805606, 13034431}

    if level < 1 or level > #xpTable then
        return 0
    end

    return xpTable[level]
end

local function chopLog(event, go, player)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local resultSelect = CharDBQuery(querySelect) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries
    local characterName = '0' -- Replace 'GetString' with the appropriate function for your column type
    local woodcuttingLevel = 0
    local woodcuttingXP = 0

    if resultSelect then
        characterName = resultSelect:GetString(0) -- Replace 'GetString' with the appropriate function for your column type
        woodcuttingLevel = resultSelect:GetInt32(1)
        woodcuttingXP = resultSelect:GetInt32(2)

        -- Process the retrieved data
        player:SendBroadcastMessage("Character: " .. characterName)
        player:SendAreaTriggerMessage("Character: " .. characterName)
        player:SendBroadcastMessage("Current Woodcutting Level: " .. woodcuttingLevel)
        player:SendAreaTriggerMessage("Current Woodcutting Level: " .. woodcuttingLevel)
        player:SendBroadcastMessage("Woodcutting XP: " .. woodcuttingXP)
 

        local xpGain = 30 -- XP gained per action (adjust as needed)
        local newWoodcuttingXP = woodcuttingXP + xpGain
        local requiredXP = calculateWoodcuttingXP(woodcuttingLevel)
        print("REQUIRED : " ..requiredXP)
        print("HAVE :" ..newWoodcuttingXP)
        -- Check if enough XP is reached to level up
        if newWoodcuttingXP >= requiredXP then
            woodcuttingLevel = woodcuttingLevel + 1
            newWoodcuttingXP = newWoodcuttingXP - requiredXP

            -- Update the level and XP in the database
            local queryUpdate = "UPDATE custom_levels SET WoodcuttingLevel = " .. woodcuttingLevel ..
                                ", WoodcuttingXP = " .. newWoodcuttingXP ..
                                " WHERE characterName = 'yoyo'"
            CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

            player:SendBroadcastMessage("Congratulations! You have leveled up!")
            player:SendAreaTriggerMessage("Congratulations! You have leveled up!")
            player:SendBroadcastMessage("New Woodcutting Level: " .. woodcuttingLevel)
            player:SendAreaTriggerMessage("New Woodcutting Level: " .. woodcuttingLevel)
            player:SendBroadcastMessage("Remaining Woodcutting XP: " .. newWoodcuttingXP)
            player:SendAreaTriggerMessage("Remaining Woodcutting XP: " .. newWoodcuttingXP)

                    
            local function castSpellLoop(player, spellID, times)
                for i = 1, times do
                    player:CastSpell(player, spellID, true)
                    local start = os.clock()
                    while os.clock() - start < 1 do
                        -- Wait for 1 second
                    end
                end
            end
            
            -- Call the function to run the spell casting loop
            local spellID = 64885 -- Replace with the appropriate spell ID
            local loopCount = 20
            castSpellLoop(player, spellID, loopCount)
            
            

            -- Play level up sound
            go:PlayDirectSound(1523)
        else
            local test = calculateWoodcuttingXP(woodcuttingLevel)
            -- Update only the XP in the database
            local queryUpdate = "UPDATE custom_levels SET WoodcuttingXP = " .. newWoodcuttingXP ..
                                " WHERE characterName = 'yoyo'"
            CharDBExecute(queryUpdate) -- Replace 'CharDBQuery' with 'WorldDBQuery' for world database queries

            player:SendBroadcastMessage("Woodcutting XP Gained: " .. xpGain)
            player:SendAreaTriggerMessage("Woodcutting XP Gained: " .. xpGain)
            player:SendBroadcastMessage("Current Woodcutting Level: " .. woodcuttingLevel)
            player:SendAreaTriggerMessage("Current Woodcutting Level: " .. woodcuttingLevel)
            player:SendBroadcastMessage("Remaining Woodcutting XP: " .. test - newWoodcuttingXP)
            player:SendAreaTriggerMessage("Remaining Woodcutting XP: " .. test - newWoodcuttingXP)
        end
    else
        player:SendBroadcastMessage("Select query returned no results or an error occurred.")
    end
end

RegisterGameObjectEvent(510002, 14, chopLog) -- Replace 123 with the entry of your specific game object

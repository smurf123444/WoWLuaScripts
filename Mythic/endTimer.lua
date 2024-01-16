local endTimer = {}
local constants = require("constants")

-- Function to handle the end of a dungeon timer and reward players accordingly
function endTimer.EndDungeonTimer(creature, killer)

    -- Define the range for finding players in proximity to the creature
    local range = 100

    -- Get the list of players within the specified range
    local players = creature:GetPlayersInRange(range)


    -- Check if required constants and data are available, otherwise print an error and exit
    if not constants.TIME_TIERS or not constants.CLASS_TIER_REWARDS or not constants.MYTHIC_KEYSTONE_ENTRIES or not killer:GetData("DEADMINES_MYTHIC_LEVEL") then
        print("FAIL")
        return
    end

    -- Iterate through the list of players
    for _, player in ipairs(players) do

        -- Use protected call to handle errors gracefully
        local success, message = pcall(function()

            -- Retrieve player's mythic level and weekly progress from the database
            local playerMythicLevel = player:GetData("DEADMINES_MYTHIC_LEVEL")
            local query = CharDBQuery("SELECT highest_level, week_start_date FROM mythic_weekly_progress WHERE player_id = " .. player:GetGUIDLow())
            
            -- Check if the query was successful, otherwise print an error and exit
            if not query then
                print("Error executing the query")
                return
            end

            -- Extract highest level and start time from the database query
            local highest_level = query:GetUInt32(0)
            local start_time = query:GetUInt32(1)

            -- Check if the player has already completed this dungeon run, if so, inform the player and exit
            if playerMythicLevel <= highest_level then
                player:SendBroadcastMessage("You have already completed this dungeon run and received your rewards for this level. Error.")
                return
            end

            -- Calculate the elapsed time and determine the reward tier
            local deathPenalty = player:GetData("DeathPenalty") or 0
            local elapsedTime = (os.time(os.date("!*t")) - start_time) + deathPenalty
            local tier = nil

            -- Iterate through time tiers to find the appropriate tier based on elapsed time
            for tierName, timeLimit in pairs(constants.TIME_TIERS) do
                if elapsedTime <= timeLimit then
                    tier = tierName
                    break
                end
            end

            -- Get the reward for the player's class and tier, calculate the new key level, and handle rewards or penalties
            local award = constants.GetRewardForClass(player:GetClass(), tier, playerMythicLevel)
            local newKeyLevel = playerMythicLevel + (constants.UPGRADE_AMOUNTS[tier] or 0)
            newKeyLevel = math.min(30, newKeyLevel)

            if award then

                -- Give the player the reward and update the database with the new progress
                player:AddItem(award, 1)
                CharDBExecute(
                    "INSERT INTO mythic_weekly_progress (player_id, highest_level, week_start_date, reward_id) VALUES ("
                     .. player:GetGUIDLow() .. ", " ..playerMythicLevel .. ", CURDATE(), " ..award ..") ON DUPLICATE KEY UPDATE reward_id = " ..
                    award .. ", highest_level = GREATEST(highest_level, " .. playerMythicLevel .. ")")
                player:SendBroadcastMessage("Congratulations! You've been awarded for your performance. Check your inventory!")
            else
                
                -- Inform the player that they didn't finish in time for a reward and apply a penalty
                player:SendBroadcastMessage("You didn't finish in time for a reward. Better luck next time!")
                playerMythicLevel = math.max(1, playerMythicLevel - 1) -- Decrease and ensure it doesn't go below 1
                player:SetData("DEADMINES_MYTHIC_LEVEL", playerMythicLevel)
                player:SendBroadcastMessage("Your Mythic Level has been decreased to " .. playerMythicLevel .. ".")
            end

            -- Upgrade the mythic keystone if the new level is higher than the current level
            if newKeyLevel > playerMythicLevel then
                constants.UpgradeMythicKeystone(player, newKeyLevel)
            end
        end)

        -- Handle errors during player processing and print relevant information
        if not success and message then
            print("Error processing EndDungeonTimer for player " .. player:GetName() .. ": " .. message)
        end
    end
end


return endTimer
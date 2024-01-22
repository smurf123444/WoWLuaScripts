local endTimer = {}
local constants = require("constants")

function endTimer.EndDungeonTimer(creature, killer)

    local range = 100
    local now = os.time(os.date("!*t"))
    local players = creature:GetPlayersInRange(range)

    if not constants.TIME_TIERS or not constants.CLASS_TIER_REWARDS or not constants.MYTHIC_KEYSTONE_ENTRIES or not killer:GetData("DEADMINES_MYTHIC_LEVEL") then
        print("FAIL")
        return
    end

    for _, player in ipairs(players) do

        local success, message = pcall(function()
            player:SetData("MYTHIC_LEVEL_SET", false)
            local playerMythicLevel = player:GetData("DEADMINES_MYTHIC_LEVEL")
            local query = CharDBQuery("SELECT highest_level, start_date FROM mythic_weekly_progress WHERE player_id = " .. player:GetGUIDLow())
            
            if not query then
                print("Error executing the query")
                return
            end

            local highest_level = query:GetUInt32(0)
            local start_time = query:GetUInt32(1)

            if playerMythicLevel <= highest_level then
                player:SendBroadcastMessage("You have already completed this dungeon run and received your rewards for this level. Error.")
                return
            end

            local deathPenalty = player:GetData("DeathPenalty") or 0
            local elapsedTime = (now - start_time) + deathPenalty
            local tier = nil

            for tierName, timeLimit in pairs(constants.TIME_TIERS) do
                if elapsedTime >= timeLimit then
                    tier = tierName
                    break
                end
            end

            local award = constants.GetRewardForClass(player:GetClass(), tier, playerMythicLevel)
            local newKeyLevel = playerMythicLevel + (constants.UPGRADE_AMOUNTS[tier] or 0)
            newKeyLevel = math.min(30, newKeyLevel)

            if award then
                player:AddItem(award, 1)
                CharDBExecute(
                    "INSERT INTO mythic_weekly_progress (player_id, highest_level, reward_date, reward_id, start_date) " ..
                    "VALUES (" .. player:GetGUIDLow() .. ", " .. newKeyLevel .. ", " .. now .. ", " .. award .. ", " .. start_time .. ") " ..
                    "ON DUPLICATE KEY UPDATE " ..
                    "player_id = " .. player:GetGUIDLow() .. ", " ..
                    "highest_level = " .. newKeyLevel .. ", " ..
                    "reward_date = " .. now .. ", " ..
                    "reward_id = " .. award .. ", " ..
                    "start_date = " .. start_time
                )
                player:SendBroadcastMessage("Congratulations! You've been awarded for your performance. Check your inventory!")
                player:SendBroadcastMessage("Old Mythic Level: " .. playerMythicLevel)
                player:SendBroadcastMessage("New Mythic Level: " .. newKeyLevel)
                player:SendBroadcastMessage("Tier Achieved: " .. tier)
                player:SendBroadcastMessage("Time Elapsed: " .. elapsedTime)
                player:SendBroadcastMessage("Death Penalty: +" .. deathPenalty)
            else
                CharDBExecute(
                    "INSERT INTO mythic_weekly_progress (player_id, highest_level, reward_date) VALUES (" ..
                    player:GetGUIDLow() .. ", " .. playerMythicLevel - 1 .. ", " .. now .. ") " ..
                    "ON DUPLICATE KEY UPDATE " ..
                    "player_id = " .. player:GetGUIDLow() .. ", " ..
                    "highest_level = " .. newKeyLevel - 1 .. ", " 
                )          
                player:SendBroadcastMessage("You didn't finish in time for a reward. Better luck next time!")
                playerMythicLevel = math.max(1, playerMythicLevel - 1)
                player:SetData("DEADMINES_MYTHIC_LEVEL", playerMythicLevel - 1)
                player:SendBroadcastMessage("Your Mythic Level has been decreased to " .. playerMythicLevel .. ".")
            end

            if newKeyLevel > playerMythicLevel then
                constants.UpgradeMythicKeystone(player, newKeyLevel)
            elseif newKeyLevel < playerMythicLevel then
                constants.UpgradeMythicKeystone(player, newKeyLevel - 1)
            end
        end)

        if not success and message then
            print("Error processing EndDungeonTimer for player " .. player:GetName() .. ": " .. message)
        end
    end
end


return endTimer
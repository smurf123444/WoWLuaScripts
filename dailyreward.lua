local function GetCurrentServerTime()
    local currentTime = GetCurrTime()
    print("Current server time: " .. currentTime) -- Debug output for current server time
    return currentTime
end

local function GetPlayerGUID(player)
    local playerGUID = player:GetGUIDLow()
    print("Player GUID: " .. playerGUID) -- Debug output for player's GUID
    return playerGUID
end

local function GetPlayerLoginTime(player)
    local guid = GetPlayerGUID(player)
    print("Fetching login time for GUID: " .. guid) -- Debug output for fetching login time

    local query = CharDBQuery("SELECT last_login_time FROM player_login_rewards WHERE player_guid = '" .. guid .. "';")

    if query then
        local lastLoginTime = query:GetUInt32(0)
        print("Last login time found: " .. lastLoginTime) -- Debug output for last login time found
        return lastLoginTime
    else
        print("No previous login time found!") -- Debug output if no previous login time is found
        return 0
    end
end

local function UpdatePlayerLoginTime(player)
    local guid = GetPlayerGUID(player)
    local currentTime = GetCurrentServerTime()
    print("Updating login time for GUID " .. guid .. " to: " .. currentTime) -- Debug output for updating login time

    local query = CharDBQuery("SELECT * FROM player_login_rewards WHERE player_guid = '" .. guid .. "';")
    
    if query then
        CharDBExecute("UPDATE player_login_rewards SET last_login_time = '" .. currentTime .. "' WHERE player_guid = '" .. guid .. "';")
    else
        CharDBExecute("INSERT INTO player_login_rewards (player_guid, last_login_time) VALUES ('" .. guid .. "', '" .. currentTime .. "');")
    end
end


local function GiveDailyReward(player)
        -- Assuming you have a function to give currency to the player, such as AddItem
        local itemID = 40112 -- Replace this with the actual currency ID
        local itemAmount = 1 -- Replace this with the amount of currency to give
    
        -- Add your reward logic here
        player:AddItem(itemID, itemAmount) -- Add currency to the player's inventory
    
    -- Debug output for giving daily reward
    print("Giving daily reward to player: " .. player:GetName())
    player:SendBroadcastMessage("You've received your daily reward of " .. itemAmount .. " of the daily reward item!")
end

local function CheckDailyLoginReward(event, player)
    local currentTime = GetCurrentServerTime()
    local lastLoginTime = GetPlayerLoginTime(player)
    local oneDayInSeconds = 86400 -- 24 hours * 60 minutes * 60 seconds

    print("Current time: " .. currentTime)
    print("Last login time: " .. lastLoginTime)

    if lastLoginTime == 0 or currentTime - lastLoginTime >= oneDayInSeconds then
        print("Daily login reward eligible!") -- Debug output for eligibility
        
        if lastLoginTime == 0 then
            -- Give the reward for the first login
            GiveDailyReward(player)
            UpdatePlayerLoginTime(player)
        else
            GiveDailyReward(player)
            UpdatePlayerLoginTime(player)
        end
    else
        print("Daily login reward not yet eligible!") -- Debug output for ineligibility
    end
end

RegisterPlayerEvent(3, CheckDailyLoginReward) -- Register the event on player login (EVENT_ON_LOGIN)

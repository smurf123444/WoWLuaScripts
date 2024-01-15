local MAX_BAG = 22
local MAX_SLOT = 255

local BUFFS = {
    [2] = 20217,
}

local DUNGEON_MAP_ID = 36

local DEADMINES_NPC_LIST = {
    639,
    598,
    634,
    1729
}

local TIME_TIERS = {
    PLATINUM = 12000, -- Time in seconds for PLATINUM tier
    GOLD = 18000,     -- Time in seconds for GOLD tier
    SILVER = 24000,   -- Time in seconds for SILVER tier
    BRONZE = 30000   -- Time in seconds for BRONZE tier
}

local CLASS_TIER_REWARDS = require("rewardTable")


local function GetRewardForClass(playerClass, tier, mythicLevel)
    print("GetRewardForClass")
    if not playerClass or not tier or not mythicLevel then
        return nil
    end

    local classRewards = CLASS_TIER_REWARDS[playerClass]
    if not classRewards then
        return nil
    end

    local tierRewards = classRewards[tier]
    if not tierRewards or not tierRewards[mythicLevel] then
        return nil
    end
    return tierRewards[mythicLevel]
end


local function GetPlayerClass(player)
    return player:GetClass()
end


local function CreateKeystoneEntries()
    local entries = {}
    for i = 0, 29 do
        table.insert(entries, 90000 + i)
    end
    return entries
end


local MYTHIC_KEYSTONE_ENTRIES = CreateKeystoneEntries()


local function CreateMythicTable()
    print("CreateMythicTable")
    local tbl = { [0] = { healthMultiplier = 1, levelAddition = 0, damageMultiplier = 1 } }
    for i = 1, 30 do
        tbl[i] = {
            healthMultiplier = 1 + i * 0.2,
            levelAddition = i * 2,
            powerMultiplier = 1 + i * 0.2
        }
    end
    return tbl
end

local function OnPlayerDeath(event, player)
    print("OnPlayerDeath")
    local penalty = 5000
    local existingPenalty = player:GetData("DeathPenalty") or 0

    player:SetData("DeathPenalty", existingPenalty + penalty)
    player:SendBroadcastMessage(string.format("5 seconds penalty added. Total penalty: %d seconds.",
        player:GetData("DeathPenalty")))
end

local MYTHIC_TABLE = CreateMythicTable()

local function SetMythicLevelFromItem(player)
    print("SetMythicLevelFromItem")
    for i = 1, 30 do
        local mythic_keystone_count = player:GetItemCount(90000 + i)
        if mythic_keystone_count > 0 then
            player:SetData("DEADMINES_MYTHIC_LEVEL", i)
            player:SendBroadcastMessage("Your mythic level has been set to Mythic+" .. i .. ".")
            return
        end
    end
    player:SendBroadcastMessage("Mythic Keystone not found in your bags!")
end

local function OnCreatureEnterCombat(event, creature, target)
    print("OnCreatureEnterCombat")
    local range = 100
    local players = creature:GetPlayersInRange(range)
    local highestMythicLevel = 0

    for _, player in ipairs(players) do
        local playerMythicLevel = player:GetData("DEADMINES_MYTHIC_LEVEL")
        print("HIGHEST MYTHIC LEVEL: ", playerMythicLevel)
        if playerMythicLevel > highestMythicLevel then
            highestMythicLevel = playerMythicLevel
        end
    end

    if not creature:GetData("OriginalMaxHealth") then
        creature:SetData("OriginalMaxHealth", creature:GetMaxHealth())
        creature:SetData("OriginalLevel", creature:GetLevel())
    end

    if not creature:GetData("MythicBuffed") or (highestMythicLevel > creature:GetData("MythicBuffedLevel")) then
        if MYTHIC_TABLE[highestMythicLevel] then
            local originalHealth = creature:GetData("OriginalMaxHealth")
            local originalLevel = creature:GetData("OriginalLevel")

            creature:SetMaxHealth(originalHealth * MYTHIC_TABLE[highestMythicLevel].healthMultiplier)
            creature:SetLevel(originalLevel + MYTHIC_TABLE[highestMythicLevel].levelAddition)
            creature:SetData("MythicBuffed", true)
            creature:SetData("MythicBuffedLevel", highestMythicLevel)

            local newHealth = creature:GetMaxHealth()
            creature:SetHealth(newHealth)

            if BUFFS[highestMythicLevel] then
                creature:CastSpell(creature, BUFFS[highestMythicLevel], true)
            end
        end
    end
end

local function StartDungeonTimer(player)
    print("StartDungeonTimer")
    local existingStartTime = player:GetData("DungeonStartTime")
    if existingStartTime then
        player:SendBroadcastMessage("Dungeon timer is already running!")
        return
    end

    CharDBExecute("UPDATE mythic_weekly_progress SET timer = " ..
        os.time(os.date("!*t")) .. " WHERE player_id = " .. player:GetGUIDLow())

    player:SetData("DungeonStartTime", os.time(os.date("!*t")))

    player:SendBroadcastMessage("The timer for the dungeon has started!")
end

local function SetReceivedWeeklyReward(player, rewardID, mythicLevel)
    print("SetReceivedWeeklyReward")
    local now = os.time(os.date("!*t"))
    CharDBExecute(
        "INSERT INTO mythic_weekly_progress (player_id, highest_level, week_start_date, reward_date, reward_id) VALUES (" .. player:GetGUIDLow() ..", " ..mythicLevel ..", '" ..now .."', CURDATE(), " ..rewardID ..") ON DUPLICATE KEY UPDATE reward_id = " ..rewardID ..", reward_date = " .. os.time(os.date("!*t")) .. ", highest_level = GREATEST(highest_level, " .. mythicLevel .. ")")
end

local function UpdatePlayerMythicLevelInSQL(player, newKeyLevel)
    print("UpdatePlayerMythicLevelInSQL")
    CharDBExecute("UPDATE mythic_weekly_progress SET highest_level = " ..
        newKeyLevel - 1 .. " WHERE player_id = " .. player:GetGUIDLow())
end

local function EndDungeonTimer(creature, killer)
    print("EndDungeonTimer")
    local range = 100
    local players = creature:GetPlayersInRange(range)

    if not TIME_TIERS or not CLASS_TIER_REWARDS or not MYTHIC_KEYSTONE_ENTRIES or not killer:GetData("DEADMINES_MYTHIC_LEVEL") then
        print("FAIL")
        return
    end

    for _, player in ipairs(players) do
        local success, message = pcall(function()

            player:SetData("DungeonEndTime", os.time(os.date("!*t")))

            local playerMythicLevel = player:GetData("DEADMINES_MYTHIC_LEVEL")

            local query = CharDBQuery("SELECT highest_level, week_start_date, reward_date FROM mythic_weekly_progress WHERE player_id = " .. player:GetGUIDLow())
            local highest_level = query:GetUInt32(0)
            local start_time = query:GetUInt32(1)
            local reward_date = query:GetUInt32(2)

            if query then
                if not reward_date or reward_date then
                    CharDBExecute("UPDATE mythic_weekly_progress SET reward_date = " ..
                    os.time(os.date("!*t")) .. " WHERE player_id = " .. player:GetGUIDLow())
                end

            if playerMythicLevel <= highest_level then
                    player:SendBroadcastMessage("You have already completed this dungeon run and received your rewards.")
                    return
                end
            else
                print("Error executing the query")
            end
         
            local deathPenalty = player:GetData("DeathPenalty") or 0
            local elapsedTime = (os.time(os.date("!*t")) - start_time) + deathPenalty

            local tier = nil
            for tierName, timeLimit in pairs(TIME_TIERS) do
                print("timeLimit: " .. timeLimit)
                print("tierName: " .. tierName)
                print("elapsedTime: " .. elapsedTime)
                if elapsedTime <= timeLimit then
                    tier = tierName
                    break
                end
            end

            local playerClass = GetPlayerClass(player)
            local award = GetRewardForClass(playerClass, tier, playerMythicLevel)

            local upgradeAmounts = {
                PLATINUM = 4,
                GOLD = 3,
                SILVER = 2,
                BRONZE = 1
            }

            local newKeyLevel = playerMythicLevel + (upgradeAmounts[tier] or 0)
            newKeyLevel = math.min(30, newKeyLevel)

            local function TryUpgradeMythicKeystone(player, currentMythicLevel, newKeyLevel)
                print("Mythic Keystone Replacement - Current Level: " .. currentMythicLevel)
                print("Mythic Keystone Replacement - New Level: " .. newKeyLevel)
            
                local mythicKeystoneEntries = {}
                for i = 90001, 90030 do
                    table.insert(mythicKeystoneEntries, i)
                end
            
                for _, keystoneEntry in ipairs(mythicKeystoneEntries) do
                    local count = player:GetItemCount(keystoneEntry)
                    if count > 0 then
                        player:RemoveItem(keystoneEntry, 1)
                        local newKeystoneEntry = MYTHIC_KEYSTONE_ENTRIES[math.min(30, newKeyLevel + 1)]
                        player:AddItem(newKeystoneEntry, 1)
                        player:SetData("DEADMINES_MYTHIC_LEVEL", newKeyLevel + 1)
                        UpdatePlayerMythicLevelInSQL(player, newKeyLevel + 1)
                        player:SendBroadcastMessage("Your Mythic Keystone has been upgraded to level " .. newKeyLevel)
                    end
                end
            end            

            TryUpgradeMythicKeystone(player, playerMythicLevel, newKeyLevel)

            if award then
                player:AddItem(award, 1)
                SetReceivedWeeklyReward(player, award, playerMythicLevel)
                player:SendBroadcastMessage(
                    "Congratulations! You've been awarded for your performance. Check your inventory!")
            else
                player:SendBroadcastMessage("You didn't finish in time for a reward. Better luck next time!")
                playerMythicLevel = math.max(1, playerMythicLevel - 1) -- Decrease and ensure it doesn't go below 1
                player:SetData("DEADMINES_MYTHIC_LEVEL", playerMythicLevel)
                player:SendBroadcastMessage("Your Mythic Level has been decreased to " .. playerMythicLevel .. ".")
            end

            if newKeyLevel > playerMythicLevel then
                for bag = 0, MAX_BAG or 4 do
                    for slot = 0, MAX_SLOT or 32 do
                        local item = player:GetItemByPos(bag, slot)
                        if item and item:GetEntry() == MYTHIC_KEYSTONE_ENTRIES[playerMythicLevel] then
                            player:RemoveItem(item, 1)
                            player:AddItem(MYTHIC_KEYSTONE_ENTRIES[math.min(30, newKeyLevel + 1)], 1)
                            player:SetData("DEADMINES_MYTHIC_LEVEL", newKeyLevel)
                            UpdatePlayerMythicLevelInSQL(player, newKeyLevel)
                            player:SendBroadcastMessage("Your Mythic Keystone has been upgraded to level " .. newKeyLevel)
                            break
                        end
                    end
                end
            end
        end)

        player:SetData("DungeonStartTime", nil)
        player:SetData("DungeonEndTime", nil)
        if not success and message then
            print("Error processing EndDungeonTimer for player " .. player:GetName() .. ": " .. message)
        end
    end
end

local function OnFinalBossDeath(event, creature, killer)
    print("OnFinalBossDeath")
    EndDungeonTimer(creature, killer)
end

function CheckArea(event, player, newArea)
    print("CheckArea")

    local query = CharDBQuery("SELECT week_start_date FROM mythic_weekly_progress WHERE player_id = " .. player:GetGUIDLow())
    local start_date = 0

    if query then
        start_date = query:GetUInt32(0)
        print("now: " ..  os.time(os.date("!*t")))
        print("start_date: " .. start_date )
        print("start_date + 7 DAYS: " .. start_date + 604800)
        print( "start_date + 604800 < os.time(os.date(!*t))")
        print( start_date + 604800 < os.time(os.date("!*t")))
    else
        print("Error executing the query")
    end
    if DUNGEON_MAP_ID == player:GetMapId() then
        if not player:GetData("EnteredDungeon") then
            player:SetData("EnteredDungeon", true)
            StartDungeonTimer(player)
            SetMythicLevelFromItem(player)
        end
    else
        player:SetData("DungeonStartTime", nil)
        player:SetData("DungeonEndTime", nil)
        player:SetData("EnteredDungeon", false)
        return
    end
    if start_date == 0 or start_date + 604800 < os.time(os.date("!*t"))  then
        player:SendBroadcastMessage("New Week Started, Enjoy the dungeon!")
        CharDBExecute("UPDATE mythic_weekly_progress SET week_start_date = " ..
            os.time(os.date("!*t")) .. " WHERE player_id = " .. player:GetGUIDLow())
    else
        player:SendBroadcastMessage("Already Started for the week, come back next week")
        return
    end


end

RegisterPlayerEvent(6, OnPlayerDeath)                           -- 6 is the event code for PLAYER_EVENT_ON_DIE.\
RegisterPlayerEvent(27, CheckArea)                              -- AREA CHECK FOR MYTHIC LEVEL SCAN
RegisterCreatureEvent(639, 4, OnFinalBossDeath)                 -- FINAL BOSS REWARD FOR ENDGAME
for _, creatureId in ipairs(DEADMINES_NPC_LIST) do
    RegisterCreatureEvent(creatureId, 1, OnCreatureEnterCombat) -- CREATURE BUFFS HEALTH LEVEL CHANGE
end

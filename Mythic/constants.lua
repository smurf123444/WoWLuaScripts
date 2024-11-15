local constants = {}
constants.CLASS_TIER_REWARDS = require("rewardTable")
constants.BUFFS = { [2] = 20217 }
constants.DUNGEON_MAP_ID = 36
constants.DEADMINES_NPC_LIST = { 639, 598, 634, 1729 }
constants.TIME_TIERS = { PLATINUM = 0, GOLD = 100, SILVER = 240, BRONZE = 300 }
constants.UPGRADE_AMOUNTS = { PLATINUM = 4, GOLD = 3, SILVER = 2, BRONZE = 1 }

constants.MYTHIC_KEYSTONE_ENTRIES = {}
for i = 0, 29 do table.insert(constants.MYTHIC_KEYSTONE_ENTRIES, 90001 + i) end

constants.MYTHIC_TABLE = { [0] = { healthMultiplier = 1, levelAddition = 0, damageMultiplier = 1 } }
for i = 1, 30 do
    constants.MYTHIC_TABLE[i] = {
        healthMultiplier = 1 + i * 0.2,
        levelAddition = i * 2,
        powerMultiplier = 1 + i * 0.2
    }
end

function constants.GetRewardForClass(playerClass, tier, mythicLevel)
    if not playerClass or not tier or not mythicLevel then return nil end
    local classRewards = constants.CLASS_TIER_REWARDS[playerClass]
    if not classRewards then return nil end
    local tierRewards = classRewards[tier]
    if not tierRewards or not tierRewards[mythicLevel] then return nil end
    return tierRewards[mythicLevel]
end

function constants.SetMythicLevelFromItem(player, start_date, reward_date)
    local mythicKeystoneCount = 0
    local foundMythicKeystone = false
    local now = os.time(os.date("!*t"))
    if not player:GetData("MYTHIC_LEVEL_SET") and (start_date > reward_date + 604800) then
        for i = 1, 30 do
            mythicKeystoneCount = player:GetItemCount(90000 + i)
            if mythicKeystoneCount > 0 then
                player:SetData("DEADMINES_MYTHIC_LEVEL", i)
                player:SendBroadcastMessage("Your mythic level has been set to Mythic+" .. i .. ".")
                foundMythicKeystone = true
                CharDBExecute(
                    "INSERT INTO mythic_weekly_progress (player_id, highest_level, reward_date, reward_id, start_date) " ..
                    "VALUES (" .. player:GetGUIDLow() .. ", 0, 0, 0, " .. now .. ") " ..
                    "ON DUPLICATE KEY UPDATE " ..
                    "start_date = " .. now
                )

                break
            end
        end

        if not foundMythicKeystone then
            player:SendBroadcastMessage("Mythic Keystone not found in your bags!")
        end
        player:SetData("MYTHIC_LEVEL_SET", true)
    else
        return
    end
end

function constants.UpgradeMythicKeystone(player, newKeyLevel)
    for _, keystoneEntry in ipairs(constants.MYTHIC_KEYSTONE_ENTRIES) do
        local count = player:GetItemCount(keystoneEntry)
        if count > 0 then
            player:RemoveItem(keystoneEntry, 1)
            local newKeystoneEntry = constants.MYTHIC_KEYSTONE_ENTRIES[math.min(30, newKeyLevel)]
            player:AddItem(newKeystoneEntry, 1)
            CharDBExecute("UPDATE mythic_weekly_progress SET highest_level = " ..
            newKeyLevel - 1 .. " WHERE player_id = " .. player:GetGUIDLow())
            player:SendBroadcastMessage("Your Mythic Keystone has been upgraded to level " .. newKeyLevel)
            break
        end
    end
end

return constants

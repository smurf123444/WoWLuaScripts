-- Constants
local DEADMINES_MYTHIC_LEVEL = 500
local MYTHIC_KEYSTONE_ENTRY = 90000
local DUNGEON_AREA_ID = 1581
local MAX_BAG = 255
local MAX_SLOT = 255
local MYTHIC_TABLE = {
    [0] = { healthMultiplier = 1, levelAddition = 0, damageMultiplier = 1 },
    [1] = { healthMultiplier = 200, levelAddition = 20, powerMultiplier = 200 },
    [2] = { healthMultiplier = 400, levelAddition = 40, powerMultiplier = 400 },
}
-- Update player's mythic level based on the keystone in their bag
local function SetMythicLevelFromItem(player)
    for bag = 0, MAX_BAG do
        for slot = 0, MAX_SLOT do
            local item = player:GetItemByPos(bag, slot)
            if item and item:GetEntry() == MYTHIC_KEYSTONE_ENTRY then
                local level = math.max(0, item:GetCount())
                local message = "Your mythic level has been set to " .. level .. "."
                player:SendBroadcastMessage(message)
                player:SetUInt32Value(DEADMINES_MYTHIC_LEVEL, level)
                return
            end
        end
    end
    player:SendBroadcastMessage("Mythic Keystone not found in your bags!")
end
-- Check the player's area and update mythic level if needed
function CheckArea(event, player, newArea)
    if newArea == DUNGEON_AREA_ID then
        print("Mythic Stone being Scanned for", player:GetName())
        SetMythicLevelFromItem(player)
    end
end
-- Adjust NPC attributes when combat starts
local function OnCreatureEnterCombat(event, creature, target)
    local range = 100
    local targets = target:GetCreaturesInRange(range, 598)
    local players = creature:GetPlayersInRange(range)
    for _, npc in ipairs(targets) do
        if npc:GetData("MythicBuffed") then goto continue end
        for _, player in ipairs(players) do
            local mythicLevel = player:GetUInt32Value(DEADMINES_MYTHIC_LEVEL)
            if mythicLevel and MYTHIC_TABLE[mythicLevel] then
                npc:SetMaxHealth(npc:GetMaxHealth() * MYTHIC_TABLE[mythicLevel].healthMultiplier)
                npc:SetLevel(npc:GetLevel() + MYTHIC_TABLE[mythicLevel].levelAddition)
                npc:SetData("MythicBuffed", true)
                local newHealth = npc:GetMaxHealth()
                npc:SetHealth(newHealth)
                break
            end
        end
        ::continue::
    end
end
RegisterPlayerEvent(27, CheckArea)
RegisterCreatureEvent(598, 1, OnCreatureEnterCombat)



--[[ -- Deal damage to player on creature attack
local function OnCreatureAttack(event, creature, target)
    local range = 100
    local creatures = creature:GetCreaturesInRange(range, 598)
    local player = target:IsPlayer() and target or nil
    if player then
        local mythicLevel = player:GetUInt32Value(DEADMINES_MYTHIC_LEVEL)
        if mythicLevel and MYTHIC_SLAM_DAMAGE[mythicLevel] then
            for _, npc in ipairs(creatures) do
                npc:SendUnitYell("Feel the power of my Mythic Slam!", 0)
                npc:DealDamage(player, MYTHIC_SLAM_DAMAGE[mythicLevel], false)
            end
        end
    end
end
 ]]
-- Event registrations

--[[ RegisterCreatureEvent(598, 3, OnCreatureAttack) ]]

local AIO = AIO or require("AIO")
local MyHandlers = AIO.AddHandlers("Kaev", {})
local AttributesPointsLeft = {}
local AttributesPointsSpend = {}
local AttributesAuraIds = { 7464, 7471, 7477, 7468, 7474 } -- Strength, Agility, Stamina, Intellect, Spirit

local function AddPlayerStats(msg, player)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local result = CharDBQuery(querySelect)
    local statsTextLevel1 = ""
    local statsTextLevel2 = ""
    
    if result then
        local characterName = result:GetString(0)
        local skills = {
            {name = "Attack", levelIndex = 3, xpIndex = 4},
            {name = "Defence", levelIndex = 5, xpIndex = 6},
            {name = "Strength", levelIndex = 7, xpIndex = 8},
            {name = "Magic", levelIndex = 9, xpIndex = 10},
            {name = "Range", levelIndex = 11, xpIndex = 12},
            {name = "Hitpoint", levelIndex = 13, xpIndex = 14},
            {name = "Prayer", levelIndex = 15, xpIndex = 16},
            {name = "Woodcutting", levelIndex = 1, xpIndex = 2},
            {name = "Hitpoints", levelIndex = 13, xpIndex = 14},
            {name = "Prayer", levelIndex = 15, xpIndex = 16},
            {name = "Fishing", levelIndex = 23, xpIndex = 24},
            {name = "Cooking", levelIndex = 29, xpIndex = 30},
            {name = "Firemaking", levelIndex = 31, xpIndex = 32},
            {name = "Crafting", levelIndex = 17, xpIndex = 18},
            {name = "Smithing", levelIndex = 21, xpIndex = 22},
            {name = "Mining", levelIndex = 19, xpIndex = 20},
            {name = "Herblore", levelIndex = 33, xpIndex = 34},
            {name = "Agility", levelIndex = 35, xpIndex = 36},
            {name = "Thieving", levelIndex = 37, xpIndex = 38},
            {name = "Slayer", levelIndex = 39, xpIndex = 40},
            {name = "Farming", levelIndex = 41, xpIndex = 42},
            {name = "Runecrafting", levelIndex = 43, xpIndex = 44},
        }
    
        local totalSkills = #skills
        local halfSkills = math.floor(totalSkills / 2)
    
        for i, skill in ipairs(skills) do
            local level = result:GetUInt32(skill.levelIndex)
            local xp = tostring(result:GetUInt64(skill.xpIndex))
    
            if i <= halfSkills then
                statsTextLevel1 = statsTextLevel1 .. skill.name .. " Level: " .. level .. "\n"
                statsTextLevel1 = statsTextLevel1 .. skill.name .. " XP: " .. xp .. "\n\n"
            else
                statsTextLevel2 = statsTextLevel2 .. skill.name .. " Level: " .. level .. "\n"
                statsTextLevel2 = statsTextLevel2 .. skill.name .. " XP: " .. xp .. "\n\n"
            end
    
            -- Add a line break every two items
        end
    
    end
    
    
    local guid = player:GetGUIDLow()
    local spend, left = AttributesPointsSpend[guid], AttributesPointsLeft[guid]
    msg:Add("Kaev", "SetText1", statsTextLevel1)
    msg:Add("Kaev", "SetText2", statsTextLevel2)
    return msg:Add("Kaev", "SetStats", left, AIO.unpack(spend), statsTextLevel1)
end

AIO.AddOnInit(AddPlayerStats)
local function UpdatePlayerStats(player)
    AddPlayerStats(AIO.Msg(), player):Send(player)
end
local function AttributesInitPoints(guid)
    AttributesPointsLeft[guid] = 5
    AttributesPointsSpend[guid] = { 0, 0, 0, 0, 0 }
end
local function AttributesDeinitPoints(guid)
    AttributesPointsLeft[guid] = nil
    AttributesPointsSpend[guid] = nil
end

local function OnLogin(event, player)
    AttributesInitPoints(player:GetGUIDLow())
end
local function OnLogout(event, player)
    AttributesDeinitPoints(player:GetGUIDLow())
end

RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(4, OnLogout)
for k,v in ipairs(GetPlayersInWorld()) do
    OnLogin(3, v)
end

function MyHandlers.AttributesIncrease(player, statId)
    if (player:IsInCombat()) then
        player:SendBroadcastMessage("Du kannst während einem Kampfes keine Attributspunkte verteilen.")
    else
        local guid = player:GetGUIDLow()
        local spend, left = AttributesPointsSpend[guid], AttributesPointsLeft[guid]
        if not spend or not left then
            return
        end
        if not statId or not spend[statId] then
            return
        end
        if (left <= 0) then
            player:SendBroadcastMessage("Du hast nicht genuegend Attributspunkte.")
        else
            AttributesPointsLeft[guid] = left - 1
            spend[statId] = spend[statId] + 1
            local aura = player:GetAura(AttributesAuraIds[statId])
            if (aura) then
                aura:SetStackAmount(spend[statId])
            else
                player:AddAura(AttributesAuraIds[statId], player)
            end
            UpdatePlayerStats(player)
        end
    end
end

function MyHandlers.AttributesDecrease(player, statId)
    if (player:IsInCombat()) then
        player:SendBroadcastMessage("Du kannst während einem Kampfes keine Attributspunkte verteilen.")
    else
        local guid = player:GetGUIDLow()
        local spend, left = AttributesPointsSpend[guid], AttributesPointsLeft[guid]
        if not spend or not left then
            return
        end
        if not statId or not spend[statId] then
            return
        end
        if (spend[statId] <= 0) then
            player:SendBroadcastMessage("Es sind keine Punkte auf diesem Attribut verteilt.")
        else
            AttributesPointsLeft[guid] = left + 1
            spend[statId] = spend[statId] - 1
            local aura = player:GetAura(AttributesAuraIds[statId])
            if (aura) then
                aura:SetStackAmount(spend[statId])
            else
                player:AddAura(AttributesAuraIds[statId], player)
            end
            UpdatePlayerStats(player)
        end
    end
end


local function AttributesOnCommand(event, player, command)
    if(command == "para") then
        AIO.Handle(player, "Kaev", "ShowAttributes")
        return false
    end
end
RegisterPlayerEvent(42, AttributesOnCommand)
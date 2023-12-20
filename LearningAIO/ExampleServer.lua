local AIO = AIO or require("AIO")
local MyHandlers = AIO.AddHandlers("Kaev", {})

local function AddPlayerStats(msg, player)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    local result = CharDBQuery(querySelect)
    local statsTextLevel1 = ""
    local statsTextLevel2 = ""
    
    if result then
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
    msg:Add("Kaev", "SetText1", statsTextLevel1)
    
    return msg:Add("Kaev", "SetText2", statsTextLevel2)
end

AIO.AddOnInit(AddPlayerStats)
local function UpdatePlayerStats(player)
    AddPlayerStats(AIO.Msg(), player):Send(player)
end


local function OnLogin(event, player)
    UpdatePlayerStats(player:GetGUIDLow())
end
local function OnLogout(event, player)
    UpdatePlayerStats(player:GetGUIDLow())
end

RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(4, OnLogout)


for k,v in ipairs(GetPlayersInWorld()) do
    OnLogin(3, v)
end



local function AttributesOnCommand(event, player, command)
    if(command == "para") then
        AIO.Handle(player, "Kaev", "ShowAttributes")
        return false
    end
end
RegisterPlayerEvent(42, AttributesOnCommand)
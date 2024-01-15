local AIO = AIO or require("AIO")
local MyHandlers = AIO.AddHandlers("MythicUI", {})

local function AddPlayerStats(msg, player)
    local querySelect = "SELECT * FROM mythic_weekly_progress WHERE player_id = " .. player:GetGUIDLow()
    local result = CharDBQuery(querySelect)
    local statsTextLevel1 = ""

    if result then
        local items = {
            {name = "Mythic Level", levelIndex = 1, weekStartDateIndex=2,rewardDate=3,lastRewardID=4},
        }

        for i, skill in ipairs(items) do
            local level = result:GetUInt32(skill.levelIndex)
            local week = result:GetString(skill.weekStartDateIndex)
            local rewardDate = result:GetString(skill.rewardDate)
            local lastRewardID = result:GetString(skill.lastRewardID)

 --[[            local endTime = player:GetData("DungeonEndTime") ]]
      

            statsTextLevel1 = statsTextLevel1 .. skill.name .. ": " .. level .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Week Start Date: " .. week .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Last Reward Date: " .. rewardDate .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Last Reward ID: " .. lastRewardID .. "\n\n"
        
--[[             print("Level: "..level)
            print("Week: "..week)
            print("rewardDate: "..rewardDate)
            print("lastRewardID: "..lastRewardID) ]]
        end
    end
    
    return msg:Add("MythicUI", "SetText1", statsTextLevel1)
end

AIO.AddOnInit(AddPlayerStats)
local function UpdatePlayerStats(player)
    AddPlayerStats(AIO.Msg(), player):Send(player)
end


for k,v in ipairs(GetPlayersInWorld()) do
    OnLogin(3, v)
end

local function AttributesOnCommand(event, player, command)
    if(command == "para") then


        AIO.Handle(player, "MythicUI", "ShowAttributes")
        return false
    end
end
local function OnLogin(event, player)
    UpdatePlayerStats(player:GetGUIDLow())
end
local function OnLogout(event, player)
    UpdatePlayerStats(player:GetGUIDLow())
end

RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(4, OnLogout)

RegisterPlayerEvent(42, AttributesOnCommand)
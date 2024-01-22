local AIO = AIO or require("AIO")
local MyHandlers = AIO.AddHandlers("MYTHIC_SERVER", {})
local elapsedTime =0
function MyHandlers.UpdateMythicInfo(msg, player)
    local querySelect = "SELECT * FROM mythic_weekly_progress WHERE player_id = " .. player:GetGUIDLow()
    local result = CharDBQuery(querySelect)
    local statsTextLevel1 = ""

    if result then
        local items = {
            {name = "Last Mythic Level", levelIndex = 1, weekStartDateIndex=4,lastRewardID=3,reward_date=2},
        }

        for i, skill in ipairs(items) do
            local level = result:GetUInt32(skill.levelIndex)
            local week = result:GetString(skill.weekStartDateIndex)
            local lastRewardID = result:GetString(skill.lastRewardID)
            local reward_date = result:GetString(skill.reward_date)
            elapsedTime = (os.time(os.date("!*t")) - week)

            statsTextLevel1 = statsTextLevel1 .. skill.name .. " completed: " .. level .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " start_date: " .. week .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Last Reward ID: " .. lastRewardID .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Elapsed Time: " .. elapsedTime .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " reward_date: " .. reward_date .. "\n\n"
        end
    end
    return msg:Add("MYTHIC_CLIENT", "SetText1", statsTextLevel1)
end

local function UpdateMythic(player)
    elapsedTime =0
    MyHandlers.UpdateMythicInfo(AIO.Msg(), player):Send(player)
end

local function ShowTimer(event, player)
    elapsedTime =0
    UpdateMythic(player)
    AIO.Handle(player, "MYTHIC_CLIENT", "ShowTimer", elapsedTime)
end
local function HideTimer(event, player)
    elapsedTime =0
    UpdateMythic(player)
    AIO.Handle(player, "MYTHIC_CLIENT", "HideTimer")
end

local function CheckArea(event, player, newArea)
    local DUNGEON_MAP_ID = 36

    if DUNGEON_MAP_ID == player:GetMapId() then
        ShowTimer(_,player)
    else
        HideTimer(_,player)
    end
end

local function AttributesOnCommand(event, player, command)
    UpdateMythic(player)
    if(command == "para") then
        AIO.Handle(player, "MYTHIC_CLIENT", "ShowMythicInfo")
        return false
    end
end


RegisterPlayerEvent(27, CheckArea)
RegisterPlayerEvent(42, AttributesOnCommand)

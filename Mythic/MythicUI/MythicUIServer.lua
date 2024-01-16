local AIO = AIO or require("AIO")
local MyHandlers = AIO.AddHandlers("MYTHIC_SERVER", {})

function MyHandlers.UpdateMythicInfo(msg, player)
    local querySelect = "SELECT * FROM mythic_weekly_progress WHERE player_id = " .. player:GetGUIDLow()
    local result = CharDBQuery(querySelect)
    local statsTextLevel1 = ""

    if result then
        local items = {
            {name = "Last Mythic Level", levelIndex = 1, weekStartDateIndex=2,lastRewardID=3,},
        }

        for i, skill in ipairs(items) do
            local level = result:GetUInt32(skill.levelIndex)
            local week = result:GetString(skill.weekStartDateIndex)
            local lastRewardID = result:GetString(skill.lastRewardID)
            local elapsedTime = (os.time(os.date("!*t")) - week)

            statsTextLevel1 = statsTextLevel1 .. skill.name .. " completed: " .. level .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Week Start Date: " .. week .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Last Reward ID: " .. lastRewardID .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Elapsed Time: " .. elapsedTime .. "\n\n"
        end
    end
    return msg:Add("MYTHIC_CLIENT", "SetText1", statsTextLevel1)
end

local function UpdateMythic(player)
    MyHandlers.UpdateMythicInfo(AIO.Msg(), player):Send(player)
end

local function AttributesOnCommand(event, player, command)
    UpdateMythic(player)
    if(command == "para") then
        AIO.Handle(player, "MYTHIC_CLIENT", "ShowAttributes")
        return false
    end
end

RegisterPlayerEvent(42, AttributesOnCommand)
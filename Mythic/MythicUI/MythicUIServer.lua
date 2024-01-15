local AIO = AIO or require("AIO")
local MyHandlers = AIO.AddHandlers("MythicUI", {})

local function AddPlayerStats(msg, player)
    local querySelect = "SELECT * FROM mythic_weekly_progress WHERE player_id = " .. player:GetGUIDLow()
    local result = CharDBQuery(querySelect)
    local statsTextLevel1 = ""

    if result then
        local items = {
            {name = "Last Mythic Level", levelIndex = 1, weekStartDateIndex=2,lastRewardID=3,},
        }

        for i, level in ipairs(items) do
            local level = result:GetUInt32(level.levelIndex)
            local week = result:GetString(level.weekStartDateIndex)
            local lastRewardID = result:GetString(level.lastRewardID)
            local elapsedTime = (os.time(os.date("!*t")) - week)

            statsTextLevel1 = statsTextLevel1 .. level.name .. " completed: " .. level .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Week Start Date: " .. week .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Last Reward ID: " .. lastRewardID .. "\n\n"
            statsTextLevel1 = statsTextLevel1 ..  " Elapsed Time: " .. elapsedTime .. "\n\n"

        end
    end
    return msg:Add("MythicUI", "SetText1", statsTextLevel1)
end

AIO.AddOnInit(AddPlayerStats)

for k,v in ipairs(GetPlayersInWorld()) do
    OnLogin(3, v)
end

local function AttributesOnCommand(event, player, command)
    if(command == "para") then
        AIO.Handle(player, "MythicUI", "ShowAttributes")
        return false
    end
end

RegisterPlayerEvent(42, AttributesOnCommand)
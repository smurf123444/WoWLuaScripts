local COMMAND = "getplayeritems"

local function HandleGetPlayerItemsCommand(event, player, command)
    if command:find(COMMAND) then
        local playerName = string.gsub(command, COMMAND .. " ", "")
        
        local target = GetPlayerByName(playerName)
        
        if not target then
            player:SendBroadcastMessage("Player not found!", 1)
            return false
        end

        player:SendBroadcastMessage("Items of " .. target:GetName() .. ":", 1)
        
        -- Equipment items
        for i = 0, 18 do
            local item = target:GetEquippedItemBySlot(i)
            if item then
                player:SendBroadcastMessage("Equip [" .. i .. "]: " .. item:GetName(), 1)
            end
        end
        
        -- Inventory items
        for bag = 0, 255 do
            for slot = 0, 255 do
                local item = target:GetItemByPos(bag, slot)
                if item then
                    player:SendBroadcastMessage("Bag [" .. bag .. "] Slot [" .. slot .. "]: " .. item:GetName(), 1)
                end
            end
        end
        
        -- Currency
        local copper = target:GetCoinage()
        local gold = math.floor(copper / 10000)
        local silver = math.floor((copper - (gold * 10000)) / 100)
        copper = copper - (gold * 10000) - (silver * 100)
        player:SendBroadcastMessage("Currency: " .. gold .. " Gold, " .. silver .. " Silver, " .. copper .. " Copper", 1)

        return false
    end
end

RegisterPlayerEvent(42, HandleGetPlayerItemsCommand) -- Register EVENT_ON_COMMAND

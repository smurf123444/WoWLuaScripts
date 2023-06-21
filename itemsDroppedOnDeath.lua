-- Event handler for player death
local function onPlayerDeath(event, player, unit)
    local gameObj = player:SummonGameObject(510001, 2475, 2342, 50, 4)
    local menu = {}

      for bag = 0, 255 do
            for slot = 0, 255 do
                local item = unit:GetItemByPos(bag, slot)
                if item then
                    local entry = item:GetEntry()
                    local count = item:GetCount()
                    local itemName = item:GetName()
                    table.insert(menu, { entry, itemName, slot, "You have "..count.." "..itemName.."." })
                    print("Item Name:", itemName)
                    print("Item Entry:", entry)
                    print("Item Count:", count)
                end
            end
        end 
        player:GossipClearMenu()
    
        for index, itemData in ipairs(menu) do
            player:GossipMenuAddItem(0, itemData[2], index, 0, itemData[4])

                -- Option for individual items (use intid as index to access the selected item)
                local itemData = menu[index]
                
                if itemData then
                    local itemName = itemData[2]
                    local itemEntry = itemData[1]
                    
                    if unit:HasItem(itemEntry) then
                        unit:RemoveItem(itemEntry, 1)
                        unit:SendBroadcastMessage("Removed "..itemName.." from your inventory.")
                        -- player:AddItem(itemEntry, 1)
                        gameObj:AddLoot(itemEntry, 1)
                        player:SendBroadcastMessage("Added "..itemName.." to your inventory.")
                    end
                    
                    player:GossipComplete()
                end

        end
        player:GossipSendMenu(1, player, 0)

end

-- Register the event handler
RegisterPlayerEvent(6, onPlayerDeath)


  --  local corpse = player:GetCorpse() -- Replace with the target player's GUID
--[[   local unfriendlys = unit:GetUnfriendlyUnitsInRange( 100 )
  local friends = unit:GetFriendlyUnitsInRange( 100 )
  print("Enemies", unfriendlys)
  print("Friends", friends)
    print("Unfriendly Units:", player:GetGUIDLow(unfriendlys[1]))
    print("Friendly Units:", unit:GetGUIDLow(friends[1])) ]]
    



--[[ -- Event handler for player login
local function onPlayerDeath(event, player)
    Player:GetCorpse()GetOwnerGUID())
    for bag = 0, 255 do
        for slot = 0, 255 do
            local item = player:GetItemByPos(bag, slot)
            if item then
                local entry = item:GetEntry()
                local count = item:GetCount()
                local itemName = item:GetName()
                print("Item Name:", itemName)
                print("Item Entry:", entry)
                print("Item Count:", count)
            end
        end
    end
end

-- Register the event handler
RegisterPlayerEvent(6, onPlayerDeath)


 ]]


--[[ local AREA_ID = 4989 -- Replace 123 with the desired area ID

-- Function to create a chest at a specific location
local function onPlayerDeath(event, player)
    local areaId = player:GetAreaId()
    
    if areaId == AREA_ID then
        local gameObj = player:SummonGameObject(190663, 2475, 2342, 50, 4)
        
        -- Debug output
        print("Chest created for player "..player:GetName().." at location (2475, 2342)")
        print("ITEM DEBUG "..player:GetItemByPos(19, 0))
        -- Populate the chest with items from the player's inventory
        for bag = 0, 255 do -- Iterate through the possible bag IDs
            for slot = 0, 255 do -- Iterate through the possible slot IDs
                local item = player:GetItemByPos(bag, slot)
                
                if item then
                    local itemId = item:GetEntry()
                    local itemCount = player:GetItemCount(itemId)
                    
                    -- Debug output
                    print("Checking item at Bag: "..bag..", Slot: "..slot..", Item ID: "..itemId)
                    
                    -- Remove the items from the player's inventory
                    player:RemoveItem(itemId, itemCount)
                    
                    -- Add the items to the chest
                    gameObj:AddItem(itemId, itemCount)
                    
                    -- Debug output
                    print("Removing item ID "..itemId.." (Count: "..itemCount..") from player "..player:GetName())
                    print("Adding item ID "..itemId.." (Count: "..itemCount..") to chest for player "..player:GetName())
                end
            end
        end
    end
end

RegisterPlayerEvent(6, onPlayerDeath) -- Register the event handler for player death (Event: OnDeath)

 ]]
local ITEMID = 90004 -- Replace with the entry ID of the item that triggers the gossip menu

function OnGossip(event, player, item, sender, intid)

        print("Showing Main Gossip Menu")
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "Check Skills", 0, 1)
        player:GossipMenuAddItem(0, "Item 2", 0, 2)
        player:GossipMenuAddItem(0, "Item 3", 0, 3)
        -- Add more items here if needed

        player:GossipSendMenu(1, item, 123)

end
function OnGossipSelect(event, player, item, sender, intid)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
    if intid == 1 then
        print("Selected Item 1")

        player:GossipClearMenu()

        local result = CharDBQuery(querySelect)
        if result then
            local characterName = result:GetString(0)
            
            local gossipText = "Skill Information:\n"
            
            -- Retrieve and append each skill information
            local skills = {
                {name = "Woodcutting", levelIndex = 1, xpIndex = 2},
                {name = "Attack", levelIndex = 3, xpIndex = 4},
                {name = "Defence", levelIndex = 5, xpIndex = 6},
                {name = "Strength", levelIndex = 7, xpIndex = 8},
                {name = "Magic", levelIndex = 9, xpIndex = 10},
                {name = "Range", levelIndex = 11, xpIndex = 12},
                {name = "Hitpoint", levelIndex = 13, xpIndex = 14},
                {name = "Prayer", levelIndex = 15, xpIndex = 16}
            }
            
            for _, skill in ipairs(skills) do
                local level = result:GetUInt32(skill.levelIndex)
                local xp = tostring(result:GetUInt64(skill.xpIndex))
 
                gossipText = gossipText .. skill.name .. " Level: " .. level .. "\n"
                gossipText = gossipText .. skill.name .. " XP: " .. xp .. "\n\n"

            end
                            player:GossipMenuAddItem(0, gossipText, 0, 1)
            -- Handle submenu option for Item 1 with skill information
            player:GossipSendMenu(1, item, 123, gossipText)
        else
            player:GossipSendMenu(1, item, 123, "No data found")
        end

    elseif intid == 2 then
        -- Handle submenu option for Item 2
        print("Selected Item 2")
        player:AddItem(ITEMID, 1)
    end
end


RegisterItemGossipEvent(ITEMID, 1, OnGossip)
RegisterItemGossipEvent(ITEMID, 2, OnGossipSelect)
RegisterPlayerGossipEvent( 123, 2, OnGossipSelect )
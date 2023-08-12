
local PLAYER_FIELD_MYTHIC_LEVEL = 500 -- Use an appropriate storage method for the player's mythic level.

    local ITEMID = 90000

    function OnGossip(event, player, item, sender, intid)
        print("Showing Main Gossip Menu")
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "Mythic Level set to 1", 0, 1)
        player:GossipMenuAddItem(0, "Mythic Level set to 2", 1, 1)
        player:GossipMenuAddItem(0, "[Exit]", 2, 0)
        player:GossipSendMenu(1, item, 123)
    end
    
    function OnGossipSelect(event, player, item, sender, intid)

    
        if (intid == 1) then
            player:SetUInt32Value(PLAYER_FIELD_MYTHIC_LEVEL, 1)
        else
            player:SendBroadcastMessage("No specified file.")
            player:GossipComplete()
        end
    
        if (intid == 2) then
            player:SetUInt32Value(PLAYER_FIELD_MYTHIC_LEVEL, 2)
        end
    end
    



--[[ RegisterCreatureGossipEvent( NPC_ID, 1, OnGossip )
RegisterCreatureGossipEvent( NPC_ID, 2, OnGossipSelect ) ]]
RegisterItemGossipEvent(ITEMID, 1, OnGossip)
RegisterItemGossipEvent(ITEMID, 2, OnGossipSelect)
--[[  local ITEMID = 90005 -- Replace with the entry ID of the item that triggers the gossip menu

function OnGossip(event, player, item, sender, intid)

        print("Showing Main Gossip Menu")
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "Check Skills", 0, 1)
        player:GossipMenuAddItem(0, "Reload script.", 1, 1)
        player:GossipMenuAddItem(0, "[Exit]", 2, 0)
        -- Add more items here if needed

        player:GossipSendMenu(1, item, 123)

end
function OnGossipSelect(event, player, item, sender, intid)
    local querySelect = "SELECT * FROM custom_levels WHERE characterName = 'yoyo'"
	if (intid == 1) then
        dofile("lua_scripts/Bosses/Forest/forest_boss_1.lua")
        player:SendBroadcastMessage("Reloading forest_boss_1.lua")

		else
			player:SendBroadcastMessage("No specified file.")
	
		player:GossipComplete()
	end
	
	if (intid == 2) then
		player:GossipComplete()
	end ]]

    local ITEMID = 90005 -- Replace with the entry ID of the item that triggers the gossip menu

    local forestBossScript = "lua_scripts/Bosses/Forest/forest_boss_1.lua"
         -- Load the file as a function
    
    function OnGossip(event, player, item, sender, intid)
        print("Showing Main Gossip Menu")
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "Check Skills", 0, 1)
        player:GossipMenuAddItem(0, "Reload script.", 1, 1)
        player:GossipMenuAddItem(0, "[Exit]", 2, 0)
        -- Add more items here if needed
        player:GossipSendMenu(1, item, 123)
    end
    
    function OnGossipSelect(event, player, item, sender, intid)

    
        if (intid == 1) then
          dofile("lua_scripts/Bosses/Forest/forest_boss_1.lua")  -- Execute the function to reload the file
            player:SendBroadcastMessage("Reloading forest_boss_1.lua")
        else
            player:SendBroadcastMessage("No specified file.")
            player:GossipComplete()
        end
    
        if (intid == 2) then
            player:GossipComplete()
        end
    end
    


RegisterItemGossipEvent(ITEMID, 1, OnGossip)
RegisterItemGossipEvent(ITEMID, 2, OnGossipSelect)
RegisterPlayerGossipEvent( 123, 2, OnGossipSelect )
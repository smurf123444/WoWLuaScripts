function ReloadLua_Trigger(item, event, player)
	item:GossipCreateMenu(50, player, 0)
	item:GossipMenuAddItem(0, "Reload script.", 1, 1)
	item:GossipMenuAddItem(0, "[Exit]", 2, 0)
	item:GossipSendMenu(player)
end

function ReloadLua_Select(item, event, player, id, intid, code)
	if (intid == 1) then
        dofile("scripts/forest_boss_1.lua")
        player:SendBroadcastMessage("Reloading " .. code .. ".")

		else
			player:SendBroadcastMessage("No specified file.")
	
		player:GossipComplete()
	end
	
	if (intid == 2) then
		player:GossipComplete()
	end
end

RegisterItemGossipEvent(90004, 1, ReloadLua_Trigger)
RegisterItemGossipEvent(90004, 2, ReloadLua_Select)
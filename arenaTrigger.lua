local arenaAreaID = 4989 -- Replace with the ID of your arena area
local arenaMode = false

function CheckArenaArea(event, player, newArea)
    print("Ran function")
    print(newArea)
  if (newArea == arenaAreaID and not arenaMode) then
  --  player:SetPvP(true) -- Enables PvP mode for the player
    player:SetFFA(true) -- Enables Free-For-All PvP mode for the player
    player:SendBroadcastMessage("Arena mode enabled!") -- Sends a message to the player to confirm that arena mode is enabled
    arenaMode = true
    print("Arena mode enabled for player " .. player:GetName() .. ".")
  elseif (newArea ~= arenaAreaID and arenaMode) then
   -- player:SetPvP(false) -- Disables PvP mode for the player
    player:SetFFA(false) -- Disables Free-For-All PvP mode for the player
    player:SendBroadcastMessage("Arena mode disabled.") -- Sends a message to the player to confirm that arena mode is disabled
    arenaMode = false
    print("Arena mode disabled for player " .. player:GetName() .. ".")
  end
end

RegisterPlayerEvent(27, CheckArenaArea) -- Registers the function to be called when the player enters a new area
print("Arena mode script loaded.")

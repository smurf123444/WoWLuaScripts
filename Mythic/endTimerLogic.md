1. Import the `constants` module.
   ```lua
   local constants = require("constants")
   ```

2. Define a function `EndDungeonTimer` that takes `creature` and `killer` as parameters.
   ```lua
   function endTimer.EndDungeonTimer(creature, killer)
   ```

3. Set the range for finding players in proximity to the creature.
   ```lua
   local range = 100
   ```

4. Get the list of players within the specified range of the creature.
   ```lua
   local players = creature:GetPlayersInRange(range)
   ```

5. Check if required constants and data are available; if not, print an error and exit.
   ```lua
   if not constants.TIME_TIERS or not constants.CLASS_TIER_REWARDS or not constants.MYTHIC_KEYSTONE_ENTRIES or not killer:GetData("DEADMINES_MYTHIC_LEVEL") then
       print("FAIL")
       return
   end
   ```

6. Iterate through the list of players obtained in step 4.
   ```lua
   for _, player in ipairs(players) do
   ```

7. Use a protected call to handle errors gracefully during player processing.
   ```lua
   local success, message = pcall(function()
   ```

8. Retrieve player's mythic level and weekly progress from the database.
   ```lua
   local playerMythicLevel = player:GetData("DEADMINES_MYTHIC_LEVEL")
   local query = CharDBQuery("SELECT highest_level, week_start_date FROM mythic_weekly_progress WHERE player_id = " .. player:GetGUIDLow())
   ```

9. Check if the database query was successful; if not, print an error and exit.
   ```lua
   if not query then
       print("Error executing the query")
       return
   end
   ```

10. Extract highest level and start time from the database query.
    ```lua
    local highest_level = query:GetUInt32(0)
    local start_time = query:GetUInt32(1)
    ```

11. Check if the player has already completed this dungeon run; if so, inform the player and exit.
    ```lua
    if playerMythicLevel <= highest_level then
        player:SendBroadcastMessage("You have already completed this dungeon run and received your rewards for this level. Error.")
        return
    end
    ```

12. Calculate the elapsed time and determine the reward tier.
    ```lua
    local deathPenalty = player:GetData("DeathPenalty") or 0
    local elapsedTime = (os.time(os.date("!*t")) - start_time) + deathPenalty
    local tier = nil
    ```

13. Iterate through time tiers to find the appropriate tier based on elapsed time.
    ```lua
    for tierName, timeLimit in pairs(constants.TIME_TIERS) do
        if elapsedTime <= timeLimit then
            tier = tierName
            break
        end
    end
    ```

14. Get the reward for the player's class and tier, calculate the new key level, and handle rewards or penalties.
    ```lua
    local award = constants.GetRewardForClass(player:GetClass(), tier, playerMythicLevel)
    local newKeyLevel = playerMythicLevel + (constants.UPGRADE_AMOUNTS[tier] or 0)
    newKeyLevel = math.min(30, newKeyLevel)
    ```

15. Check if there is a valid award; if so, give the player the reward and update the database with the new progress.
    ```lua
    if award then
        player:AddItem(award, 1)
        CharDBExecute("INSERT INTO mythic_weekly_progress (player_id, highest_level, week_start_date, reward_id) VALUES ("
            .. player:GetGUIDLow() .. ", " ..playerMythicLevel .. ", CURDATE(), " ..award ..") ON DUPLICATE KEY UPDATE reward_id = " ..
            award .. ", highest_level = GREATEST(highest_level, " .. playerMythicLevel .. ")")
        player:SendBroadcastMessage("Congratulations! You've been awarded for your performance. Check your inventory!")
    else
    ```

16. If no valid award, inform the player that they didn't finish in time for a reward and apply a penalty.
    ```lua
    player:SendBroadcastMessage("You didn't finish in time for a reward. Better luck next time!")
    playerMythicLevel = math.max(1, playerMythicLevel - 1)
    player:SetData("DEADMINES_MYTHIC_LEVEL", playerMythicLevel)
    player:SendBroadcastMessage("Your Mythic Level has been decreased to " .. playerMythicLevel .. ".")
    ```

17. Upgrade the mythic keystone if the new level is higher than the current level.
    ```lua
    if newKeyLevel > playerMythicLevel then
        constants.UpgradeMythicKeystone(player, newKeyLevel)
    end
    ```

18. Close the protected call block.
    ```lua
    end)
    ```

19. Handle errors during player processing and print relevant information.
    ```lua
    if not success and message then
        print("Error processing EndDungeonTimer for player " .. player:GetName() .. ": " .. message)
    end
    ```

20. Close the loop for iterating through players.
    ```lua
    end
    ```

21. End the function.
    ```lua
    end
    ```

22. Return the `endTimer` module.
    ```lua
    return endTimer
    ```

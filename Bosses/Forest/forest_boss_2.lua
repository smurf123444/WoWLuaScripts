local RichardHeart = {}
local announcedPhase = 0
 -- Tracks the current phase
 -- Tracks the last announced phase
local currentPhase = 1
local soundPlayed = false
function RichardHeart.OnSpawn(event, creature)
    creature:SendUnitYell("Welcome, to pulsechain WoW!", 0)
    creature:SetWanderRadius(10)
    creature:CastSpell(creature, 41924, true)
end

function RichardHeart.SummonHounds(creature, target)
    local x, y, z = creature:GetRelativePoint(math.random()*9, math.random()*math.pi*2)
    local hound = creature:SpawnCreature(37098, x, y, z + 5, 0, 2, 300000)
    hound:AttackStart(target)
end

function RichardHeart.SpawnHounds(event, delay, pCall, creature)
    local range = 40 -- maximum range to search for players
    local targets = creature:GetPlayersInRange(range)
    local closestPlayer = nil
    local closestDistance = range + 1 -- start with a value greater than the maximum range
    for _, player in ipairs(targets) do
        local distance = creature:GetDistance(player)
        if (distance < closestDistance) then
            closestPlayer = player
            closestDistance = distance
        end
    end
  --  creature:AttackStart(closestPlayer) -- attack the closest player
    print("Closest player:", closestPlayer)
    RichardHeart.SummonHounds(creature, closestPlayer)

    creature:RegisterEvent(RichardHeart.SpawnHounds, 45000, 1)
end


function RichardHeart.OnEnterCombat(event, creature, target)
    creature:SendUnitYell("Come to me... \"Pretender\". FEED MY BLADE!", 0)
    creature:PlayDirectSound(17242) -- Add this line to play a sound
   -- creature:RegisterEvent(RichardHeart.SpawnHounds, 8000, 1)
end


function RichardHeart.OnLeaveCombat(event, creature, world)
    local yellOptions = "Hehehe..."
    creature:PlayDirectSound(14973)
    creature:SendUnitYell(yellOptions, 0)
    creature:RemoveEvents()
end

function RichardHeart.OnDied(event, creature, killer)
    creature:SendUnitYell("Agh! Ugh.....OOhha..", 0)
    creature:PlayDirectSound(17374) -- Replace 1234 with the ID of the sound you want to play
    if(killer:GetObjectType() == "Player") then
        killer:SendBroadcastMessage("You killed " ..creature:GetName().."!")
    end
    creature:RemoveEvents()
    currentPhase = 1
end

local burstRan = false
local hasSummonWormExecuted = false
local hasSummonMiniBossExecuted = false
local hasBerkerkExecuted = false
function RichardHeart.CheckHealth(event, creature, world)
    local SPELLS = {41924, 64771, 69558, 63147, 51052} -- List of spell IDs

    if currentPhase == 1 then
        if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
            currentPhase = 2
        end
    end

    if currentPhase == 2 then
        local players = creature:GetPlayersInRange(30)

--[[         if not hasSummonWormExecuted then
            hasSummonWormExecuted = true
        
            local addsCount = math.random(3, 5)
            for i = 1, addsCount do
                local randomPlayer = players[math.random(1, #players)]
                local add = creature:SpawnCreature(33966, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 2, 0)
                add:AttackStart(randomPlayer)
            end
        end ]]

        local function Timed(eventid, delay, repeats, worldobject)
            print("Ran TIMED 1")
            local range = 100 -- maximum range to search for players
            local targets = worldobject:GetCreaturesInRange(range, 200008)
            local closestNPC = nil
            local closestDistance = range + 1 -- start with a value greater than the maximum range

            
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestNPC = player
                    closestDistance = distance
                end
            end

            print(worldobject:GetName())
            print(closestNPC)
            closestNPC:SendUnitYell("Seeya Bitch...",0 )
            closestNPC:MoveTo(1, 2193, 2309, closestNPC:GetZ())
          --  closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 17086, true)
        end

        local function Timed2(eventid, delay, repeats, worldobject)
            print("Ran TIMED 2")
            local range = 100 -- maximum range to search for players
            local targets = worldobject:GetCreaturesInRange(range, 200008)
            local closestNPC = nil
            local closestNPCDistance = range + 1 -- start with a value greater than the maximum range
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestNPCDistance then
                    closestNPC = player
                    closestNPCDistance = distance
                end
            end
            local range = 100 -- maximum range to search for players
            local targets = worldobject:GetPlayersInRange(range)
            local closestPlayer = nil
            local closestDistance = range + 1
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
            local vinesCount = math.random(30, 40)
            for i = 1, vinesCount do
                local vineX = closestNPC:GetX() + math.random(-5, 5)
                local vineY = closestNPC:GetY() + math.random(-5, 5)
                local vineZ = closestNPC:GetZ()
                local vine = closestNPC:SummonGameObject(175124, vineX, vineY, vineZ, closestNPC:GetO(), 0, 0, 0, 0) -- Replace 54321 with the desired game object ID for the vine
                vine:SetPhaseMask(1) -- Set the phase mask for the vines
            end
                closestNPC:AttackStart(closestPlayer)
                closestNPC:CanAggro()
                closestNPC:MoveClear(true)
        end

  
        if burstRan == false then
            world:RegisterEvent(Timed, {1000, 3000}, 1)
            burstRan = true
            world:RegisterEvent(Timed2,  {1000, 3000}, 1)
        end
        -- Run Aggro

        if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
            currentPhase = 3
            burstRan = false
        end
        print("CURRENT PHASE 2")
    end

    if currentPhase == 3 then
        -- Peace out that bitch asap nigga.
        local function Timed1(eventid, delay, repeats, worldobject)
            print("Ran TIMED 11")
            local range = 100 -- maximum range to search for players
            local targets = worldobject:GetCreaturesInRange(range, 200008)
            local closestNPC = nil
            local closestDistance = range + 1 -- start with a value greater than the maximum range
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestNPC = player
                    closestDistance = distance
                end
            end

            print(worldobject:GetName())
            print(closestNPC)
            closestNPC:SendUnitYell("Run!!",0 )
            closestNPC:MoveTo(1, 2355, 2206, closestNPC:GetZ())
          -- closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 17086, true)
              -- Activate boss's blazing fury
        end

        -- Open a can of Whoop ass
        local function Timed22(eventid, delay, repeats, worldobject)
            print("Ran TIMED 22")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200008)
            local closestNPC = nil
            local closestNPCDistance = range + 1 
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestNPCDistance then
                    closestNPC = player
                    closestNPCDistance = distance
                end
            end
            local range = 100
            local targets = worldobject:GetPlayersInRange(range)
            local closestPlayer = nil
            local closestDistance = range + 1

            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
                closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 72272, true)
                closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 69760, true)
                closestNPC:AttackStart(closestPlayer)
                closestNPC:CanAggro()
                closestNPC:MoveClear(true)
            --    closestNPC:CastSpell(closestNPC:GetVictim(), 69558, true)
        end
        if burstRan == false then

            world:RegisterEvent(Timed1, {1000, 10000}, 1)
             -- Timed Event 2
             world:RegisterEvent(Timed22, {1000, 10000}, 1)
            burstRan = true
        end

        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 4
            burstRan = false
        end
        print("CURRENT PHASE 3")
    end

    if currentPhase == 4 then
        local range = 40 -- maximum range to search for players
        local targets = creature:GetPlayersInRange(range)
        local randomPlayer = nil
    
        if #targets > 0 then
            local randomIndex = math.random(1, #targets) -- Generate a random index within the range of the targets
            randomPlayer = targets[randomIndex] -- Select the player at the random index
        end
    
        creature:AttackStart(randomPlayer)
        creature:MoveChase(randomPlayer)
        creature:CanAggro()
    
        local function Timed33(eventid, delay, repeats, worldobject)
            --print("Ran TIMED 33")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200008)
            local closestNPC = nil
            local closestNPCDistance = range + 1 
    
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestNPCDistance then
                    closestNPC = player
                    closestNPCDistance = distance
                end
            end
    
            local range = 40 -- maximum range to search for players
            local targets = worldobject:GetPlayersInRange(range)
            local randomPlayer = nil
    
            if #targets > 0 then
                local randomIndex = math.random(1, #targets) -- Generate a random index within the range of the targets
                randomPlayer = targets[randomIndex] -- Select the player at the random index
            end
    
            if closestNPC then
                closestNPC:CastSpell(randomPlayer, 69558, true)
            end
        end

        if burstRan == false and currentPhase == 4 then
            world:RegisterEvent(Timed33, 10000, 10)
            burstRan = true
        end

        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 5
            burstRan = false
        end
    
        print("CURRENT PHASE 4")
    end
    
    -- Cast the spell associated with the current phase on the boss's target
end

RegisterCreatureEvent(200008, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200008, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200008, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200008, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200008, 9, RichardHeart.CheckHealth)

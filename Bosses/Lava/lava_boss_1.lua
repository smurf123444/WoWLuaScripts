

 local RichardHeart = {}
local announcedPhase = 0
 -- Tracks the current phase
 -- Tracks the last announced phase
local currentPhase = 1
function RichardHeart.OnSpawn(event, creature)
    creature:SendUnitYell("Welcome, to pulsechain WoW!", 0)
    creature:SetWanderRadius(10)
    creature:SetAggroEnabled(false)
    creature:CanFly(true)
    creature:SetDisableGravity(true)
    creature:PerformEmote(7)
    creature:EmoteState(7)
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
    creature:AttackStart(closestPlayer)
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
function RichardHeart.CheckHealth(event, creature, world)
    local SPELLS = {41924, 64771, 64704, 63147, 51052} -- List of spell IDs

    if currentPhase == 1 then
        if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
            currentPhase = 2
        end
    end

    if currentPhase == 2 then
        local function Timed(eventid, delay, repeats, worldobject)
            local range = 100 -- maximum range to search for players
            local targets = worldobject:GetCreaturesInRange(range, 200004)
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

            closestNPC:MoveTo(1, 2193, 2309, 30)
            closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 17086, true)
        end

        local function Timed2(eventid, delay, repeats, worldobject)
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

            local npcRange = 100 -- maximum range to search for NPCs
            local npcTargets = worldobject:GetCreaturesInRange(npcRange, 200004)
            local closestNPC = nil
            local closestNPCDistance = npcRange + 1 -- start with a value greater than the maximum range

            for _, npc in ipairs(npcTargets) do
                local distance = worldobject:GetDistance(npc)
                if distance < closestNPCDistance then
                    closestNPC = npc
                    closestNPCDistance = distance
                end
            end

            print(worldobject:GetName())
            print(closestPlayer)

            if closestNPC ~= nil and closestPlayer ~= nil then
                closestNPC:AttackStart(closestPlayer)
                closestNPC:MoveChase(closestPlayer)
                closestNPC:CanAggro()
                closestNPC:MoveClear(true)
            end
        end

        -- Run Burst
        if burstRan == false then
            world:RegisterEvent(Timed, 3000, 1)
            burstRan = true
        end

        -- Run Aggro
        world:RegisterEvent(Timed2, 10000, 1)

        if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
            currentPhase = 3
            burstRan = false
        end

        local range = 40 -- maximum range to search for players
        local targets = creature:GetPlayersInRange(range)
        local randomPlayer = nil

        if #targets > 0 then
            local randomIndex = math.random(1, #targets) -- Generate a random index within the range of the targets
            randomPlayer = targets[randomIndex] -- Select the player at the random index
        end

        do
            creature:AttackStart(randomPlayer)
            creature:MoveChase(randomPlayer)
            creature:CanAggro()
        end

        print("CURRENT PHASE 2")
    end

    if currentPhase == 3 then
        local range = 40 -- maximum range to search for players
        local targets = creature:GetPlayersInRange(range)
        local randomPlayer = nil

        if #targets > 0 then
            local randomIndex = math.random(1, #targets) -- Generate a random index within the range of the targets
            randomPlayer = targets[randomIndex] -- Select the player at the random index
        end

        do
            creature:AttackStart(randomPlayer)
            creature:MoveChase(randomPlayer)
            creature:CanAggro()
        end

        creature:CastSpellAoF(creature:GetX(), creature:GetY(), creature:GetZ(), 62400, true)

        function Lava(eventid, delay, repeats, creature)
            if creature == nil then
                return
            end

            local vinesCount = math.random(4, 6)

            for i = 1, vinesCount do
                local vineX = creature:GetX() + math.random(-5, 5)
                local vineY = creature:GetY() + math.random(-5, 5)
                local vineZ = creature:GetZ()
                local vine = creature:SummonGameObject(6292, vineX, vineY, vineZ, creature:GetO(), 0, 0, 0, 0) -- Replace 6292 with the desired game object ID for the vine

                if vine ~= nil then
                    vine:SetPhaseMask(1) -- Set the phase mask for the vines
                end
            end
        end

        world:RegisterEvent(Lava, 10000, 1)

        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 4
            burstRan = false
        end
        print("CURRENT PHASE 3")
    end

    if currentPhase == 4 then
        -- Blazing Fury Phase
       -- creature:CastSpell(creature:GetVictim(),SPELLS[currentPhase], creature) -- Activate boss's blazing fury
        -- Adjust boss's attacks to deal additional fire damage
    end

    -- Cast the spell associated with the current phase on the boss's target
    creature:CastSpell(creature:GetVictim(), SPELLS[currentPhase], true)
end


RegisterCreatureEvent(200004, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200004, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200004, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200004, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200004, 9, RichardHeart.CheckHealth)

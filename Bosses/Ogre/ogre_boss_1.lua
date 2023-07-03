
 local RichardHeart = {}

local currentPhase = 1

function RichardHeart.OnSpawn(event, creature)
    creature:SendUnitYell("Welcome, to pulsechain WoW!", 0)
    creature:SetWanderRadius(10)
    creature:SetAggroEnabled(false)
    creature:CanFly(true)
    creature:SetDisableGravity(true)
    creature:PerformEmote(52)
    creature:EmoteState(52)
end

function RichardHeart.OnEnterCombat(event, creature, target)
   local range = 40 
    local targets = creature:GetPlayersInRange(range)
    local closestPlayer = nil
    local closestDistance = range + 1
    for _, player in ipairs(targets) do
        local distance = creature:GetDistance(player)
        if (distance < closestDistance) then
            closestPlayer = player
            closestDistance = distance
        end
    end
    creature:AttackStart(closestPlayer)
end


function RichardHeart.OnLeaveCombat(event, creature, world)
    local yellOptions = "Hehehe..."
    creature:PlayDirectSound(14973)
    creature:SendUnitYell(yellOptions, 0)
    creature:RemoveEvents()
end

function RichardHeart.OnDied(event, creature, killer)
    creature:SendUnitYell("Agh! Ugh.....OOhha..", 0)
    creature:PlayDirectSound(17374)
    if(killer:GetObjectType() == "Player") then
        killer:SendBroadcastMessage("You killed " ..creature:GetName().."!")
    end
    creature:RemoveEvents()
    currentPhase = 1
end

local burstRan = false
local hasSummonWormExecuted = false
function RichardHeart.CheckHealth(event, creature, world)

    if currentPhase == 1 then
        local function Awaken(eventid, delay, repeats, worldobject)
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200012)
            local closestNPC = nil
            local closestDistance = range + 1 

            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestNPC = player
                    closestDistance = distance
                end
            end
            closestNPC:SendUnitYell("Ogre 1 Awakens!", 0)
            closestNPC:PerformEmote(53)
            closestNPC:EmoteState(53)
        end
    if burstRan == false then
        world:RegisterEvent(Awaken, 3000, 1)
        burstRan = true
    end
        if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
            world:RemoveEvents()
            currentPhase = 2
            burstRan = false
        end
    end

    if currentPhase == 2 then
        local function WhirlWind(eventid, delay, repeats, worldobject)
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200012)
            local closestNPC = nil
            local closestDistance = range + 1 

            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestNPC = player
                    closestDistance = distance
                end
            end
            print(worldobject:GetName())
            print(closestNPC)
            closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 69076, true)
        end
        local function Attack(eventid, delay, repeats, worldobject)
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
            local npcRange = 100 
            local npcTargets = worldobject:GetCreaturesInRange(npcRange, 200012)
            local closestNPC = nil
            local closestNPCDistance = npcRange + 1
            for _, npc in ipairs(npcTargets) do
                local distance = worldobject:GetDistance(npc)
                if distance < closestNPCDistance then
                    closestNPC = npc
                    closestNPCDistance = distance
                end
            end
            closestNPC:PerformEmote(27)
            closestNPC:EmoteState(27)
            closestNPC:AttackStart(closestPlayer)
            closestNPC:MoveChase(closestPlayer)
            closestNPC:CanAggro()
            closestNPC:MoveClear(true)
        end
        if burstRan == false then
            world:RegisterEvent(WhirlWind, 3000, 1)
            world:RegisterEvent(Attack, 30000, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
            world:RemoveEvents()
            currentPhase = 3
            burstRan = false
        end
        print("CURRENT PHASE 2")
    end

    if currentPhase == 3 then
        function Minions(eventid, delay, repeats, worldobject)
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200012)
            local closestNPC = nil
            local closestNPCDistance = range + 1 
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestNPCDistance then
                    closestNPC = player
                    closestNPCDistance = distance
                end
            end
            if closestNPC == nil then
                return
            end
            local players = closestNPC:GetPlayersInRange(30)
            if not hasSummonWormExecuted then
                hasSummonWormExecuted = true
                local addsCount = math.random(2, 3)
                for i = 1, addsCount do
                    local randomPlayer = players[math.random(1, #players)]
                    local add = closestNPC:SpawnCreature(33966, closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), closestNPC:GetO(), 2, 0)
                    add:AttackStart(randomPlayer)
                end
            end
            local range = 100
            local targets = creature:GetPlayersInRange(range)
            local closestPlayer = nil
            local closestDistance = range + 1
            for _, player in ipairs(targets) do
                local distance = creature:GetDistance(player)
                if (distance < closestDistance) then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
            closestNPC:AttackStart(closestPlayer)
        end
        world:RegisterEvent(Minions, {3500, 4000}, 1)
        
        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            world:RemoveEvents()
            currentPhase = 4
            burstRan = false
        end
        print("CURRENT PHASE 3")
    end

    if currentPhase == 4 then
        function EnragedRampage(eventid, delay, repeats, worldobject)
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200012)
            local closestNPC = nil
            local closestNPCDistance = range + 1 
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestNPCDistance then
                    closestNPC = player
                    closestNPCDistance = distance
                end
            end
            if closestNPC == nil then
                return
            end
            closestNPC:CastSpell(closestNPC, 41924, true)
            local range = 100
            local targets = creature:GetPlayersInRange(range)
            local closestPlayer = nil
            local closestDistance = range + 1
            for _, player in ipairs(targets) do
                local distance = creature:GetDistance(player)
                if (distance < closestDistance) then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
            closestNPC:AttackStart(closestPlayer)
        end
        world:RegisterEvent(EnragedRampage, {1500, 3000}, 1)
        if creature:HealthBelowPct(20) and creature:HealthAbovePct(5) then
            world:RemoveEvents()
            currentPhase = 5
            burstRan = false
        end
        print("CURRENT PHASE 4")
    end

    if currentPhase == 5 then
        function LastStand(eventid, delay, repeats, worldobject)
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200012)
            local closestNPC = nil
            local closestNPCDistance = range + 1 
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestNPCDistance then
                    closestNPC = player
                    closestNPCDistance = distance
                end
            end
            if closestNPC == nil then
                return
            end
            closestNPC:CastSpell(closestNPC, 41924, true)
            local range = 100
            local targets = creature:GetPlayersInRange(range)
            local closestPlayer = nil
            local closestDistance = range + 1
            for _, player in ipairs(targets) do
                local distance = creature:GetDistance(player)
                if (distance < closestDistance) then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
            closestNPC:AttackStart(closestPlayer)
        end
        world:RegisterEvent(LastStand, {1500, 3000}, 1)
        if creature:HealthBelowPct(5) then
            currentPhase = 5
            burstRan = false
            world:RemoveEvents()
        end
        print("CURRENT PHASE 5")
    end
end

RegisterCreatureEvent(200012, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200012, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200012, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200012, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200012, 9, RichardHeart.CheckHealth)

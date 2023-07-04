local RichardHeart = {}

local currentPhase = 1

function RichardHeart.OnSpawn(event, creature)
    creature:SendUnitYell("Welcome, to pulsechain WoW!", 0)
    creature:SetWanderRadius(10)
    creature:CastSpell(creature, 41924, true)
end
function Strike(eventId, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 62444, true)
end

function RichardHeart.OnEnterCombat(event, creature, target)
    creature:SendUnitYell("Come to me... \"Pretender\". FEED MY BLADE!", 0)
    creature:PlayDirectSound(17242)
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
    creature:RegisterEvent(Strike, 3000, 0)
end

function RichardHeart.OnLeaveCombat(event, creature, world)
    local yellOptions = "Hehehe..."
    creature:PlayDirectSound(14973)
    creature:SendUnitYell(yellOptions, 0)
    creature:SendUnitYell("Come to me... \"Pretender\". FEED MY BLADE!", 0)
    creature:PlayDirectSound(17242)
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
    --Shattering Strikes
    if currentPhase == 1 then
        local function ShatteringStrikes(eventid, delay, repeats, worldobject)
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200014)
            local closestNPC = nil
            local closestDistance = range + 1
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestNPC = player
                    closestDistance = distance
                end
            end
            closestNPC:CastSpell(closestNPC, 52890, true)
        end
    if burstRan == false then
        creature:RegisterEvent(ShatteringStrikes, 3000, 1)
        burstRan = true
    end
        if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
            creature:RemoveEvents()
            currentPhase = 2
            burstRan = false
        end
    end
    --Earthquake Fury
    if currentPhase == 2 then
        local function Earthquake(eventid, delay, repeats, worldobject)
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200014)
            local closestNPC = nil
            local closestDistance = range + 1 
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestNPC = player
                    closestDistance = distance
                end
            end
            closestNPC:CastSpell(closestNPC, 61882, true)
            closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 61882, true)
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
            local npcTargets = worldobject:GetCreaturesInRange(npcRange, 200014)
            local closestNPC = nil
            local closestNPCDistance = npcRange + 1
            for _, npc in ipairs(npcTargets) do
                local distance = worldobject:GetDistance(npc)
                if distance < closestNPCDistance then
                    closestNPC = npc
                    closestNPCDistance = distance
                end
            end
 
            closestNPC:AttackStart(closestPlayer)
            closestNPC:CanAggro()
        end
        if burstRan == false then
            creature:RegisterEvent(Earthquake, 3000, 1)
            creature:RegisterEvent(Attack, 30000, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
            creature:RemoveEvents()
            currentPhase = 3
            burstRan = false
        end
        print("CURRENT PHASE 2")
    end
    --Minion Onslaught
    if currentPhase == 3 then
        function Minions(eventid, delay, repeats, worldobject)
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200014)
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
                local addsCount = math.random(1, 1)
                for i = 1, addsCount do
                    local randomPlayer = players[math.random(1, #players)]
                    local x, y, z = closestNPC:GetRelativePoint(math.random()*9, math.random()*math.pi*2)
                    local add = closestNPC:SpawnCreature(35314, x, y, z, closestNPC:GetO(), 2, 0)
                    add:AttackStart(randomPlayer)
                end
            end
        end
        creature:RegisterEvent(Minions, {3500, 4000}, 1)
        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            creature:RemoveEvents()
            currentPhase = 4
            burstRan = false
        end
        print("CURRENT PHASE 3")
    end
    --Unbreakable Determination
    if currentPhase == 4 then
        function EnragedRampage(eventid, delay, repeats, worldobject)
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200014)
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
        end
        creature:RegisterEvent(EnragedRampage, {1500, 3000}, 1)
        if creature:HealthBelowPct(20) and creature:HealthAbovePct(5) then
            currentPhase = 5
            burstRan = false
            creature:RemoveEvents()
        end
        print("CURRENT PHASE 4")
    end
end

RegisterCreatureEvent(200014, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200014, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200014, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200014, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200014, 9, RichardHeart.CheckHealth)
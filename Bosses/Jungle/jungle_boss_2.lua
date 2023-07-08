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
   world:RemoveEvents()
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

function RichardHeart.CheckHealth(event, creature, world)
    if currentPhase == 1 then

        local function Adds(eventid, delay, repeats, worldobject)
            local npcRange = 100 
            local npcTargets = worldobject:GetCreaturesInRange(npcRange, 200005)
            local closestNPC = nil
            local closestNPCDistance = npcRange + 1 
            for _, npc in ipairs(npcTargets) do
                local distance = worldobject:GetDistance(npc)
                if distance < closestNPCDistance then
                    closestNPC = npc
                    closestNPCDistance = distance
                end
            end
            local players = creature:GetPlayersInRange(30)
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
        if burstRan == false then
            creature:SendUnitYell("I Would like you to meet my friend... HEHEHE...",0)
            world:RegisterEvent(Adds, 3000, 1)
            burstRan = true
        end

        if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
            currentPhase = 2
            hasSummonWormExecuted = false
            burstRan = false
        end
    end

    if currentPhase == 2 then
        local function VineEntanglement(eventid, delay, repeats, worldobject)
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200002)
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
            local players = closestNPC:GetPlayersInRange(30)
            if not hasSummonWormExecuted then
                hasSummonWormExecuted = true
                local addsCount = math.random(1, 1)
                for i = 1, addsCount do
                    local randomPlayer = players[math.random(1, #players)]
                    local x, y, z = closestNPC:GetRelativePoint(math.random()*9, math.random()*math.pi*2)
                    local add = closestNPC:SpawnCreature(20779, x, y, z, closestNPC:GetO(), 2, 0)
                    add:AttackStart(randomPlayer)
                end
            end
                closestNPC:AttackStart(closestPlayer)
        end
        if burstRan == false then
            burstRan = true
            world:RegisterEvent(VineEntanglement,  {6000, 9000}, 1)
        end
        if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
            currentPhase = 3
            burstRan = false
        end
        print("CURRENT PHASE 2")
    end
    --sUMMON MINI BOSS PHASE
    if currentPhase == 3 then
        local function SummonMiniBoss(eventid, delay, repeats, worldobject)
            print("Ran AttackAgain")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200002)
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
            local players = closestNPC:GetPlayersInRange(30)
            if not hasSummonWormExecuted then
                hasSummonWormExecuted = true
                local addsCount = math.random(1, 1)
                for i = 1, addsCount do
                    local randomPlayer = players[math.random(1, #players)]
                    local x, y, z = closestNPC:GetRelativePoint(math.random()*9, math.random()*math.pi*2)
                    local add = closestNPC:SpawnCreature(20779, x, y, z, closestNPC:GetO(), 2, 0)
                    add:AttackStart(randomPlayer)
                end
            end
                closestNPC:AttackStart(closestPlayer)

        end
        if burstRan == false then
             world:RegisterEvent(SummonMiniBoss, {6000, 10000}, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 4
            hasSummonWormExecuted = false
            burstRan = false
        end
        print("CURRENT PHASE 3")
    end
    -- RAGE PHASE
    if currentPhase == 4 then

        local function CastSpells(eventid, delay, repeats, worldobject)
            print("Ran CastSpells")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200002)
            local closestNPC = nil
            local closestNPCDistance = range + 1 
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestNPCDistance then
                    closestNPC = player
                    closestNPCDistance = distance
                end
            end
            local range = 40 
            local targets = worldobject:GetPlayersInRange(range)
            local randomPlayer = nil
            if #targets > 0 then
                local randomIndex = math.random(1, #targets) 
                randomPlayer = targets[randomIndex] 
            end

                closestNPC:CastSpell(randomPlayer, 69558, true)

        end
        if burstRan == false and currentPhase == 4 then
            world:RegisterEvent(CastSpells, 1000, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 5
           world:RemoveEvents()
            burstRan = false
        end
        print("CURRENT PHASE 4")
    end
end

RegisterCreatureEvent(200002, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200002, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200002, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200002, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200002, 9, RichardHeart.CheckHealth)

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
        -- Assault Bot Phase
        if currentPhase == 1 then
            local function Burst(eventid, delay, repeats, worldobject)
                local range = 100 
                local targets = worldobject:GetCreaturesInRange(range, 200006)
                local closestNPC = nil
                local closestDistance = range + 1 
                for _, player in ipairs(targets) do
                    local distance = worldobject:GetDistance(player)
                    if distance < closestDistance then
                        closestNPC = player
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
                        local add = closestNPC:SpawnCreature(34057, x, y, z, closestNPC:GetO(), 2, 0)
                        add:AttackStart(randomPlayer)
                    end
                end
            end
            if burstRan == false then
                creature:SendUnitYell("ASSAULT BOTS ... ATTACK!!! (7 sec)",0)
                world:RegisterEvent(Burst, 7000, 1)
                
                burstRan = true
            end
            if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
                currentPhase = 2
                hasSummonWormExecuted = false
            end
        end
        --Tower Defense Phase
        if currentPhase == 2 then
            local function Tremor(eventid, delay, repeats, worldobject)
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
                local npcTargets = worldobject:GetCreaturesInRange(npcRange, 200006)
                local closestNPC = nil
                local closestNPCDistance = npcRange + 1 
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
            world:RegisterEvent(Tremor, 10000, 1)
            local range = 40
            local targets = creature:GetPlayersInRange(range)
            local randomPlayer = nil
            if #targets > 0 then
                local randomIndex = math.random(1, #targets) 
                randomPlayer = targets[randomIndex]
            end
            do
                creature:AttackStart(randomPlayer)
                creature:MoveChase(randomPlayer)
                creature:CanAggro()
            end
            if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
                currentPhase = 3
                burstRan = false
            end
            print("CURRENT PHASE 2")
        end
        --Demolisher/Siege Vehicle Detonation
        if currentPhase == 3 then
            local range = 40
            local targets = creature:GetPlayersInRange(range)
            local randomPlayer = nil
            if #targets > 0 then
                local randomIndex = math.random(1, #targets)
                randomPlayer = targets[randomIndex]
            end
            do
                creature:AttackStart(randomPlayer)
                creature:MoveChase(randomPlayer)
                creature:CanAggro()
            end
            function Lava(eventid, delay, repeats, worldobject)
                local range = 100 
                local targets = worldobject:GetCreaturesInRange(range, 200006)
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
                local vinesCount = math.random(4, 6)
                for i = 1, vinesCount do
                    local vineX = closestNPC:GetX() + math.random(-5, 5)
                    local vineY = closestNPC:GetY() + math.random(-5, 5)
                    local vineZ = closestNPC:GetZ()
                    local vine = closestNPC:SummonGameObject(194952, vineX, vineY, vineZ, closestNPC:GetO(), 0, 0, 0, 0)
                    vine:SetPhaseMask(1)
                end
                closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 62400, true)
            end
            if burstRan == false then
                creature:SendUnitYell("EAT FIRE ... HEHEHE!!! (7 sec)",0)
                world:RegisterEvent(Lava, {1000, 4000}, 1)
                burstRan = true
            end
            if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
                currentPhase = 4
                burstRan = false
               world:RemoveEvents()
            end
            print("CURRENT PHASE 3")
        end
        -- Mounted Assault
        if currentPhase == 4 then
            function MountedAssault(eventid, delay, repeats, worldobject)
                local range = 100 
                local targets = worldobject:GetCreaturesInRange(range, 200006)
                local closestNPC = nil
                local closestNPCDistance = range + 1 
                for _, player in ipairs(targets) do
                    local distance = worldobject:GetDistance(player)
                    if distance < closestNPCDistance then
                        closestNPC = player
                        closestNPCDistance = distance
                    end
                end
                local players = closestNPC:GetPlayersInRange(30)
                if not hasSummonWormExecuted then
                    hasSummonWormExecuted = true
                    local addsCount = math.random(1, 1)
                    for i = 1, addsCount do
                        local randomPlayer = players[math.random(1, #players)]
                        local x, y, z = closestNPC:GetRelativePoint(math.random()*9, math.random()*math.pi*2)
                        local add = closestNPC:SpawnCreature(39173, x, y, z, closestNPC:GetO(), 2, 0)
                        add:AttackStart(randomPlayer)
                    end
                end
            end

            if burstRan == false then
                creature:SendUnitYell("EAT FIRE ... HEHEHE!!! (7 sec)",0)
                world:RegisterEvent(MountedAssault, {1000, 4000}, 1)
                burstRan = true
            end
            if creature:HealthBelowPct(20) and creature:HealthAbovePct(5) then
                currentPhase = 5
                burstRan = false
               world:RemoveEvents()
            end
            print("CURRENT PHASE 3")
        end
    end

RegisterCreatureEvent(200006, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200006, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200006, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200006, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200006, 9, RichardHeart.CheckHealth)

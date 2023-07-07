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

    if currentPhase == 1 then
        local function SpawnAdds(eventid, delay, repeats, worldobject)
            local range = 40 
            local targets = worldobject:GetPlayersInRange(range)
            local randomPlayer = nil
                if #targets > 0 then
                    local randomIndex = math.random(1, #targets) 
                    randomPlayer = targets[randomIndex] 
                end
                local range = 100
                local targets = worldobject:GetCreaturesInRange(range, 200010)
                local closestNPC = nil
                local closestNPCDistance = range + 1 
                for _, player in ipairs(targets) do
                    local distance = worldobject:GetDistance(player)
                    if distance < closestNPCDistance then
                        closestNPC = player
                        closestNPCDistance = distance
                    end
                end
                local addsCount = math.random(2, 3)
                for i = 1, addsCount do
                    local add = closestNPC:SpawnCreature(33966, closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), closestNPC:GetO(), 2, 0)
                    add:AttackStart(randomPlayer)
                end
        end
        print("CURRENT PHASE 1")
        if burstRan == false then
            burstRan = true
            world:RegisterEvent(SpawnAdds, {1000, 3000}, 1)
        end
        if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
            currentPhase = 2
            burstRan = false
        end
    end

    if currentPhase == 2 then
        local function SpawnGameObjects(eventid, delay, repeats, worldobject)
            
            print("Ran Attack")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200009)
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
            local vinesCount = math.random(90, 100)
            for i = 1, vinesCount do
                local vineX = closestNPC:GetX() + math.random(-10, 10)
                local vineY = closestNPC:GetY() + math.random(-10, 10)
                local vineZ = closestNPC:GetZ()
                local vine = closestNPC:SummonGameObject(181031, vineX, vineY, vineZ, closestNPC:GetO(), 0, 0, 0, 0)
                vine:SetPhaseMask(1)
            end
                closestNPC:SendUnitYell("Lets Fight! Bitch...",0 )
                closestNPC:AttackStart(closestPlayer)
                closestNPC:CanAggro()
        end
        if burstRan == false then
            burstRan = true
            world:RegisterEvent(SpawnGameObjects,  {1000, 3000}, 1)
        end
        if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
            currentPhase = 3
            burstRan = false

        end
        print("CURRENT PHASE 2")
    end
    --SPORES
    if currentPhase == 3 then
        local function Spores(eventid, delay, repeats, worldobject)
            print("Ran MoveAgain ")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200009)
            local closestNPC = nil
            local closestDistance = range + 1 
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestNPC = player
                    closestDistance = distance
                end
            end
            local vinesCount = math.random(15, 20)
            for i = 1, vinesCount do
                local vineX = closestNPC:GetX() + math.random(-10, 10)
                local vineY = closestNPC:GetY() + math.random(-10, 10)
                local vineZ = closestNPC:GetZ()
                local vine = closestNPC:SummonGameObject(178561, vineX, vineY, vineZ, closestNPC:GetO(), 0, 0, 0, 0)
                vine:SetPhaseMask(1)
            end
        end
        local function AttackAgain(eventid, delay, repeats, worldobject)
            print("Ran AttackAgain")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200009)
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
            local vinesCount = math.random(90, 100)
            for i = 1, vinesCount do
                local vineX = closestNPC:GetX() + math.random(-30, 30)
                local vineY = closestNPC:GetY() + math.random(-30, 30)
                local vineZ = closestNPC:GetZ()
                local vine = closestNPC:SummonGameObject(175124, vineX, vineY, vineZ, closestNPC:GetO(), 0, 0, 0, 0)
                vine:SetPhaseMask(1)
            end
                closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 72272, true)
                closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 69760, true)
                closestNPC:AttackStart(closestPlayer)
                closestNPC:CanAggro()
        end
        if burstRan == false then
            world:RegisterEvent(Spores, {1000, 5000}, 1)
             world:RegisterEvent(AttackAgain, {6000, 10000}, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 4

            burstRan = false
        end
        print("CURRENT PHASE 3")
    end
    --MINI BOSS PHASE
    if currentPhase == 4 then
        local range = 40
        local targets = creature:GetPlayersInRange(range)
        local randomPlayer = nil
        if #targets > 0 then
            local randomIndex = math.random(1, #targets) 
            randomPlayer = targets[randomIndex] 
        end
        creature:AttackStart(randomPlayer)
        creature:MoveChase(randomPlayer)
        creature:CanAggro()
        local function CastSpells(eventid, delay, repeats, worldobject)
            print("Ran CastSpells")
            local range = 40 
            local targets = worldobject:GetPlayersInRange(range)
            local randomPlayer = nil
            if #targets > 0 then
                local randomIndex = math.random(1, #targets) 
                randomPlayer = targets[randomIndex] 
            end
            if not hasSummonWormExecuted then
                hasSummonWormExecuted = true
                local addsCount = math.random(1, 2)
                local centerX = 2205
                local centerY = 2329
                for i = 1, addsCount do
                    local offsetX = math.random(-15, 15)
                    local offsetY = math.random(-15, 15)
                    local objectX = centerX + offsetX
                    local objectY = centerY + offsetY
                    local add = creature:SpawnCreature(33966, objectX, objectY, creature:GetZ(), creature:GetO(), 2, 0)
                    add:AttackStart(randomPlayer)
                end
            end
        end
        if burstRan == false and currentPhase == 4 then
            world:RegisterEvent(CastSpells, 10000, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(20) and creature:HealthAbovePct(5) then
            currentPhase = 5
            burstRan = false
           world:RemoveEvents()
        end
        print("CURRENT PHASE 4")
    end
end

RegisterCreatureEvent(200009, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200009, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200009, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200009, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200009, 9, RichardHeart.CheckHealth)

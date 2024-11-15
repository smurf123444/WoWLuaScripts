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
function RichardHeart.CheckHealth(event, creature, world)
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
            local addsCount = math.random(2, 3)
                for i = 1, addsCount do
                    local add = closestNPC:SpawnCreature(33966, closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), closestNPC:GetO(), 2, 0)
                    add:AttackStart(randomPlayer)
                end
        end
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
        --Game Objects Appear
        local function GameObjects(eventid, delay, repeats, worldobject)
            print("Ran Attack")
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
            local vinesCount = math.random(30, 40)
            for i = 1, vinesCount do
                local vineX = closestNPC:GetX() + math.random(-5, 5)
                local vineY = closestNPC:GetY() + math.random(-5, 5)
                local vineZ = closestNPC:GetZ()
                local vine = closestNPC:SummonGameObject(175124, vineX, vineY, vineZ, closestNPC:GetO(), 0, 0, 0, 0)
                vine:SetPhaseMask(1) 
            end
                closestNPC:AttackStart(closestPlayer)
        end

        if burstRan == false then
            world:RegisterEvent(GameObjects,  {1000, 3000}, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
            currentPhase = 3
            burstRan = false
        end
        print("CURRENT PHASE 2")
    end

    if currentPhase == 3 then
        local function MoveAgain(eventid, delay, repeats, worldobject)
            print("Ran TIMED 11")
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200008)
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
            closestNPC:SendUnitYell("Run!!",0 )
            closestNPC:MoveTo(1, 76, 62, closestNPC:GetZ())
        end
        local function AttackAgain(eventid, delay, repeats, worldobject)
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
        end
        if burstRan == false then
            world:RegisterEvent(MoveAgain, {1000, 5000}, 1)
            world:RegisterEvent(AttackAgain, {6000, 10000}, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 4
            burstRan = false
        end
        print("CURRENT PHASE 3")
    end

    if currentPhase == 4 then

        local function CastSpells(eventid, delay, repeats, worldobject)
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
            world:RegisterEvent(CastSpells, 10000, 10)
            burstRan = true
        end
        if creature:HealthBelowPct(20) and creature:HealthAbovePct(5) then
            currentPhase = 5
            burstRan = false
           world:RemoveEvents()
        end
        print("CURRENT PHASE 4")
        if creature:HealthBelowPct(20) and creature:HealthAbovePct(5) then
            currentPhase = 5
            world:RemoveEvents()
            burstRan = false
        end
    end
end

RegisterCreatureEvent(200008, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200008, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200008, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200008, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200008, 9, RichardHeart.CheckHealth)

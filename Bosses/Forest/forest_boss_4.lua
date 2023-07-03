local RichardHeart = {}

local currentPhase = 1

function RichardHeart.OnSpawn(event, creature)
    creature:SendUnitYell("Welcome, to pulsechain WoW!", 0)
    creature:SetWanderRadius(10)
    creature:CastSpell(creature, 41924, true)
end

function RichardHeart.OnEnterCombat(event, creature, target)
    creature:SendUnitYell("Come to me... \"Pretender\". FEED MY BLADE!", 0)
    creature:PlayDirectSound(17242) 
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
        if burstRan == false then
            burstRan = true
            world:RegisterEvent(SpawnAdds, {1000, 3000}, 1)
        end
        if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
            currentPhase = 2
            world:RemoveEvents()
        end
    end
    if currentPhase == 2 then
        --SUMMON TOTEMS PHASE
        local function Attack(eventid, delay, repeats, worldobject)
            print("Ran Attack")
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
                closestNPC:AttackStart(closestPlayer)
                closestNPC:CanAggro()
                closestNPC:MoveClear(true)
                closestNPC:CastSpell(closestNPC:GetVictim(), 65995, true)
                closestNPC:CastSpell(closestNPC:GetVictim(), 65995, true)
                closestNPC:CastSpell(closestNPC:GetVictim(), 65995, true)
        end
        if burstRan == false then
            burstRan = true
            world:RegisterEvent(Attack,  {6000, 9000}, 1)
        end
    end
        if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
            currentPhase = 3
            world:RemoveEvents()
            burstRan = false
        end
        print("CURRENT PHASE 2")
    --STAMPEDE PHASE
    if currentPhase == 3 then
        local function STAMPEDE(eventid, delay, repeats, worldobject)
            print("Ran MoveAgain ")
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200010)
            local closestNPC = nil
            local closestDistance = range + 1 
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestNPC = player
                    closestDistance = distance
                end
            end
         closestNPC:CastSpell(closestNPC:GetVictim(), 55221, true)
        end
        local function AttackAgain(eventid, delay, repeats, worldobject)
            print("Ran AttackAgain")
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
                closestNPC:AttackStart(closestPlayer)
                closestNPC:CanAggro()
                closestNPC:MoveClear(true)
        end
        if burstRan == false then
            world:RegisterEvent(STAMPEDE, {1000, 5000}, 1)
            world:RegisterEvent(AttackAgain, {6000, 10000}, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 4
            world:RemoveEvents()
            burstRan = false
        end
        print("CURRENT PHASE 3")
    end
    --FRENZY PHASE
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
        local function FRENZY(eventid, delay, repeats, worldobject)
            print("Ran CastSpells")
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
                closestNPC:CastSpell(closestNPC, 39249, true)
        end
        if burstRan == false and currentPhase == 4 then
            world:RegisterEvent(FRENZY, 1000, 1)
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

RegisterCreatureEvent(200010, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200010, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200010, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200010, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200010, 9, RichardHeart.CheckHealth)

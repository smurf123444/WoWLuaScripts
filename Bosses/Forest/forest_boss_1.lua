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

    if currentPhase == 1 then
        local function Move(eventid, delay, repeats, worldobject)
            print("Move")
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200007)
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
            closestNPC:SendUnitYell("Seeya Bitch...",0 )
            closestNPC:MoveTo(1, 2193, 2309, closestNPC:GetZ())
        end
        if burstRan == false then
            world:RegisterEvent(Move, 3000, 1)
            burstRan = true
        end

        if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
            currentPhase = 2
           world:RemoveEvents()
        end
    end

    if currentPhase == 2 then
        local function Attack(eventid, delay, repeats, worldobject)
            print("Attack")
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200007)
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
            if closestPlayer ~= nil then
                closestNPC:AttackStart(closestPlayer)
                closestNPC:CanAggro()
                closestNPC:MoveClear(true)
            end
        end
        if burstRan == false then
            world:RegisterEvent(Attack, 10000, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
            currentPhase = 3
            burstRan = false
           world:RemoveEvents()
        end
        print("CURRENT PHASE 2")
    end

    if currentPhase == 3 then
        local function MoveAgain(eventid, delay, repeats, worldobject)
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200007)
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
            closestNPC:MoveTo(1, 2355, 2206, closestNPC:GetZ())
        end
        local function AttackAgain(eventid, delay, repeats, worldobject)
            print("Ran AttackAgain")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200007)
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
            world:RegisterEvent(MoveAgain, {1000, 6000}, 1)
             world:RegisterEvent(AttackAgain, {9000, 10000}, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 4
            burstRan = false
           world:RemoveEvents()
        end
        print("CURRENT PHASE 3")
    end

    if currentPhase == 4 then
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
        local function CastSpells(eventid, delay, repeats, worldobject)
            print("Ran CastSpells")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200007)
            local closestNPC = nil
            local closestNPCDistance = range + 1 
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestNPCDistance then
                    closestNPC = player
                    closestNPCDistance = distance
                end
            end
             closestNPC:CastSpell(closestNPC:GetVictim(), 69558, true)
        end
        if burstRan == false then
            world:RegisterEvent(CastSpells, {9500, 10000}, 10)
            burstRan = true
        end
        print("CURRENT PHASE 4")
        if creature:HealthBelowPct(20) and creature:HealthAbovePct(5) then
            currentPhase = 5
           world:RemoveEvents()
            burstRan = false
        end
    end
end

RegisterCreatureEvent(200007, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200007, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200007, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200007, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200007, 9, RichardHeart.CheckHealth)

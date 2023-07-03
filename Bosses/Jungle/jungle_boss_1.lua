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
    --(Transform & Movement Phase):
    if currentPhase == 1 then
        local function Move(eventid, delay, repeats, worldobject)
            print("Ran Move")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200001)
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
          --  closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 17086, true)
        end
        if burstRan == false then
            world:RegisterEvent(Move, {1000, 3000}, 1)
            burstRan = true
        end
        if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
            world:RemoveEvents()
            currentPhase = 2
        end
    end
    --(Hazard Phase):
    if currentPhase == 2 then
        local function Attack(eventid, delay, repeats, worldobject)
            print("Ran Attack")
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200011)
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
                local vine = closestNPC:SummonGameObject(175124, vineX, vineY, vineZ, closestNPC:GetO(), 0, 0, 0, 0) 
                vine:SetPhaseMask(1)
            end
            local range = 40 
            local targets = closestNPC:GetPlayersInRange(range)
            local randomPlayer = nil
            if #targets > 0 then
                local randomIndex = math.random(1, #targets)
                randomPlayer = targets[randomIndex] 
            end
            closestNPC:AttackStart(randomPlayer)
            closestNPC:MoveChase(randomPlayer)
            closestNPC:CanAggro()
            closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 57095, true)
            closestNPC:CastSpell(randomPlayer, 57095, true)
            closestNPC:AttackStart(closestPlayer)
            closestNPC:CanAggro()
            closestNPC:MoveClear(true)
        end
        if burstRan == false then
            world:RegisterEvent(Move, {1000, 3000}, 1)
            burstRan = true
            world:RegisterEvent(Attack,  {6000, 9000}, 1)
        end
        if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then
            currentPhase = 3
            world:RemoveEvents()
            burstRan = false
        end
        print("CURRENT PHASE 2")
    end
    --PUZZLE PHASE
    if currentPhase == 3 then
        local function MoveAgain(eventid, delay, repeats, worldobject)
            print("Ran MoveAgain ")
            local range = 100
            local targets = worldobject:GetCreaturesInRange(range, 200001)
            local closestNPC = nil
            local closestDistance = range + 1
            for _, player in ipairs(targets) do
                local distance = worldobject:GetDistance(player)
                if distance < closestDistance then
                    closestNPC = player
                    closestDistance = distance
                end
            end
            local vinesCount = math.random(90, 100)
            for i = 1, vinesCount do
                local vineX = closestNPC:GetX() + math.random(-10, 10)
                local vineY = closestNPC:GetY() + math.random(-10, 10)
                local vineZ = closestNPC:GetZ()
                local vine = closestNPC:SummonGameObject(175124, vineX, vineY, vineZ, closestNPC:GetO(), 0, 0, 0, 0)
                vine:SetPhaseMask(1)
            end
        end
        -- Open a can of Whoop ass
        local function AttackAgain(eventid, delay, repeats, worldobject)
            print("Ran AttackAgain")
            local range = 100 
            local targets = worldobject:GetCreaturesInRange(range, 200001)
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
            world:RegisterEvent(MoveAgain, {1000, 5000}, 1)
             world:RegisterEvent(AttackAgain, {6000, 10000}, 1)
            burstRan = true
        end

        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 4
            burstRan = false
            world:RemoveEvents()
        end
        print("CURRENT PHASE 3")
    end
end


RegisterCreatureEvent(200001, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200001, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200001, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200001, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200001, 9, RichardHeart.CheckHealth)

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
function RichardHeart.CheckHealth(event, creature, world)
        -- (Transform & Movement Phase):
        if currentPhase == 1 then
            creature:SendUnitYell("Prepare for DOOM! (7 sec)",0)
            local function Burst(eventid, delay, repeats, worldobject)
                local range = 100 
                local targets = worldobject:GetCreaturesInRange(range, 200005)
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
                closestNPC:MoveTo(1, 2193, 2309, 30)
                closestNPC:CastSpellAoF(closestNPC:GetX(), closestNPC:GetY(), closestNPC:GetZ(), 17086, true)
            end
            if burstRan == false then
                world:RegisterEvent(Burst, 7000, 1)
                burstRan = true
            end
            if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
                world:RemoveEvents()
                currentPhase = 2
            end
        end
        --Weather Change
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
                world:RemoveEvents()
                currentPhase = 3
                burstRan = false
            end
            print("CURRENT PHASE 2")
        end
        --Walk inside Building
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
            creature:CastSpellAoF(creature:GetX(), creature:GetY(), creature:GetZ(), 62400, true)
            function Lava(eventid, delay, repeats, worldobject)
                local range = 100 
                local targets = worldobject:GetCreaturesInRange(range, 200005)
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
            end
            world:RegisterEvent(Lava, {9500, 10000}, 10)
            if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
                
                currentPhase = 4
                burstRan = false
                world:RemoveEvents()
            end
            print("CURRENT PHASE 3")
        end
        -- Close door behind, unleash hell
        if currentPhase == 4 then
        end
end

RegisterCreatureEvent(200005, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200005, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200005, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200005, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200005, 9, RichardHeart.CheckHealth)

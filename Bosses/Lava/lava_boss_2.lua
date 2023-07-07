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
function RichardHeart.CheckHealth(event, creature, world)
        -- (Transform & Movement Phase):
        if currentPhase == 1 then

            local function MoveToDoor(eventid, delay, repeats, worldobject)
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
                closestNPC:MoveTo(1, 2199, 2320, 25)
            end
            if burstRan == false then
                creature:SendUnitYell("Come and Catch me bitch",0)
                world:RegisterEvent(MoveToDoor, 1000, 1)
                burstRan = true
            end
            if creature:HealthBelowPct(80) and creature:HealthAbovePct(61) then
                currentPhase = 2
            end
        end
        --Weather Change
        if currentPhase == 2 then
            local gameObjectsInRange = world:GetNearObject( 100, 0 , 13965 )
            gameObjectsInRange:SetGoState( 0 )

--[[             if burstRan == false then
                world:RegisterEvent(OpenDoor, 10000, 1)
                burstRan = true
            end ]]
            if creature:HealthBelowPct(60) and creature:HealthAbovePct(41) then

                currentPhase = 3
                burstRan = false
            end
            print("CURRENT PHASE 2")
        end
        --Walk inside Building
        if currentPhase == 3 then

            function GetInside(eventid, delay, repeats, worldobject)
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
                closestNPC:MoveTo(1, 2205, 2329, 25)
            end
            if burstRan == false then
                world:RegisterEvent(GetInside, {1000, 3000}, 1)
                burstRan = true
            end

        if creature:HealthBelowPct(40) and creature:HealthAbovePct(21) then
            currentPhase = 4
            burstRan = false

        end
            print("CURRENT PHASE 3")
        end
        -- Close door behind, unleash hell
        if currentPhase == 4 then

            function CloseDoorBehind(eventid, delay, repeats, worldobject)
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
                local gameObjectsInRange = worldobject:GetNearObject( 100, 0 , 13965 )
                gameObjectsInRange:SetGoState( 1 )
                local vinesCount = math.random(4, 6)
                local centerX = 2205
                local centerY = 2329
                for i = 1, vinesCount do
                    local offsetX = math.random(-15, 15)
                    local offsetY = math.random(-15, 15)
                    local objectX = centerX + offsetX
                    local objectY = centerY + offsetY
                    local vineZ = closestNPC:GetZ()
                    local vine = closestNPC:SummonGameObject(194952, objectX, objectY, vineZ, closestNPC:GetO(), 0, 0, 0, 0)
                    vine:SetPhaseMask(1)
                end
            end

            if burstRan == false then
                world:RegisterEvent(CloseDoorBehind, {1000, 3000}, 1)
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

RegisterCreatureEvent(200005, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200005, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200005, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200005, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200005, 9, RichardHeart.CheckHealth)

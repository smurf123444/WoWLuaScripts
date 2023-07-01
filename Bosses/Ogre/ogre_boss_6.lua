--[[ local RichardHeart = {}
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

function RichardHeart.SummonHounds(creature, target)
    local x, y, z = creature:GetRelativePoint(math.random()*9, math.random()*math.pi*2)
    local hound = creature:SpawnCreature(37098, x, y, z + 5, 0, 2, 300000)
    hound:AttackStart(target)
end

function RichardHeart.SpawnHounds(event, delay, pCall, creature)
    local range = 40 -- maximum range to search for players
    local targets = creature:GetPlayersInRange(range)
    local closestPlayer = nil
    local closestDistance = range + 1 -- start with a value greater than the maximum range
    for _, player in ipairs(targets) do
        local distance = creature:GetDistance(player)
        if (distance < closestDistance) then
            closestPlayer = player
            closestDistance = distance
        end
    end
  --  creature:AttackStart(closestPlayer) -- attack the closest player
    print("Closest player:", closestPlayer)
    RichardHeart.SummonHounds(creature, closestPlayer)

    creature:RegisterEvent(RichardHeart.SpawnHounds, 45000, 1)
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
end
local hazardGuid = nil
function RichardHeart.CheckHealth(event, creature, world)
   -- local SPELLS = {0, 0, 47541, 71844, 51052, 73912, 0, 72762, 0, 50980} -- List of spell IDs
    local SPELLS = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0} -- List of spell IDs
    local PHASES = {"", "Phase 2", "Phase 3", "Phase 4",} -- List of phase names

    if currentPhase == 1 then
        creature:MoveTo(1, -9118, 395, 92)
        local smokeEffect = creature:SpawnCreature(29939, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 2, 0)
        smokeEffect:CastSpell(smokeEffect, 6524, true)
        smokeEffect:DespawnOrUnsummon(5000) 
        creature:SetDisplayId(18792) 
    end

    if currentPhase == 2 then
        local map = world:GetMap()
        map:SetWeather(12, 90, 1)
    end
        -- Puzzle Phase
        -- Set up the puzzle and conditions to solve it
    if currentPhase == 3 then

        local puzzleSolved = false
        local nearestGameObject = creature:GetNearestGameObject( 10, 138493 )
        print(nearestGameObject)
          nearestGameObject:SetGoState(0)
        if puzzleSolved then
            creature:CastSpell(creature:GetVictim(), SPELLS[currentPhase], true) 
        else
        end
    end


    if currentPhase == 4 and not soundPlayed then
        world:PlayDirectSound(17247)
        soundPlayed = true
        creature:MoveTo(1, -9111, 402, 92)
    end


    if currentPhase > 1 and currentPhase < #PHASES and currentPhase ~= announcedPhase then
        creature:SendUnitYell(PHASES[currentPhase].." begins!", 0)
        world:PlayDirectSound(17258)
        announcedPhase = currentPhase
    elseif currentPhase == #PHASES and announcedPhase ~= #PHASES then
        creature:SendUnitYell(PHASES[currentPhase].."! It's over 9000!!!", 0)
        announcedPhase = #PHASES

        local map = world:GetMap()
  
        map:SetWeather(12, 0, 0) 

        local smokeEffect = creature:SpawnCreature(29939, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 2, 0)
        smokeEffect:CastSpell(smokeEffect, 6524, true) 
        smokeEffect:DespawnOrUnsummon(5000)

        creature:SetDisplayId(27061) 


    end

    creature:CastSpell(creature:GetVictim(), SPELLS[currentPhase], true)
end



RegisterCreatureEvent(200001, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200001, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200001, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200001, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200001, 9, RichardHeart.CheckHealth)
 ]]
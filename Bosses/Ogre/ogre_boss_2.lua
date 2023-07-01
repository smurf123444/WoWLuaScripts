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
    local PHASES = {"", "Phase 2", "Phase 3", "Phase 4", "Phase 5", "Phase 6", "Phase 7", "Phase 8", "Phase 9", "Phase 10"} -- List of phase names
 
    for i=#PHASES, 2, -1 do
     
        if creature:HealthBelowPct((#PHASES - i + 1) * 10) then
            world:PlayDirectSound(17257)
            currentPhase = i
            break
        end
    end

    if currentPhase == 4 then
        local player = creature:GetVictim()
        creature:MoveTo(1, -9118, 395, 92)
        --wait 2 sec 

        --perform emote
       
       -- player:MoveFollow(creature, 5)
        -- Add a puff of smoke effect
        local smokeEffect = creature:SpawnCreature(29939, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 2, 0)
        smokeEffect:CastSpell(smokeEffect, 6524, true) -- 6524 is the ID of the smoke effect spell
        smokeEffect:DespawnOrUnsummon(5000) -- Make the smoke effect despawn after 5 seconds

        -- Transform the boss model
        creature:SetDisplayId(18792) -- Replace 18792 with the display ID of the desired transformed model

        -- Add new abilities or mechanics for the Transformation Phase
        -- Example: creature:CastSpell(player, SPELLS[currentPhase], true)
    end

    if currentPhase == 6 then
        -- Environmental Phase
        -- Create hazards or change the terrain of the battlefield
        
        -- Example: Summon an environmental hazard
       -- local hazard = creature:SummonGameObject(194635, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 0, 0, 0, 0) -- Replace 12345 with the desired game object ID
      --  hazard:SetGoState(1)-- Activate the hazard
      
     --   hazard:SetPhaseMask(1)
        local map = world:GetMap()
    
        -- Example: Modify the terrain
          map:SetWeather(12, 90, 1) -- Replace the coordinates with the desired values to modify the terrain
    --    hazard:UseDoorOrButton( 10000 )-- Activate the hazard
        -- Additional environmental phase mechanics can be added here
    end


    if currentPhase == 8 then
        -- Puzzle Phase
        -- Set up the puzzle and conditions to solve it
    
        local puzzleSolved = false
       -- local hazard = creature:SummonGameObject(194635, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 0, 0, 0, 0)-- Activate the hazard
        -- Example: Check if the puzzle is solved
        local nearestGameObject = creature:GetNearestGameObject( 10, 138493 )
        print(nearestGameObject)
        --nearestGameObject:RemoveFromWorld(true)-- Activate the hazard
          nearestGameObject:SetGoState(0)-- Activate the hazard
        --  nearestGameObject:SetPhaseMask(0)
        if puzzleSolved then
            -- Proceed to the next phase or perform a transition
            creature:CastSpell(creature:GetVictim(), SPELLS[currentPhase], true) -- Cast a spell on the player to initiate the next phase
        else
            -- Puzzle is not solved, apply mechanics or penalties
            -- Example: Restrict player movement or abilities

        end

        -- Additional puzzle phase mechanics can be added here
    end


    if currentPhase == 9 and not soundPlayed then
        world:PlayDirectSound(17247)
        soundPlayed = true
        creature:MoveTo(1, -9111, 402, 92)
    end

    -- Announce the current phase if it hasn't been announced yet
    if currentPhase > 1 and currentPhase < #PHASES and currentPhase ~= announcedPhase then
        creature:SendUnitYell(PHASES[currentPhase].." begins!", 0)
        world:PlayDirectSound(17258)
        announcedPhase = currentPhase
    elseif currentPhase == #PHASES and announcedPhase ~= #PHASES then
        creature:SendUnitYell(PHASES[currentPhase].."! It's over 9000!!!", 0) -- Special message for the final phase
        announcedPhase = #PHASES
        local map = world:GetMap()
        -- Example: Modify the terrain
        map:SetWeather(12, 0, 0) 
        -- Add a puff of smoke effect
        local smokeEffect = creature:SpawnCreature(29939, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 2, 0)
        smokeEffect:CastSpell(smokeEffect, 6524, true) -- 6524 is the ID of the smoke effect spell
        smokeEffect:DespawnOrUnsummon(5000) -- Make the smoke effect despawn after 5 seconds

        -- Transform the boss model
        creature:SetDisplayId(27061) -- Replace 30721 with the display ID of the desired final form model
    end

    -- Cast the spell associated with the current phase
    creature:CastSpell(creature:GetVictim(), SPELLS[currentPhase], true)
end



RegisterCreatureEvent(200001, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200001, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200001, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200001, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200001, 9, RichardHeart.CheckHealth)
 ]]
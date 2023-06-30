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
local hasSummonWormExecuted = false
local hasSummonMiniBossExecuted = false
local hasBerkerkExecuted = false
function RichardHeart.CheckHealth(event, creature, world)
    local SPELLS = {41924, 64771, 64704, 63147, 51052, 63830, 63830, 64189, 64163, 50980} -- List of spell IDs
    local PHASES = {"", "Phase 2", "Toxic Cloud Phase", "Phase 4", "Summon Totems Phase", "Phase 6", "Stampede Phase", "Phase 8", "Frenzy Phase", "Final Phase"} -- List of phase names
    local announcedPhase = 0 -- Variable to track the last announced phase
    local currentPhase -- Variable to store the current phase

    for i = #PHASES, 2, -1 do
        if creature:HealthBelowPct((#PHASES - i + 1) * 10) then
            world:PlayDirectSound(17257)
            currentPhase = i
            break
        end
    end

    if currentPhase == 3 then
        -- Toxic Cloud Phase
        creature:CastSpellArea(creature:GetPosition(), SPELLS[currentPhase], true) -- Release toxic cloud in the arena
        creature:GetVictim():AddAura(SPELLS[currentPhase], creature) -- Apply debuff to players caught in the cloud
    end

    if currentPhase == 5 then
        -- Summon Totems Phase
        creature:CastSpell(creature:GetGUIDLow(), 16190, true) 
       -- creature:SummonCreature(12345, creature:GetPosition()) -- Summon totems around the arena
        -- Handle totem effects and interactions
        -- (e.g., healing boss, applying debuffs, buffing boss's damage)
    end

    if currentPhase == 7 then
        -- Stampede Phase
        creature:CastSpellArea(creature:GetPosition(), SPELLS[currentPhase], true) -- Create damaging energy trail
        -- Handle boss's charge ability and player movement
    end

    if currentPhase == 9 then
        -- Frenzy Phase
        creature:SetUnitFlags(UNIT_FLAG_FRENZIED) -- Set boss's frenzy state
        -- Handle boss's increased attack speed and movement speed
    end

    if currentPhase > 1 and currentPhase < #PHASES and currentPhase ~= announcedPhase then
        world:SendUnitYell("Entering " .. PHASES[currentPhase] .. "!", 0) -- Announce the current phase
        announcedPhase = currentPhase -- Update the last announced phase
    elseif currentPhase == #PHASES and announcedPhase ~= #PHASES then
        world:SendUnitYell("Final Phase!", 0) -- Announce the final phase
        announcedPhase = currentPhase -- Update the last announced phase
    end

    -- Cast the spell associated with the current phase on the boss's target
    creature:CastSpell(creature:GetVictim(), SPELLS[currentPhase], true)
end


RegisterCreatureEvent(200011, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200011, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200011, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200011, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200011, 9, RichardHeart.CheckHealth)

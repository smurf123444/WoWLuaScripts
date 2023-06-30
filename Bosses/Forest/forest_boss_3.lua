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


    local PHASES = {"Assault Bot Phase", "Tower Defense Phase", "Demolisher/Siege Vehicle Detonation", "Mounted Assault", "Hard Mode"} -- List of phase names


    for i = #PHASES, 2, -1 do
        if creature:HealthBelowPct((#PHASES - i + 1) * 20) then
            world:PlayDirectSound(17257)
            currentPhase = i
            break
        end
    end
        local SPELLS = {
            -- Leviathan basic
            PURSUED = 62374,
            GATHERING_SPEED = 62375,
            BATTERING_RAM = 62376,
            FLAME_VENTS = 62396,
            MISSILE_BARRAGE = 62400,
            NAPALM_10 = 63666,
            NAPALM_25 = 65026,
            INVIS_AND_STEALTH_DETECT = 18950,
            TRANSITUS_SHIELD_IMPACT = 48387,
    
            -- Shutdown spells
            SYSTEMS_SHUTDOWN = 62475,
            OVERLOAD_CIRCUIT = 62399,
    
            -- Hard mode
            TOWER_OF_STORMS = 65076,
            TOWER_OF_FLAMES = 65075,
            TOWER_OF_FROST = 65077,
            TOWER_OF_LIFE = 64482,
    
            HODIRS_FURY = 62533,
            FREYA_WARD = 62906,
            MIMIRONS_INFERNO = 62909,
            THORIMS_HAMMER = 62911,
    
            FREYA_DUMMY_BLUE = 63294,
            FREYA_DUMMY_GREEN = 63295,
            FREYA_DUMMY_YELLOW = 63292,
    
            -- Leviathan turret spell
            SEARING_FLAME = 62402,
            -- On turret Destroy
            SMOKE_TRAIL = 63575,
    
            -- Pool of tar blaze
            BLAZE = 62292,
    
            -- Pyrite
            LIQUID_PYRITE = 62494,
            DUSTY_EXPLOSION = 63360,
            DUST_CLOUD_IMPACT = 54740,
        }
    
    
        -- Determine the current phase based on specific conditions or thresholds

    
        if currentPhase == 1 then
            -- Assault Bot Phase
            creature:CastSpell(creature:GetVictim(), SPELLS.BATTERING_RAM, true) -- Example ability
            -- Handle mechanics and abilities related to the demolishers or siege vehicles

            local players = creature:GetPlayersInRange(30)


            if not hasSummonWormExecuted then
                hasSummonWormExecuted = true
            
                local addsCount = math.random(3, 5)
                for i = 1, addsCount do
                    local randomPlayer = players[math.random(1, #players)]
                    local add = creature:SpawnCreature(33966, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 2, 0)
                    add:AttackStart(randomPlayer)
                end
            end

        end
    
        if currentPhase == 2 then
            -- Tower Defense Phase
            local vinesCount = math.random(4, 6)
            for i = 1, vinesCount do
                local vineX = creature:GetX() + math.random(-5, 5)
                local vineY = creature:GetY() + math.random(-5, 5)
                local vineZ = creature:GetZ()
                local vine = creature:SummonGameObject(6292, vineX, vineY, vineZ, creature:GetO(), 0, 0, 0, 0) -- Replace 54321 with the desired game object ID for the vine
                vine:SetPhaseMask(1) -- Set the phase mask for the vines
            end
            -- Handle mechanics and abilities related to the towers
        end
    
        if currentPhase == 3 then
            -- Demolisher/Siege Vehicle Detonation
            -- Handle explosion mechanics and damage to nearby players
            local vinesCount = math.random(4, 6)
            for i = 1, vinesCount do
                local vineX = creature:GetX() + math.random(-5, 5)
                local vineY = creature:GetY() + math.random(-5, 5)
                local vineZ = creature:GetZ()
                local vine = creature:SummonGameObject(6292, vineX, vineY, vineZ, creature:GetO(), 0, 0, 0, 0) -- Replace 54321 with the desired game object ID for the vine
                vine:SetPhaseMask(1) -- Set the phase mask for the vines
            end
        end
    
        if currentPhase == 4 then
            -- Mounted Assault
            -- Handle mechanics and abilities related to engaging Flame Leviathan directly
            creature:CastSpell(creature:GetVictim(), SPELLS.SEARING_FLAME, true) -- Example ability

            local players = creature:GetPlayersInRange(30)
            -- Berkserker phase
            if not hasSummonMiniBossExecuted then
                hasSummonMiniBossExecuted = true
            
                local addsCount = math.random(1, 2)
                for i = 1, addsCount do
                    local randomPlayer = players[math.random(1, #players)]
                    local miniboss = creature:SpawnCreature(40435, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 2, 0) -- Replace 67890 with the desired miniboss creature entry ID
                    miniboss:AttackStart(randomPlayer)
            
                end
            end
        end
    
        if currentPhase == 5 then
            -- Hard Mode
            creature:CastSpell(creature:GetVictim(), SPELLS.TOWER_OF_STORMS, true) -- Example ability
            if not hasBerkerkExecuted then
                hasBerkerkExecuted = true
            
    
            end
            -- Handle additional mechanics and increased difficulty
        end

        
    if currentPhase > 1 and currentPhase < #PHASES and currentPhase ~= announcedPhase then
        -- Announce the current phase if it hasn't been announced yet
        creature:SendUnitYell(PHASES[currentPhase] .. " begins!", 0)
        world:PlayDirectSound(17258)
        announcedPhase = currentPhase
    elseif currentPhase == #PHASES and announcedPhase ~= #PHASES then
        hasSummonWormExecuted = false
        hasSummonMiniBossExecuted = false
        hasBerkerkExecuted = false
        -- Special message for the final phase
        creature:SendUnitYell(PHASES[currentPhase] .. "! It's over 9000!!!", 0)
        announcedPhase = #PHASES
    end
    
        -- Cast the spell associated with the current phase on the boss's target (if applicable)
        creature:CastSpell(creature:GetVictim(), SPELLS[currentPhase], true)
    
        -- Announcement or visual effect logic here
end
    

RegisterCreatureEvent(200009, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(200009, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(200009, 4, RichardHeart.OnDied)
RegisterCreatureEvent(200009, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(200009, 9, RichardHeart.CheckHealth)

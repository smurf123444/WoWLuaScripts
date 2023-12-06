local RichardHeart = {}
local currentPhase = 1
local burstRan = false
local timerStartTime = 0

function RichardHeart.OnSpawn(event, creature)
    creature:SetWanderRadius(10)
end

function StormStrike(eventId, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 17364, true)
end
function ChainLightning(eventId, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 49271, true)
end
function Shockwave(eventId, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 75417, true)
end

function RichardHeart.OnEnterCombat(event, creature, target)
    creature:SendUnitYell("Are you so Eager to Die? I wIll be Happy to accomidate you...", 0)
    creature:PlayDirectSound(8650)
    
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
    creature:RegisterEvent(StormStrike, { 1000,3000 }, 0)
    creature:RegisterEvent(ChainLightning, { 1000,3000 }, 0)
    creature:RegisterEvent(Shockwave, { 15000,30000 }, 0)
end

function RichardHeart.OnLeaveCombat(event, creature, world)
    local yellOptions = "Let your Death serve as an Example..."
    creature:PlayDirectSound(8617)
    creature:SendUnitYell(yellOptions, 0)
end

function RichardHeart.OnDied(event, creature, killer)
    creature:SendUnitYell("You only delay... The inevitable...", 0)
    creature:PlayDirectSound(8652)
    
    if (killer:GetObjectType() == "Player") then
        killer:SendBroadcastMessage("You killed " .. creature:GetName() .. "!")
    end
    
    creature:RemoveEvents()
    currentPhase = 1
end

function RichardHeart.CheckHealth(event, creature, world)
    local targets = creature:GetVictim()

    if currentPhase == 1 then
        if burstRan == false then
            timerStartTime = GetCurrTime() -- Starting the timer
            burstRan = true
        end
       creature:CastSpell(creature:GetVictim(), 69413, true)
       targets:MoveJump(4797, -4469, 205, 10, 15)
        targets:EmoteState(473)
        targets:PerformEmote(473)
        targets:SetPlayerLock(true) 
        
      local currentTime = GetCurrTime()
        local elapsedTime = currentTime - timerStartTime
        
        -- Debug output
        print("ElapsedTime: " .. elapsedTime)
        
        if elapsedTime >= 5000 then -- 5000 milliseconds = 5 seconds
            targets:SetPlayerLock(false)
            print("Timer expired, PlayerLock set to false")
            burstRan = false
        end 
        
        if creature:HealthBelowPct(75) and creature:HealthAbovePct(61) then
            burstRan = false
            targets:SetPlayerLock(false)
            currentPhase = 2
        end
    end
    
    -- Similar logic for other phases...

end

RegisterCreatureEvent(123456, 1, RichardHeart.OnEnterCombat)
RegisterCreatureEvent(123456, 2, RichardHeart.OnLeaveCombat)
RegisterCreatureEvent(123456, 4, RichardHeart.OnDied)
RegisterCreatureEvent(123456, 5, RichardHeart.OnSpawn)
RegisterCreatureEvent(123456, 9, RichardHeart.CheckHealth)

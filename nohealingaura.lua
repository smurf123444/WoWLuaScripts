local SPELL_NO_HEALING_AURA = 12 -- Replace with your actual spell ID
local INTERRUPT_SPELL_IDS = {
    5185, -- Example spell ID for "healing-touch rank 1"
    -- Add more spell IDs as needed
}

-- Utility function to check if a spellId is in the list
local function IsInterruptableSpell(spellId)
    for _, id in ipairs(INTERRUPT_SPELL_IDS) do
        if id == spellId then
            return true
        end
    end
    return false
end

local function OnSpellCast(event, player, spell, skipCheck)
    if player:HasAura(SPELL_NO_HEALING_AURA) then
        print("PLAYER HAS AURA")
        local spellId = spell:GetEntry()
        print(spellId)
        -- Interrupt the spell if its ID is in the INTERRUPT_SPELL_IDS list
        if IsInterruptableSpell(spellId) then
            print("PLAYER HAS HEALING SPELL")
            player:InterruptSpell(1)
        end
    end
end


local frozenAuras = {}

local function OnAuraApplied(event, player, spellId, _, aura)
    if spellId == SPELL_NO_HEALING_AURA then
        -- Loop through player auras and freeze them
        local auras = player:GetAuras()
        for _, aura in pairs(auras) do
            local duration = aura:GetDuration()
            if duration > 0 then
                frozenAuras[aura:GetId()] = duration
                aura:SetDuration(0) -- This freezes the aura
            end
        end
    end
end

local function OnAuraRemoved(event, player, spellId, _)
    if spellId == SPELL_NO_HEALING_AURA then
        -- Loop through frozen auras and restore their durations
        for spellId, duration in pairs(frozenAuras) do
            local playerAura = player:GetAura(spellId)
            if playerAura then
                playerAura:SetDuration(duration)
            end
        end
        frozenAuras = {} -- Clear the table
    end
end
RegisterPlayerEvent(5, OnSpellCast)             -- UNIT_SPELLCAST_SUCCEEDED
RegisterPlayerEvent(27, OnAuraApplied)         -- PLAYER_AURA_APPLIED
RegisterPlayerEvent(28, OnAuraRemoved)         -- PLAYER_AURA_REMOVED

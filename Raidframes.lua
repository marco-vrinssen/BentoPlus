-- Function to hide all buffs and debuffs on raid frames
local function HideAllAuras(frame)
    CompactUnitFrame_HideAllBuffs(frame)
    CompactUnitFrame_HideAllDebuffs(frame)
end

-- Hook to the CompactUnitFrame_UpdateAuras function to hide buffs and debuffs
hooksecurefunc("CompactUnitFrame_UpdateAuras", HideAllAuras)
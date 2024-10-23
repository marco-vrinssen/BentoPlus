-- HIDE ALL BUFFS AND DEBUFFS ON RAID FRAMES

hooksecurefunc("CompactUnitFrame_UpdateAuras", function(frame)
    CompactUnitFrame_HideAllBuffs(frame)
    CompactUnitFrame_HideAllDebuffs(frame)
end)
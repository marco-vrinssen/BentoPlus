-- Always hide buffs and debuffs on compact raid frames to reduce clutter

hooksecurefunc("CompactUnitFrame_UpdateAuras", function(raidFrame)
  if not raidFrame or raidFrame:IsForbidden() then return end

  if CompactUnitFrame_HideAllBuffs then
    CompactUnitFrame_HideAllBuffs(raidFrame)
  end

  if CompactUnitFrame_HideAllDebuffs then
    CompactUnitFrame_HideAllDebuffs(raidFrame)
  end
end)
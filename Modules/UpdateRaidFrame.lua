-- Update raid frame auras to manage visibility so that we reduce clutter

local raidFrameAurasKey = "RaidFrameAuras"

-- Initialize saved variable for raid frame aura visibility

if not BentoDB then
  BentoDB = {}
end
if BentoDB[raidFrameAurasKey] == nil then
  BentoDB[raidFrameAurasKey] = false
end

-- Hide buffs/debuffs on compact raid frames when disabled

local function hideRaidAuras(frame)
  if not frame or frame:IsForbidden() then
    return
  end
  
  if BentoDB[raidFrameAurasKey] then
    return
  end
  
  if CompactUnitFrame_HideAllBuffs then
    CompactUnitFrame_HideAllBuffs(frame)
  end
  
  if CompactUnitFrame_HideAllDebuffs then
    CompactUnitFrame_HideAllDebuffs(frame)
  end
end

-- Hook aura update to enforce visibility preference

hooksecurefunc("CompactUnitFrame_UpdateAuras", hideRaidAuras)

-- Functions to refresh frames and toggle visibility

local function refreshRaidAuras()
  if not CompactRaidFrameContainer or not CompactRaidFrameContainer.memberUnitFrames then
    return
  end
  
  for frame in pairs(CompactRaidFrameContainer.memberUnitFrames) do
    if frame.UpdateAuras then
      frame:UpdateAuras()
    end
  end
end

local function printAurasStatus()
  if BentoDB[raidFrameAurasKey] then
    print("|cffffffffBentoPlus: Raid frame auras are now |cffadc9ffvisible|r on all frames.")
  else
    print("|cffffffffBentoPlus: Raid frame auras are now |cffadc9ffhidden|r for better performance.")
  end
end

local function toggleRaidAuras()
  BentoDB[raidFrameAurasKey] = not BentoDB[raidFrameAurasKey]
  printAurasStatus()
  refreshRaidAuras()
end

-- Register slash command for raid frame aura visibility toggle

SLASH_BENTOPLUS_RAIDFRAMEAURAS1 = "/bentoraid"
SlashCmdList["BENTOPLUS_RAIDFRAMEAURAS"] = toggleRaidAuras

-- Notify user on login about default aura visibility state

local function handlePlayerLogin()
  if not BentoDB[raidFrameAurasKey] then
    print("|cffffffffBentoPlus: Raid frame auras are |cffadc9ffhidden|r by default. Use |cffadc9ff/bentoraid|r to toggle.")
  end
end

local raidLoginFrame = CreateFrame("Frame")
raidLoginFrame:RegisterEvent("PLAYER_LOGIN")
raidLoginFrame:SetScript("OnEvent", handlePlayerLogin)
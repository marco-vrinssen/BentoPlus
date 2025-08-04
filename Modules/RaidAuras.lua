-- Raid frame aura management constants and database initialization

local RAID_FRAME_AURAS_VISIBILITY_KEY = "RaidFrameAuras"

-- Initialize database for raid frame aura visibility state

if not BentoDB then
  BentoDB = {}
end
if BentoDB[RAID_FRAME_AURAS_VISIBILITY_KEY] == nil then
  BentoDB[RAID_FRAME_AURAS_VISIBILITY_KEY] = false
end

-- Core raid frame aura hiding functionality

local function hideRaidFrameAuras(frame)
  if not frame or frame:IsForbidden() then
    return
  end
  
  if BentoDB[RAID_FRAME_AURAS_VISIBILITY_KEY] then
    return
  end
  
  if CompactUnitFrame_HideAllBuffs then
    CompactUnitFrame_HideAllBuffs(frame)
  end
  
  if CompactUnitFrame_HideAllDebuffs then
    CompactUnitFrame_HideAllDebuffs(frame)
  end
end

-- Hook into aura update system

hooksecurefunc("CompactUnitFrame_UpdateAuras", hideRaidFrameAuras)

-- Raid frame aura visibility toggle functionality

local function refreshAllRaidFrameAuras()
  if not CompactRaidFrameContainer or not CompactRaidFrameContainer.memberUnitFrames then
    return
  end
  
  for frame in pairs(CompactRaidFrameContainer.memberUnitFrames) do
    if frame.UpdateAuras then
      frame:UpdateAuras()
    end
  end
end

local function printAuraToggleStatusMessage()
  if BentoDB[RAID_FRAME_AURAS_VISIBILITY_KEY] then
    print("|cffffffffBentoPlus: Raid frame auras are now |cffadc9ffvisible|r on all frames.")
  else
    print("|cffffffffBentoPlus: Raid frame auras are now |cffadc9ffhidden|r for better performance.")
  end
end

local function toggleRaidFrameAuraVisibility()
  BentoDB[RAID_FRAME_AURAS_VISIBILITY_KEY] = not BentoDB[RAID_FRAME_AURAS_VISIBILITY_KEY]
  printAuraToggleStatusMessage()
  refreshAllRaidFrameAuras()
end

-- Slash command registration for raid frame aura toggle

SLASH_BENTOPLUS_RAIDFRAMEAURAS1 = "/bentoraid"
SlashCmdList["BENTOPLUS_RAIDFRAMEAURAS"] = toggleRaidFrameAuraVisibility

-- Event handlers for login notifications

local function handlePlayerLogin()
  if not BentoDB[RAID_FRAME_AURAS_VISIBILITY_KEY] then
    print("|cffffffffBentoPlus: Raid frame auras are |cffadc9ffhidden|r by default. Use |cffadc9ff/bentoraid|r to toggle.")
  end
end

local raidFrameLoginNotification = CreateFrame("Frame")
raidFrameLoginNotification:RegisterEvent("PLAYER_LOGIN")
raidFrameLoginNotification:SetScript("OnEvent", handlePlayerLogin)
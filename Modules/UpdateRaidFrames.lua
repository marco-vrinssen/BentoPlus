-- Hide auras on raid frames to reduce visual clutter

local auraVisibilityKey = "RaidFrameAuras"

-- Initialize database for aura visibility state

if not BentoDB then
  BentoDB = {}
end

if BentoDB[auraVisibilityKey] == nil then
  BentoDB[auraVisibilityKey] = false
end

-- Suppress auras on raid frames when visibility disabled

local function suppressRaidAuras(raidFrame)
  if not raidFrame or raidFrame:IsForbidden() or BentoDB[auraVisibilityKey] then
    return
  end
  
  if CompactUnitFrame_HideAllBuffs then
    CompactUnitFrame_HideAllBuffs(raidFrame)
  end
  
  if CompactUnitFrame_HideAllDebuffs then
    CompactUnitFrame_HideAllDebuffs(raidFrame)
  end
end

-- Hook aura updates to enforce visibility preferences

hooksecurefunc("CompactUnitFrame_UpdateAuras", suppressRaidAuras)

-- Refresh all raid frame auras to apply visibility changes

local function refreshAllRaidAuras()
  if not CompactRaidFrameContainer or not CompactRaidFrameContainer.memberUnitFrames then
    return
  end
  
  for raidFrame in pairs(CompactRaidFrameContainer.memberUnitFrames) do
    if raidFrame.UpdateAuras then
      raidFrame:UpdateAuras()
    end
  end
end

-- Print current aura visibility status to chat

local function printAuraStatus()
  local statusText = BentoDB[auraVisibilityKey] and "Visible" or "Hidden"
  print("|cffffffffBentoPlus: Raid Auras: |cffffff80" .. statusText .. "|r|cffffffff.|r")
end

-- Toggle raid aura visibility and refresh frames

local function toggleAuraVisibility()
  BentoDB[auraVisibilityKey] = not BentoDB[auraVisibilityKey]
  printAuraStatus()
  refreshAllRaidAuras()
end

-- Register slash command to toggle raid aura visibility

SLASH_BENTOPLUS_RAIDFRAMEAURAS1 = "/bentoraid"
SlashCmdList["BENTOPLUS_RAIDFRAMEAURAS"] = toggleAuraVisibility
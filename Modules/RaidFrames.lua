-- Initialize the database for storing aura visibility state.

local auraVisibilityState = "RaidFrameAuras"

if not BentoDB then
  BentoDB = {}
end
if BentoDB[auraVisibilityState] == nil then
  BentoDB[auraVisibilityState] = false
end

-- Hide raid frame auras if they are disabled in the settings.

local function hideRaidFrameAuras(frame)
  if not frame or not frame:IsForbidden() then
    if not BentoDB[auraVisibilityState] then
      if CompactUnitFrame_HideAllBuffs then
        CompactUnitFrame_HideAllBuffs(frame)
      end
      if CompactUnitFrame_HideAllDebuffs then
        CompactUnitFrame_HideAllDebuffs(frame)
      end
    end
  end
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", hideRaidFrameAuras)

-- Toggle the visibility of raid frame auras and refresh the frames.

local function toggleAuraVisibility()
  BentoDB[auraVisibilityState] = not BentoDB[auraVisibilityState]
  if BentoDB[auraVisibilityState] then
    print("|cff00ff00BentoPlus: Raid frame auras are now |cffffff00VISIBLE|r.")
  else
    print("|cff00ff00BentoPlus: Raid frame auras are now |cffff0000HIDDEN|r.")
  end
  if CompactRaidFrameContainer and CompactRaidFrameContainer.memberUnitFrames then
    for frame in pairs(CompactRaidFrameContainer.memberUnitFrames) do
      if frame.UpdateAuras then
        frame:UpdateAuras()
      end
    end
  end
end

-- Register the slash command for toggling raid frame auras.

SLASH_BENTOPLUS_RAIDFRAMEAURAS1 = "/raidframeauras"
SlashCmdList["BENTOPLUS_RAIDFRAMEAURAS"] = toggleAuraVisibility

-- Show a notification on login if raid frame auras are hidden.

local raidFrameLoginFrame = CreateFrame("Frame")
raidFrameLoginFrame:RegisterEvent("PLAYER_LOGIN")
raidFrameLoginFrame:SetScript("OnEvent", function()
  if not BentoDB[auraVisibilityState] then
    print("|cff00ff00BentoPlus: Raid frame auras are |cffff0000HIDDEN|r by default. Use /raidframeauras to toggle.")
  end
end)
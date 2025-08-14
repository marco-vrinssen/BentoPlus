-- Mute alert sound and hide talking head for cleaner UI

local function hideAlerts()
  MuteSoundFile(569143)
  
  AlertFrame:UnregisterAllEvents()
  AlertFrame:Hide()
  AlertFrame:SetAlpha(0)
  
  TalkingHeadFrame:UnregisterAllEvents()
  TalkingHeadFrame:Hide()
  TalkingHeadFrame:SetAlpha(0)
end

-- Apply configuration on world entry

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", hideAlerts)
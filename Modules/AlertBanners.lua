-- Mute obnoxious alert sound and hide talking head for cleaner UI

local function configureAlertSystem()
  MuteSoundFile(569143)
  AlertFrame:UnregisterAllEvents()
  TalkingHeadFrame:Hide()
end

-- Apply alert system configuration on player world entry for consistency

local alertSystemFrame = CreateFrame("Frame")
alertSystemFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
alertSystemFrame:SetScript("OnEvent", configureAlertSystem)
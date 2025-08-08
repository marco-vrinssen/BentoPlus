-- Update alertSystem to mute obnoxious sound and hide talking head

local function configureAlertSystem()
  MuteSoundFile(569143)
  AlertFrame:UnregisterAllEvents()
  TalkingHeadFrame:Hide()
end

-- Update alertSystem to apply config on player world entry

local alertSystemFrame = CreateFrame("Frame")
alertSystemFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
alertSystemFrame:SetScript("OnEvent", configureAlertSystem)
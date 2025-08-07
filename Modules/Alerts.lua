-- Configure alert system by muting sounds and hiding talking head frame
local function configureAlertSystem()
  MuteSoundFile(569143)
  AlertFrame:UnregisterAllEvents()
  TalkingHeadFrame:Hide()
end

-- Initialize alert system configuration when player enters world
local alertSystemFrame = CreateFrame("Frame")
alertSystemFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
alertSystemFrame:SetScript("OnEvent", configureAlertSystem)
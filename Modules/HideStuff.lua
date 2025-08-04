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

-- Hide experience bar when player reaches maximum level

local function hideExperienceBarAtMaxLevel()
  local currentPlayerLevel = UnitLevel("player")
  local maximumPlayerLevel = GetMaxPlayerLevel()

  if MainStatusTrackingBarContainer then
    if currentPlayerLevel < maximumPlayerLevel then
      MainStatusTrackingBarContainer:Show()
      MainStatusTrackingBarContainer:SetScript("OnShow", nil)
    else
      MainStatusTrackingBarContainer:Hide()
      MainStatusTrackingBarContainer:SetScript("OnShow", MainStatusTrackingBarContainer.Hide)
    end
  end
end

-- Monitor player level changes to update experience bar visibility

local experienceBarFrame = CreateFrame("Frame")
experienceBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
experienceBarFrame:RegisterEvent("PLAYER_LEVEL_UP")
experienceBarFrame:SetScript("OnEvent", function(self, event)
  C_Timer.After(0, hideExperienceBarAtMaxLevel)
end)

-- Hide vehicle seat indicator permanently

local vehicleSeatIndicatorFrame = _G["VehicleSeatIndicator"]
vehicleSeatIndicatorFrame:Hide()
vehicleSeatIndicatorFrame:SetScript("OnShow", vehicleSeatIndicatorFrame.Hide)
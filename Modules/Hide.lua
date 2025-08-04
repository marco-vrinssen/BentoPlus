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

-- Hide prestige elements from target frame

local function hideTargetFramePrestigeElements()
  if TargetFrame and TargetFrame.TargetFrameContent and TargetFrame.TargetFrameContent.TargetFrameContentContextual then
    local targetFrameContextual = TargetFrame.TargetFrameContent.TargetFrameContentContextual
    
    if targetFrameContextual.PrestigeBadge then
      targetFrameContextual.PrestigeBadge:SetShown(false)
    end
    
    if targetFrameContextual.PrestigePortrait then
      targetFrameContextual.PrestigePortrait:SetShown(false)
    end
  end
end

-- Monitor target changes to hide prestige elements

local targetFramePrestigeFrame = CreateFrame("Frame")
targetFramePrestigeFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
targetFramePrestigeFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
targetFramePrestigeFrame:SetScript("OnEvent", hideTargetFramePrestigeElements)

-- Hide prestige elements from player frame

local function hidePlayerFramePrestigeElements()
  if PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual then
    local playerFrameContextual = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual
    
    if playerFrameContextual.PrestigeBadge then
      playerFrameContextual.PrestigeBadge:SetShown(false)
    end
    
    if playerFrameContextual.PrestigePortrait then
      playerFrameContextual.PrestigePortrait:SetShown(false)
    end
  end
end

-- Monitor player frame updates to hide prestige elements

local playerFramePrestigeFrame = CreateFrame("Frame")
playerFramePrestigeFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
playerFramePrestigeFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
playerFramePrestigeFrame:SetScript("OnEvent", hidePlayerFramePrestigeElements)
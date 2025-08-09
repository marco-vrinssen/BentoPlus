-- Update experience bar to hide at max level so that we keep interface clean

local function hideExperienceBar()
  local currentLevel = UnitLevel("player")
  local maxLevel = GetMaxPlayerLevel()
  if MainStatusTrackingBarContainer then
    if currentLevel < maxLevel then
      MainStatusTrackingBarContainer:Show()
      MainStatusTrackingBarContainer:SetScript("OnShow", nil)
    else
      MainStatusTrackingBarContainer:Hide()
      MainStatusTrackingBarContainer:SetScript("OnShow", MainStatusTrackingBarContainer.Hide)
    end
  end
end

-- Update events to toggle experience bar so that we reflect level changes

local experienceBarFrame = CreateFrame("Frame")
experienceBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
experienceBarFrame:RegisterEvent("PLAYER_LEVEL_UP")
experienceBarFrame:SetScript("OnEvent", function()
  C_Timer.After(0, hideExperienceBar)
end)
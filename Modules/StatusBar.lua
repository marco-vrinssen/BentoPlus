-- Hide the experience bar when the player reaches the maximum level.

local function hideMaxLevelExperienceBar()
  local playerLevel = UnitLevel("player")
  local maxLevel = GetMaxPlayerLevel()

  if MainStatusTrackingBarContainer then
    if playerLevel < maxLevel then
      MainStatusTrackingBarContainer:Show()
      MainStatusTrackingBarContainer:SetScript("OnShow", nil)
    else
      MainStatusTrackingBarContainer:Hide()
      MainStatusTrackingBarContainer:SetScript("OnShow", MainStatusTrackingBarContainer.Hide)
    end
  end
end

-- Register events for player level changes.

local statusBarEventsFrame = CreateFrame("Frame")
statusBarEventsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
statusBarEventsFrame:RegisterEvent("PLAYER_LEVEL_UP")
statusBarEventsFrame:SetScript("OnEvent", function(self, event)
  C_Timer.After(0, hideMaxLevelExperienceBar)
end)
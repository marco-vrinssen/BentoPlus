-- Hide XP bar at max level

local function hideXpBar()
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

-- Track level to toggle XP bar

local xpBarFrame = CreateFrame("Frame")
xpBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
xpBarFrame:RegisterEvent("PLAYER_LEVEL_UP")
xpBarFrame:SetScript("OnEvent", function()
  C_Timer.After(0, hideXpBar)
end)
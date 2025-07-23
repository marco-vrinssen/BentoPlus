-- Hide experience bar at maximum player level
local function hideExperienceBar()
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

-- Register level change events
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:SetScript("OnEvent", function(self, event)
    C_Timer.After(0, hideExperienceBar)
end)
-- Hide XP status bar based on player level

local function HideStatusTrackingBars()
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

local StatusTrackingEvents = CreateFrame("Frame")
StatusTrackingEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
StatusTrackingEvents:RegisterEvent("PLAYER_LEVEL_UP")
StatusTrackingEvents:SetScript("OnEvent", function(self, event)
    C_Timer.After(0, HideStatusTrackingBars)
end)
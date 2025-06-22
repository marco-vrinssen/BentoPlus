local function hideStatusBars()
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

-- Initialize tracking bar visibility

local statusHandler = CreateFrame("Frame")
statusHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
statusHandler:RegisterEvent("PLAYER_LEVEL_UP")
statusHandler:SetScript("OnEvent", function(self, event)
    C_Timer.After(0, hideStatusBars)
end)
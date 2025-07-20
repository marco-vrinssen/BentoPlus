
-- Hide main status tracking bars if player is at max level

local function hideMainStatusTrackingBarsIfMaxLevel()
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


-- Register events to initialize tracking bar visibility

local trackingBarVisibilityEventFrame = CreateFrame("Frame")
trackingBarVisibilityEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
trackingBarVisibilityEventFrame:RegisterEvent("PLAYER_LEVEL_UP")
trackingBarVisibilityEventFrame:SetScript("OnEvent", function(self, eventTypeString)
    C_Timer.After(0, hideMainStatusTrackingBarsIfMaxLevel)
end)
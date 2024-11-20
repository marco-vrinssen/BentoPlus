local function UpdateCastingBar()
    local castingBar = PlayerCastingBarFrame
    castingBar.Text:Hide()
    castingBar.TextBorder:Hide()
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", UpdateCastingBar)
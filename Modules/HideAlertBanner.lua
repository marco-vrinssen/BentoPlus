local function muteAlerts()
    MuteSoundFile(569143)
    AlertFrame:UnregisterAllEvents()
end

-- Initialize alert muting

local alertHandler = CreateFrame("Frame")
alertHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
alertHandler:SetScript("OnEvent", muteAlerts)
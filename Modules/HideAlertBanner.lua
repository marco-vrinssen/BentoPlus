
-- Mute alert sounds and unregister alert events

local function muteAlertSoundsAndUnregisterEvents()
    MuteSoundFile(569143)
    AlertFrame:UnregisterAllEvents()
end


-- Register event to initialize alert muting

local alertBannerMuteEventFrame = CreateFrame("Frame")
alertBannerMuteEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
alertBannerMuteEventFrame:SetScript("OnEvent", muteAlertSoundsAndUnregisterEvents)
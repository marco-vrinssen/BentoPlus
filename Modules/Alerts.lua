-- Function to mute and hide all alerts by unregistering events and muting sound

local function MuteAndHideAllAlerts()
    MuteSoundFile(569143)
    AlertFrame:UnregisterAllEvents()
end

local AlertEvents = CreateFrame("Frame")
AlertEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
AlertEvents:SetScript("OnEvent", MuteAndHideAllAlerts)


-- Hide Talking Head frame

hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    self:Hide()
end)
-- Hide Talking Head frame

hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    self:Hide()
end)




-- Hide vehicle seat indicator

local VehicleSeatIndicator = _G["VehicleSeatIndicator"]
VehicleSeatIndicator:Hide()
VehicleSeatIndicator:SetScript("OnShow", VehicleSeatIndicator.Hide)




-- Mute and hide alert banners and their sound

local function MuteAndHideAlerts()
    hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
        AlertFrame:UnregisterEvent(event)
    end)

    MuteSoundFile(569143)
    AlertFrame:UnregisterAllEvents()
end

local AlertEvents = CreateFrame("Frame")
AlertEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
AlertEvents:SetScript("OnEvent", MuteAndHideAlerts)
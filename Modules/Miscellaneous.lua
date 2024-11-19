-- Function to mute and hide all alerts by unregistering events and muting sound
local function MuteAndHideAllAlerts()
    MuteSoundFile(569143)
    AlertFrame:UnregisterAllEvents()
end

-- Create a frame to handle alert events
local AlertEvents = CreateFrame("Frame")
AlertEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
AlertEvents:SetScript("OnEvent", MuteAndHideAllAlerts)

-- Hide vehicle seat indicator
local VehicleSeatIndicator = _G["VehicleSeatIndicator"]
VehicleSeatIndicator:Hide()
VehicleSeatIndicator:SetScript("OnShow", VehicleSeatIndicator.Hide)
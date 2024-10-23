-- Function to hide XP and status bars based on player level
local function HideStatusTrackingBars()
    local playerLevel = UnitLevel("player")
    local maxLevel = GetMaxPlayerLevel()

    if playerLevel < maxLevel then
        if MainStatusTrackingBarContainer then
            MainStatusTrackingBarContainer:Show()
            MainStatusTrackingBarContainer:SetScript("OnShow", nil)
        end
    else
        if MainStatusTrackingBarContainer then 
            MainStatusTrackingBarContainer:Hide()
            MainStatusTrackingBarContainer:SetScript("OnShow", MainStatusTrackingBarContainer.Hide)
        end
    end

    if SecondaryStatusTrackingBarContainer then
        SecondaryStatusTrackingBarContainer:Hide()
        SecondaryStatusTrackingBarContainer:SetScript("OnShow", SecondaryStatusTrackingBarContainer.Hide)
    end
end

-- Register events to trigger hiding of status tracking bars
local StatusTrackingEvents = CreateFrame("Frame")
StatusTrackingEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
StatusTrackingEvents:RegisterEvent("PLAYER_LEVEL_UP")
StatusTrackingEvents:SetScript("OnEvent", function(self, event)
    C_Timer.After(1, HideStatusTrackingBars)
end)

-- Function to hide the Talking Head frame
hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    self:Hide()
end)

-- Hide the vehicle seat indicator
local VehicleSeatIndicator = _G["VehicleSeatIndicator"]
VehicleSeatIndicator:Hide()
VehicleSeatIndicator:SetScript("OnShow", VehicleSeatIndicator.Hide)

-- Function to hide PvP badges on target and player frames
local function HidePvPBadges()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual:Hide()
end

-- Register event to trigger hiding of PvP badges
local PvPBadgeEvents = CreateFrame("Frame")
PvPBadgeEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PvPBadgeEvents:SetScript("OnEvent", HidePvPBadges)

-- Function to mute and hide alert banners and their sound
local function MuteAndHideAlerts()
    hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
        AlertFrame:UnregisterEvent(event)
    end)

    MuteSoundFile(569143)
    AlertFrame:UnregisterAllEvents()
end

-- Register event to trigger muting and hiding of alerts
local AlertEvents = CreateFrame("Frame")
AlertEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
AlertEvents:SetScript("OnEvent", MuteAndHideAlerts)
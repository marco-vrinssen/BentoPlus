-- HIDE XP AND STATUS BARS

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

local StatusTrackingEvents = CreateFrame("Frame")
StatusTrackingEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
StatusTrackingEvents:RegisterEvent("PLAYER_LEVEL_UP")
StatusTrackingEvents:SetScript("OnEvent", function(self, event)
    C_Timer.After(1, HideStatusTrackingBars)
end)




-- HIDE TALKING HEAD FRAME

hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    self:Hide()
end)




-- HIDE VEHICLE SEAT INDICATOR

local VehicleSeatIndicator = _G["VehicleSeatIndicator"]
VehicleSeatIndicator:Hide()
VehicleSeatIndicator:SetScript("OnShow", VehicleSeatIndicator.Hide)




-- HIDE PVP BADGES ON TARGET AND PLAYER FRAMES

local function HidePvPBadges()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual:Hide()
end

local PvPBadgeEvents = CreateFrame("Frame")
PvPBadgeEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PvPBadgeEvents:SetScript("OnEvent", HidePvPBadges)




-- HIDE ALERT BANNERS AND THEIR SOUND

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
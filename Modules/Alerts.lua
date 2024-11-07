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




-- Reposition BattleNet and Quickjoin Toasts

local NotificationFrame = CreateFrame("Frame", "NotificationFrame", UIParent)
NotificationFrame:SetSize(200, 100)
NotificationFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 24, -24)

local function UpdateToastElements()
    QuickJoinToastButton:SetAlpha(0)

    if QuickJoinToastButton.Toast1 then
        QuickJoinToastButton.Toast1:ClearAllPoints()
        QuickJoinToastButton.Toast1:SetParent(NotificationFrame)
        QuickJoinToastButton.Toast1:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
    end

    if QuickJoinToastButton.Toast2 then
        QuickJoinToastButton.Toast2:ClearAllPoints()
        QuickJoinToastButton.Toast2:SetParent(NotificationFrame)
        QuickJoinToastButton.Toast2:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
    end

    BNToastFrame:ClearAllPoints()
    BNToastFrame:SetParent(NotificationFrame)
    BNToastFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
end

local function OnPlayerEnteringWorld()
    UpdateToastElements()
end

local NotificationEvents = CreateFrame("Frame")
NotificationEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
NotificationEvents:SetScript("OnEvent", OnPlayerEnteringWorld)

BNToastFrame:HookScript("OnShow", UpdateToastElements)
QuickJoinToastButton:HookScript("OnShow", UpdateToastElements)
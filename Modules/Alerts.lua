-- Hide Talking Head frame
hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    self:Hide()
end)

-- Mute and hide all alert banners and their sound
local function MuteAndHideAllAlerts()
    hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
        self:UnregisterEvent(event)
    end)
    MuteSoundFile(569143)
end

local AlertEvents = CreateFrame("Frame")
AlertEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
AlertEvents:SetScript("OnEvent", MuteAndHideAllAlerts)

-- Function to handle QuickJoinToastButton changes
local function HandleQuickJoinToastButton()
    -- Hide QuickJoinToastButton
    QuickJoinToastButton:Hide()

    -- Reparent and anchor Toast1 and Toast2 to the new frame if they exist
    if QuickJoinToastButton.Toast1 then
        QuickJoinToastButton.Toast1:SetParent(UIParent)
        QuickJoinToastButton.Toast1:ClearAllPoints()
        QuickJoinToastButton.Toast1:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
    end

    if QuickJoinToastButton.Toast2 then
        QuickJoinToastButton.Toast2:SetParent(UIParent)
        QuickJoinToastButton.Toast2:ClearAllPoints()
        if QuickJoinToastButton.Toast1 then
            QuickJoinToastButton.Toast2:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -QuickJoinToastButton.Toast1:GetHeight())
        else
            QuickJoinToastButton.Toast2:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
        end
    end
end

-- Register event for QuickJoinToastButton changes
local QuickJoinToastEvents = CreateFrame("Frame")
QuickJoinToastEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
QuickJoinToastEvents:SetScript("OnEvent", HandleQuickJoinToastButton)
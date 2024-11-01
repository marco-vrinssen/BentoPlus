-- Hide Talking Head frame
hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    self:Hide()
end)




-- Mute and hide alert banners
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




-- Create a new BannerFrame
local BannerFrame = CreateFrame("Frame", "BannerFrame", UIParent)
BannerFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 24, -24)
BannerFrame:SetSize(200, 200) -- Adjust size as needed

-- Function to handle QuickJoinToastButton changes
local function HandleQuickJoinToastButton()
    -- Hide QuickJoinToastButton
    QuickJoinToastButton:Hide()

    -- Reparent and anchor Toast1 and Toast2 to the new BannerFrame if they exist
    if QuickJoinToastButton.Toast1 then
        QuickJoinToastButton.Toast1:SetParent(BannerFrame)
        QuickJoinToastButton.Toast1:ClearAllPoints()
        QuickJoinToastButton.Toast1:SetPoint("TOPLEFT", BannerFrame, "TOPLEFT", 0, 0)
    end

    if QuickJoinToastButton.Toast2 then
        QuickJoinToastButton.Toast2:SetParent(BannerFrame)
        QuickJoinToastButton.Toast2:ClearAllPoints()
        if QuickJoinToastButton.Toast1 then
            QuickJoinToastButton.Toast2:SetPoint("TOPLEFT", BannerFrame, "TOPLEFT", 0, -QuickJoinToastButton.Toast1:GetHeight())
        else
            QuickJoinToastButton.Toast2:SetPoint("TOPLEFT", BannerFrame, "TOPLEFT", 0, 0)
        end
    end
end

-- Register event for QuickJoinToastButton changes
local QuickJoinToastEvents = CreateFrame("Frame")
QuickJoinToastEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
QuickJoinToastEvents:SetScript("OnEvent", HandleQuickJoinToastButton)

-- Reparent and align BNToastFrame to the new BannerFrame
BNToastFrame:SetParent(BannerFrame)
BNToastFrame:ClearAllPoints()
BNToastFrame:SetPoint("TOPLEFT", BannerFrame, "TOPLEFT", 0, 0)
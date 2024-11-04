-- Hide Talking Head frame
hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    self:Hide()
end)




-- Create a new frame in the top left corner to attach the BNToastFrame and QuickJoinToastButton

local NotificationFrame = CreateFrame("Frame", "NotificationFrame", UIParent)
NotificationFrame:SetSize(200, 100)
NotificationFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 24, -24)

local function UpdateToastElements()

    QuickJoinToastButton:Hide()

    if QuickJoinToastButton.Toast1 then
        QuickJoinToastButton.Toast1:ClearAllPoints()
        QuickJoinToastButton.Toast1:SetParent(NotificationFrame)
        QuickJoinToastButton.Toast1:SetPoint("TOPLEFT", NotificationFrame, "TOPLEFT", 0, 0)
    end

    if QuickJoinToastButton.Toast2 then
        QuickJoinToastButton.Toast2:ClearAllPoints()
        QuickJoinToastButton.Toast2:SetParent(NotificationFrame)
        QuickJoinToastButton.Toast2:SetPoint("TOPLEFT", QuickJoinToastButton.Toast1 or NotificationFrame, "BOTTOMLEFT", 0, -8)
    end
end

local NotificationEvents = CreateFrame("Frame")
NotificationEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
NotificationEvents:SetScript("OnEvent", OnPlayerEnteringWorld)

QuickJoinToastButton:HookScript("OnShow", UpdateToastElements)
QuickJoinToastButton.Toast1:HookScript("OnShow", UpdateToastElements)
QuickJoinToastButton.Toast2:HookScript("OnShow", UpdateToastElements)




-- Function to re-anchor the BNToastFrame

local function RepositionBNToastFrame()
    BNToastFrame:ClearAllPoints()
    BNToastFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 24, -24)
end

-- Hook the function to the BNToastFrame's OnShow event
BNToastFrame:HookScript("OnShow", RepositionBNToastFrame)
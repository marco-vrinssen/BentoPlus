-- Hide Talking Head frame
hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    self:Hide()
end)




-- Reposition QuickJoinToastButton and BNToastFrame

local BannerFrame = CreateFrame("Frame", "BannerFrame", UIParent)
BannerFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 24, -24)
BannerFrame:SetSize(200, 200)

local function HandleQuickJoinToastButton()
    QuickJoinToastButton:Hide()

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

local QuickJoinToastEvents = CreateFrame("Frame")
QuickJoinToastEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
QuickJoinToastEvents:SetScript("OnEvent", HandleQuickJoinToastButton)

BNToastFrame:SetParent(BannerFrame)
BNToastFrame:ClearAllPoints()
BNToastFrame:SetPoint("TOPLEFT", BannerFrame, "TOPLEFT", 0, 0)
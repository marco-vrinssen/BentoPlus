local function hideBadges()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge:Hide()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:Hide()

    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()
end

-- Initialize unit frame modifications

local unitFrameHandler = CreateFrame("Frame")
unitFrameHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
unitFrameHandler:RegisterEvent("PLAYER_TARGET_CHANGED")
unitFrameHandler:SetScript("OnEvent", hideBadges)
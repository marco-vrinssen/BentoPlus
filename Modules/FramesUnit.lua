
-- Hide prestige badges and portraits on player and target frames

local function hidePrestigeBadgesAndPortraits()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge:Hide()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:Hide()

    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()
end


-- Register events to initialize unit frame modifications

local unitFrameBadgeHiderEventFrame = CreateFrame("Frame")
unitFrameBadgeHiderEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
unitFrameBadgeHiderEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
unitFrameBadgeHiderEventFrame:SetScript("OnEvent", hidePrestigeBadgesAndPortraits)
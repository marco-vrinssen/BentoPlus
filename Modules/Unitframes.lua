-- Hide target and focus frame auras and PvP badges

local function HideTargetAuras()
    MAX_TARGET_BUFFS = 0
    MAX_TARGET_DEBUFFS = 0
    MAX_FOCUS_BUFFS = 0
    MAX_FOCUS_DEBUFFS = 0
end

local function HidePlayerBadge()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge:Hide()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:Hide()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PvpIcon:Hide()
end

local function HideTargetBadge()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon:Hide()
end

local UnitFrameEvents = CreateFrame("Frame")
UnitFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
UnitFrameEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
UnitFrameEvents:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        HideTargetAuras()
        HideTargetBadge()
    elseif event == "PLAYER_TARGET_CHANGED" then
        HideTargetBadge()
    end
end)
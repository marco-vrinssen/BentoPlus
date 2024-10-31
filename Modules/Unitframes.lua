-- Hide target and focus frame auras

local function HideTargetFrameAuras()
    MAX_TARGET_BUFFS = 0
    MAX_TARGET_DEBUFFS = 0
end

local function HideFocusFrameAuras()
    MAX_FOCUS_BUFFS = 0
    MAX_FOCUS_DEBUFFS = 0
end

local function HideAllAuras()
    HideTargetFrameAuras()
    HideFocusFrameAuras()
end

local UnitFrameEvents = CreateFrame("Frame")
UnitFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
UnitFrameEvents:SetScript("OnEvent", HideAllAuras)




-- Hide PvP badges on target and player frames

local function HidePvPBadges()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge:Hide()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()
end

local PvPBadgeEvents = CreateFrame("Frame")
PvPBadgeEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PvPBadgeEvents:SetScript("OnEvent", HidePvPBadges)
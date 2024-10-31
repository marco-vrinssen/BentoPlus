-- Hide target and focus frame auras and PvP badges

local function HideAllElements()
    -- Hide target and focus frame auras
    MAX_TARGET_BUFFS = 0
    MAX_TARGET_DEBUFFS = 0
    MAX_FOCUS_BUFFS = 0
    MAX_FOCUS_DEBUFFS = 0

    -- Hide PvP badges on target and player frames
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge:Hide()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()
end

local UnitFrameEvents = CreateFrame("Frame")
UnitFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
UnitFrameEvents:SetScript("OnEvent", HideAllElements)
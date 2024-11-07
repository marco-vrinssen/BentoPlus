-- Hide target and focus frame auras and PvP badges

local function HideAurasAndBadges()
    MAX_TARGET_BUFFS = 0
    MAX_TARGET_DEBUFFS = 0
    MAX_FOCUS_BUFFS = 0
    MAX_FOCUS_DEBUFFS = 0

    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge:Hide()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:Hide()

    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()
end

local UnitFrameEvents = CreateFrame("Frame")
UnitFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
UnitFrameEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
UnitFrameEvents:RegisterEvent("UNIT_AURA")
UnitFrameEvents:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or event == "UNIT_AURA" then
        HideAurasAndBadges()
    end
end)
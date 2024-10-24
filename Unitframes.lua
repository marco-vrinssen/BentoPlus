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
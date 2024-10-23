-- Function to hide target frame auras
local function HideTargetFrameAuras()
    MAX_TARGET_BUFFS = 0
    MAX_TARGET_DEBUFFS = 0
end

-- Function to hide focus frame auras
local function HideFocusFrameAuras()
    MAX_FOCUS_BUFFS = 0
    MAX_FOCUS_DEBUFFS = 0
end

-- Function to hide all auras by calling the specific functions
local function HideAllAuras()
    HideTargetFrameAuras()
    HideFocusFrameAuras()
end

-- Event frame to handle player entering the world and hide auras
local UnitFrameEvents = CreateFrame("Frame")
UnitFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
UnitFrameEvents:SetScript("OnEvent", HideAllAuras)
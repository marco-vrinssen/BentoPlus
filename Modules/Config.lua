-- Update graphics related configuration

local function UpdateGraphicsConfig()
    SetCVar("ffxGlow", 0)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxNether", 0)
    
    SetCVar("cameraDistanceMaxZoomFactor", 2.6)
    
    SetCVar("rawMouseEnable", 1)
end

local GraphicsConfigFrame = CreateFrame("Frame")
GraphicsConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
GraphicsConfigFrame:SetScript("OnEvent", UpdateGraphicsConfig)
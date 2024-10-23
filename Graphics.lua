-- Function to update graphics configuration settings
local function UpdateGraphicsConfig()
    SetCVar("ffxGlow", 0)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxNether", 0)
    SetCVar("cameraDistanceMaxZoomFactor", 2.6)
end

-- Create a frame to handle graphics configuration events
local GraphicsConfigFrame = CreateFrame("Frame")
GraphicsConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
GraphicsConfigFrame:SetScript("OnEvent", UpdateGraphicsConfig)
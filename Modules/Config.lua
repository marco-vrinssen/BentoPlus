-- Function to update graphics configuration
local function UpdateGraphicsConfig()
    -- Disable various full-screen effects
    SetCVar("ffxGlow", 0)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxNether", 0)
    
    -- Set maximum camera distance zoom factor
    SetCVar("cameraDistanceMaxZoomFactor", 2.6)
    
    -- Enable raw mouse input
    SetCVar("rawMouseEnable", 1)
    
    -- Set spell queue window to 150 ms
    SetCVar("SpellQueueWindow", 150)
end

-- Create a frame to handle the PLAYER_ENTERING_WORLD event
local GraphicsConfigFrame = CreateFrame("Frame")
GraphicsConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
GraphicsConfigFrame:SetScript("OnEvent", UpdateGraphicsConfig)
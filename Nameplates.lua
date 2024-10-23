-- Function to update nameplate configuration
local function UpdateNameplateConfig()
    SetCVar("nameplateMotion", 1)
    SetCVar("nameplateMotionSpeed", 0.05)
    SetCVar("nameplateOverlapV", 0.5)
end

-- Create a frame to handle nameplate configuration updates
local NameplateConfigFrame = CreateFrame("Frame")
NameplateConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
NameplateConfigFrame:SetScript("OnEvent", UpdateNameplateConfig)

-- Function to hide nameplate auras
local function HideNameplateAuras(unitId)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
    local unitFrame = nameplate and nameplate.UnitFrame
    if not unitFrame or unitFrame:IsForbidden() then return end
    unitFrame.BuffFrame:SetAlpha(0)
end

-- Create a frame to handle hiding nameplate auras
local NameplateFrame = CreateFrame("Frame")
NameplateFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NameplateFrame:SetScript("OnEvent", function(self, event, unitId)
    if event == "NAME_PLATE_UNIT_ADDED" then
        HideNameplateAuras(unitId)
    end
end)
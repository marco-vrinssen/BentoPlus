-- Update nameplate configuration

local function UpdateNameplateConfig()
    SetCVar("nameplateMotion", 1)
    SetCVar("nameplateMotionSpeed", 0.05)
    SetCVar("nameplateOverlapV", 0.5)

    SetCVar("nameplateShowEnemyTotems", 1)
    SetCVar("nameplateShowEnemyPets", 1)
    SetCVar("nameplateShowEnemyMinions", 0)
    SetCVar("nameplateShowEnemyMinus", 0)
    SetCVar("nameplateShowEnemyGuardians", 0)
end

local NameplateConfigFrame = CreateFrame("Frame")
NameplateConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
NameplateConfigFrame:SetScript("OnEvent", UpdateNameplateConfig)


-- Hide nameplate auras

local function HideNameplateAuras(unitId)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
    local unitFrame = nameplate and nameplate.UnitFrame
    if not unitFrame or unitFrame:IsForbidden() then return end
    unitFrame.BuffFrame:SetAlpha(0)
end

local NameplateFrame = CreateFrame("Frame")
NameplateFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NameplateFrame:SetScript("OnEvent", function(self, event, unitId)
    if event == "NAME_PLATE_UNIT_ADDED" then
        HideNameplateAuras(unitId)
    end
end)
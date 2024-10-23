-- HIDE NAMEPLATE AND PLAYER AURAS

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
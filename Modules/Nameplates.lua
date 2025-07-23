-- Hide nameplate buffs for clean display
local function hideNameplateBuffs(unitId)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
    local unitFrame = nameplate and nameplate.UnitFrame
    
    if not unitFrame or unitFrame:IsForbidden() then
        return
    end
    
    unitFrame.BuffFrame:SetAlpha(0)
end

-- Handle nameplate unit added events
local function onNameplateAdded(self, eventType, unitId)
    hideNameplateBuffs(unitId)
end

-- Register nameplate events
local nameplateFrame = CreateFrame("Frame")
nameplateFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateFrame:SetScript("OnEvent", onNameplateAdded)
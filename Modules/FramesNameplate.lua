local function hideNameplateBuffs(unitId)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
    local unitFrame = nameplate and nameplate.UnitFrame
    
    if not unitFrame or unitFrame:IsForbidden() then 
        return 
    end
    
    unitFrame.BuffFrame:SetAlpha(0)
end

local function processNameplateEvent(self, event, unitId)
    hideNameplateBuffs(unitId)
end

-- Initialize nameplate modifications

local nameplateHandler = CreateFrame("Frame")
nameplateHandler:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateHandler:SetScript("OnEvent", processNameplateEvent)
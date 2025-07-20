
-- Hide buffs on nameplates for a cleaner display

local function hideBuffsOnNameplateForUnit(unitIdString)
    local nameplateFrame = C_NamePlate.GetNamePlateForUnit(unitIdString)
    local nameplateUnitFrame = nameplateFrame and nameplateFrame.UnitFrame

    if not nameplateUnitFrame or nameplateUnitFrame:IsForbidden() then
        return
    end

    nameplateUnitFrame.BuffFrame:SetAlpha(0)
end


-- Handle nameplate event to hide buffs

local function handleNameplateUnitAddedEvent(self, eventTypeString, unitIdString)
    hideBuffsOnNameplateForUnit(unitIdString)
end


-- Register event to initialize nameplate modifications

local nameplateBuffHiderEventFrame = CreateFrame("Frame")
nameplateBuffHiderEventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateBuffHiderEventFrame:SetScript("OnEvent", handleNameplateUnitAddedEvent)
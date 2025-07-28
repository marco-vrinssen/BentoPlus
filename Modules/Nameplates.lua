-- Hide nameplate buffs for a cleaner display.

local function hideNameplateBuffs(unitId)
  local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
  local unitFrame = nameplate and nameplate.UnitFrame

  if not unitFrame or unitFrame:IsForbidden() then
    return
  end

  unitFrame.BuffFrame:SetAlpha(0)
end

-- Handle the event when a nameplate unit is added.

local function handleNameplateAdded(self, eventType, unitId)
  hideNameplateBuffs(unitId)
end

-- Register nameplate events.

local nameplateEventsFrame = CreateFrame("Frame")
nameplateEventsFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateEventsFrame:SetScript("OnEvent", handleNameplateAdded)
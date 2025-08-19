-- Update nameplates to hide buffs so that we simplify view

local function suppressNameplateBuffs(unitToken)
  local targetNameplate = C_NamePlate.GetNamePlateForUnit(unitToken)
  local nameplateUnitFrame = targetNameplate and targetNameplate.UnitFrame

  if not nameplateUnitFrame or nameplateUnitFrame:IsForbidden() then
    return
  end

  nameplateUnitFrame.BuffFrame:SetScript("OnShow", function(buffFrame)
    buffFrame:Hide()
  end)
  nameplateUnitFrame.BuffFrame:Hide()
end

-- Handle nameplate add so that we hide buffs

local function processNameplateAdded(_, _, unitToken)
  suppressNameplateBuffs(unitToken)
end

-- Register nameplate events to hide buffs so that we enforce setting

local nameplateEventListener = CreateFrame("Frame")
nameplateEventListener:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateEventListener:SetScript("OnEvent", processNameplateAdded)
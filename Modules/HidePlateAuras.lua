-- Update nameplates to hide buffs so that we simplify view

local function hideNameplateBuffs(unitToken)
  local nameplate = C_NamePlate.GetNamePlateForUnit(unitToken)
  local unitFrame = nameplate and nameplate.UnitFrame

  if not unitFrame or unitFrame:IsForbidden() then
    return
  end

  unitFrame.BuffFrame:SetScript("OnShow", function(frame)
    frame:Hide()
  end)
  unitFrame.BuffFrame:Hide()
end

-- Handle nameplate add so that we hide buffs

local function handleNameplateAdded(_, _, unitToken)
  hideNameplateBuffs(unitToken)
end

-- Register nameplate events to hide buffs so that we enforce setting

local nameplateEventsFrame = CreateFrame("Frame")
nameplateEventsFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateEventsFrame:SetScript("OnEvent", handleNameplateAdded)
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

-- Add friendly-name suppression so that friendly player names never show, even when selected
local function suppressFriendlyNameText(unitToken)
  if not UnitIsFriend("player", unitToken) then return end

  local friendlyNameplate = C_NamePlate.GetNamePlateForUnit(unitToken)
  local nameplateUnitFrame = friendlyNameplate and friendlyNameplate.UnitFrame
  if not nameplateUnitFrame or nameplateUnitFrame:IsForbidden() then return end

  -- Try common fontstring fields used by Blizzard nameplates
  local nameTextRegion = nameplateUnitFrame.name
    or nameplateUnitFrame.Name
    or nameplateUnitFrame.nameText
    or nameplateUnitFrame.NameText
    or (nameplateUnitFrame.healthBar and (nameplateUnitFrame.healthBar.name or nameplateUnitFrame.healthBar.Name))

  if nameTextRegion then
    nameTextRegion:SetAlpha(0)
    nameTextRegion:Hide()
    -- Re-hide on show so that UI updates do not restore it
    if not nameTextRegion._bentoPlusHideHook then
      nameTextRegion._bentoPlusHideHook = true
      nameTextRegion:HookScript("OnShow", function(self)
        self:SetAlpha(0)
        self:Hide()
      end)
    end
  end
end

-- Apply requested nameplate CVars so that visuals match preferences on login
local function applyNameplateCVarsOnLogin()
  SetCVar("nameplateOverlapV", 0.5)
  SetCVar("nameplateMinAlpha", 1)
  SetCVar("nameplateNotSelectedAlpha", 1)
  SetCVar("nameplateSelectedAlpha", 1)
  C_NamePlate.SetNamePlateFriendlySize(80, 20)

  -- Hide friendly overhead names (non-nameplate) so that friendly names never appear
  SetCVar("UnitNameFriendlyPlayerName", 0)
end

-- Handle nameplate add so that we hide buffs and friendly names
local function processNameplateAdded(_, _, unitToken)
  suppressNameplateBuffs(unitToken)
  suppressFriendlyNameText(unitToken)
end

-- Register events and dispatch so that CVars apply at login and plates are sanitized on spawn
local nameplateEventListener = CreateFrame("Frame")
nameplateEventListener:RegisterEvent("PLAYER_LOGIN")
nameplateEventListener:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateEventListener:SetScript("OnEvent", function(_, eventName, ...)
  if eventName == "PLAYER_LOGIN" then
    applyNameplateCVarsOnLogin()
  elseif eventName == "NAME_PLATE_UNIT_ADDED" then
    processNameplateAdded(_, eventName, ...)
  end
end)
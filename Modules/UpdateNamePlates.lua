-- Update nameplates to hide buffs so that we simplify view

-- Do idempotent buff hiding on spawned nameplates so that buffs stay hidden without clobbering other scripts
local function suppressNameplateBuffs(unitToken)
  local targetNameplate = C_NamePlate.GetNamePlateForUnit(unitToken)
  local nameplateUnitFrame = targetNameplate and targetNameplate.UnitFrame
  if not nameplateUnitFrame or nameplateUnitFrame:IsForbidden() then return end

  local buffsFrame = nameplateUnitFrame.BuffFrame
  if not buffsFrame then return end

  if not buffsFrame._bentoPlusHideHook then
    buffsFrame._bentoPlusHideHook = true
    buffsFrame:HookScript("OnShow", function(frameToHide)
      frameToHide:Hide()
    end)
  end
  buffsFrame:Hide()
end

-- Do hide friendly name text on friendly nameplates so that friendly names never show, even when selected
local function suppressFriendlyNameText(unitToken)
  if not UnitIsFriend("player", unitToken) then return end

  local friendlyNameplate = C_NamePlate.GetNamePlateForUnit(unitToken)
  local nameplateUnitFrame = friendlyNameplate and friendlyNameplate.UnitFrame
  if not nameplateUnitFrame or nameplateUnitFrame:IsForbidden() then return end

  local nameTextField = nameplateUnitFrame.name
    or nameplateUnitFrame.Name
    or nameplateUnitFrame.nameText
    or nameplateUnitFrame.NameText
    or (nameplateUnitFrame.healthBar and (nameplateUnitFrame.healthBar.name or nameplateUnitFrame.healthBar.Name))

  if nameTextField then
    nameTextField:SetAlpha(0)
    nameTextField:Hide()
    if not nameTextField._bentoPlusHideHook then
      nameTextField._bentoPlusHideHook = true
      nameTextField:HookScript("OnShow", function(shownNameRegion)
        shownNameRegion:SetAlpha(0)
        shownNameRegion:Hide()
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

-- Do sanitize spawned nameplates so that buffs and friendly names are hidden consistently
local function handleNameplateUnitAdded(unitToken)
  suppressNameplateBuffs(unitToken)
  suppressFriendlyNameText(unitToken)
end

-- Do register events and dispatch minimally so that CVars apply at login and plates sanitize on spawn
local nameplateEventsDispatcher = CreateFrame("Frame")
nameplateEventsDispatcher:RegisterEvent("PLAYER_LOGIN")
nameplateEventsDispatcher:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateEventsDispatcher:SetScript("OnEvent", function(_, eventName, ...)
  if eventName == "PLAYER_LOGIN" then
    applyNameplateCVarsOnLogin()
  elseif eventName == "NAME_PLATE_UNIT_ADDED" then
    local unitToken = ...
    handleNameplateUnitAdded(unitToken)
  end
end)
-- Update tab targeting binding based on current player versus player context

local function updateTabTargeting()
  local _, instanceType = IsInInstance()
  local zoneCombatType = C_PvP.GetZonePVPInfo()

  local tabKey = "TAB"
  local bindingSet = GetCurrentBindingSet()

  if InCombatLockdown() or (bindingSet ~= 1 and bindingSet ~= 2) then
    return
  end

  local currentAction = GetBindingAction(tabKey)
  local targetAction

  if instanceType == "arena" or instanceType == "pvp" or zoneCombatType == "combat" then
    targetAction = "TARGETNEARESTENEMYPLAYER"
  else
    targetAction = "TARGETNEARESTENEMY"
  end

  if currentAction ~= targetAction then
    SetBinding(tabKey, targetAction)
    SaveBindings(bindingSet)
    if targetAction == "TARGETNEARESTENEMYPLAYER" then
      print("|cffffffffBentoPlus: Tab Targeting: |cffffff80PvP|r|cffffffff.|r")
    else
      print("|cffffffffBentoPlus: Tab Targeting: |cffffff80PvE|r|cffffffff.|r")
    end
  end
end

-- Register events to update tab targeting on zone changes

local tabTargetingFrame = CreateFrame("Frame")
tabTargetingFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
tabTargetingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
tabTargetingFrame:SetScript("OnEvent", updateTabTargeting)
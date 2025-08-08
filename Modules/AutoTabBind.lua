-- Update tab targeting binding based on current PvP context

local function updateTabTargeting()
  local inInstance, instanceType = IsInInstance()
  local zonePvpType = C_PvP.GetZonePVPInfo()

  local tabKey = "TAB"
  local bindingSet = GetCurrentBindingSet()

  if InCombatLockdown() or (bindingSet ~= 1 and bindingSet ~= 2) then
    return
  end

  local currentAction = GetBindingAction(tabKey)
  local targetAction

  if instanceType == "arena" or instanceType == "pvp" or zonePvpType == "combat" then
    targetAction = "TARGETNEARESTENEMYPLAYER"
  else
    targetAction = "TARGETNEARESTENEMY"
  end

  if currentAction ~= targetAction then
    SetBinding(tabKey, targetAction)
    SaveBindings(bindingSet)
    if targetAction == "TARGETNEARESTENEMYPLAYER" then
      print("|cffffffffBentoPlus: Tab targeting switched to |cffadc9ffPvP mode|r (enemy players only).")
    else
      print("|cffffffffBentoPlus: Tab targeting switched to |cffadc9ffPvE mode|r (all enemies).")
    end
  end
end

-- Register events to update tab targeting on zone changes

local pvpTabTargetingFrame = CreateFrame("Frame")
pvpTabTargetingFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
pvpTabTargetingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
pvpTabTargetingFrame:SetScript("OnEvent", updateTabTargeting)
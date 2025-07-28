-- Update tab targeting based on the current PvP context.

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
      print("PvP Tab")
    else
      print("PvE Tab")
    end
  end
end

-- Register events for tab targeting updates.

local pvpTabTargetingFrame = CreateFrame("Frame")
pvpTabTargetingFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
pvpTabTargetingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
pvpTabTargetingFrame:SetScript("OnEvent", updateTabTargeting)

-- Automatically release the ghost in PvP zones when no self-resurrect options are available.

local function autoReleaseInPvP()
  if C_DeathInfo.GetSelfResurrectOptions() and #C_DeathInfo.GetSelfResurrectOptions() > 0 then
    return
  end

  local inInstance, instanceType = IsInInstance()
  local zonePvpType = C_PvP.GetZonePVPInfo()

  if instanceType == "pvp" or zonePvpType == "combat" then
    C_Timer.After(0.5, function()
      local deathDialog = StaticPopup_FindVisible("DEATH")
      if deathDialog and deathDialog.button1 and deathDialog.button1:IsEnabled() then
        deathDialog.button1:Click()
      end
    end)
  end
end

-- Register events for automatic ghost release.

local pvpGhostReleaseFrame = CreateFrame("Frame")
pvpGhostReleaseFrame:RegisterEvent("PLAYER_DEAD")
pvpGhostReleaseFrame:SetScript("OnEvent", autoReleaseInPvP)
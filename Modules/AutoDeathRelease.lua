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
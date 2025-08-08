-- Release ghost automatically in PvP zones for faster respawn because no self-resurrection option is available.

local function autoReleasePvp()
  local selfResOptions = (C_DeathInfo and C_DeathInfo.GetSelfResurrectOptions) and C_DeathInfo.GetSelfResurrectOptions() or nil

  if selfResOptions and #selfResOptions > 0 then return end

  local _, instanceType = IsInInstance()
  local zonePvpType = GetZonePVPInfo()

  if instanceType == "pvp" or zonePvpType == "combat" then
    C_Timer.After(0.1, function()
      if UnitIsDead("player") and not UnitIsGhost("player") then
        if RepopMe then
          RepopMe()
        else
          local deathDialog = StaticPopup_FindVisible and StaticPopup_FindVisible("DEATH")
          if deathDialog and deathDialog.button1 and deathDialog.button1:IsEnabled() then
            deathDialog.button1:Click()
          end
        end
      end
    end)
  end
end

-- Register death event for automatic ghost release because we only act immediately upon player death.

local autoReleaseFrame = CreateFrame("Frame")
autoReleaseFrame:RegisterEvent("PLAYER_DEAD")
autoReleaseFrame:SetScript("OnEvent", autoReleasePvp)
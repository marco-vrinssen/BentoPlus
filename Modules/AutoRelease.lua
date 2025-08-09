-- Update death flow to auto release in player versus player zones so that we reduce downtime

local function autoReleasePlayer()
  local selfResurrectOptions = (C_DeathInfo and C_DeathInfo.GetSelfResurrectOptions) and C_DeathInfo.GetSelfResurrectOptions() or nil

  if selfResurrectOptions and #selfResurrectOptions > 0 then return end

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

-- Register death event to trigger release so that we automate flow

local releaseFrame = CreateFrame("Frame")
releaseFrame:RegisterEvent("PLAYER_DEAD")
releaseFrame:SetScript("OnEvent", autoReleasePlayer)
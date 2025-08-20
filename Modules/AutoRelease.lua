-- Auto-release in PvP zones to reduce downtime

local function auto_release()
  -- Skip when self-res is available

  local opts = (C_DeathInfo and C_DeathInfo.GetSelfResurrectOptions) and C_DeathInfo.GetSelfResurrectOptions() or nil
  if opts and #opts > 0 then return end

  -- Only act in PvP or active combat zones

  local _, itype = IsInInstance()
  local pvp = GetZonePVPInfo()
  if not (itype == "pvp" or pvp == "combat") then return end

  -- Defer slightly to let death UI settle

  C_Timer.After(0.1, function()
    if not UnitIsDead("player") or UnitIsGhost("player") then return end

    if RepopMe then
      RepopMe()
      return
    end

    local dlg = StaticPopup_FindVisible and StaticPopup_FindVisible("DEATH")
    if dlg and dlg.button1 and dlg.button1:IsEnabled() then
      dlg.button1:Click()
    end
  end)
end

-- Hook death event to auto-release

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_DEAD")
f:SetScript("OnEvent", auto_release)
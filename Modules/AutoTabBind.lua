-- Auto-update TAB target binding based on PvP/PvE context

-- update TAB binding on zone/instance change

local function tab_bind_update()
  local _, inst = IsInInstance()
  local zone = C_PvP.GetZonePVPInfo()

  local key = "TAB"
  local set = GetCurrentBindingSet()

  -- guard: skip during combat or when using account-wide bindings
  if InCombatLockdown() or (set ~= 1 and set ~= 2) then return end

  local cur = GetBindingAction(key)

  -- pick action based on PvP/PvE context
  local act = (inst == "arena" or inst == "pvp" or zone == "combat")
    and "TARGETNEARESTENEMYPLAYER"
    or  "TARGETNEARESTENEMY"

  if cur == act then return end

  -- write binding and notify
  SetBinding(key, act)
  SaveBindings(set)

  local mode = (act == "TARGETNEARESTENEMYPLAYER") and "PVP TAB" or "PVE TAB"
  print(mode)
end

-- register events for binding updates

local f = CreateFrame("Frame")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", tab_bind_update)
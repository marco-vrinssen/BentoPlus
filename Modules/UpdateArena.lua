if not BentoDB then BentoDB = {} end
if BentoDB.ArenaFrameElements == nil then
  BentoDB.ArenaFrameElements = false
end

-- Force hide a frame and prevent it from showing again

local function persistHideFrame(frame)
  if not frame then return end
  frame:SetScript("OnShow", frame.Hide)
  frame:Hide()
end

local function restoreFrame(frame)
  if not frame then return end
  if frame.GetScript and frame:GetScript("OnShow") == frame.Hide then
    frame:SetScript("OnShow", nil)
  end
  frame:Show()
end

-- Place the stealth icon in the top-left of the arena frame
local function positionStealthIcon(arenaFrame)
  if not arenaFrame then return end
  local icon = arenaFrame.StealthIcon
  if not icon then return end
  local function place(self)
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", arenaFrame, "TOPLEFT", 2, -2)
  end
  place(icon)
  icon:SetScript("OnShow", place)
end

-- Hide unwanted arena frame subframes and reposition elements

local function styleArenaFrame(frame)
  if not frame then return end
  if BentoDB.ArenaFrameElements then
    restoreFrame(frame.name)
    restoreFrame(frame.CcRemoverFrame)
    restoreFrame(frame.DebuffFrame)
  else
    persistHideFrame(frame.name)
    persistHideFrame(frame.CcRemoverFrame)
    persistHideFrame(frame.DebuffFrame)
  end
  positionStealthIcon(frame)
end

-- Iterate and style all arena member frames

local function styleArenaFrames()
  local i = 1
  while true do
    local arenaMemberFrame = _G["CompactArenaFrameMember" .. i]
    if not arenaMemberFrame then break end
    styleArenaFrame(arenaMemberFrame)
    i = i + 1
  end
end

-- Sync castbar CVar with saved setting using modern name
local function applyCastbarVisibility()
  local value = BentoDB.ArenaFrameElements and 1 or 0
  if C_CVar and C_CVar.SetCVar then
    C_CVar.SetCVar("showarenaenemycast", value)
  else
    SetCVar("showarenaenemycast", value)
  end
end

-- Toggle arena frame element visibility state

local function toggleArenaElements()
  BentoDB.ArenaFrameElements = not BentoDB.ArenaFrameElements
  if BentoDB.ArenaFrameElements then
    print("|cffffffffBentoPlus: Arena Elements: |cffffff80Visible|r|cffffffff.|r")
  else
    print("|cffffffffBentoPlus: Arena Elements: |cffffff80Hidden|r|cffffffff.|r")
  end
  applyCastbarVisibility()
  styleArenaFrames()
end

-- Register slash command for arena element toggling

SLASH_BENTOPLUS_ARENAFRAMEELEMENTS1 = "/bentoarena"
SlashCmdList.BENTOPLUS_ARENAFRAMEELEMENTS = toggleArenaElements

-- Manage login and world entry events for arena frame styling

local arenaEventFrame = CreateFrame("Frame")
arenaEventFrame:RegisterEvent("PLAYER_LOGIN")
arenaEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
arenaEventFrame:RegisterEvent("ARENA_OPPONENT_UPDATE")
arenaEventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
arenaEventFrame:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGIN" then
    -- Keep quiet here; Intro.lua already prints available commands.
    applyCastbarVisibility()
  elseif event == "PLAYER_ENTERING_WORLD" then
    styleArenaFrames()
  else
    -- Update dynamically as opponents/party state changes
    styleArenaFrames()
  end
end)
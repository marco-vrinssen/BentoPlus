-- Initialize saved variable for arena frame elements visibility

if not BentoDB then BentoDB = {} end
if BentoDB.ArenaFrameElements == nil then
  BentoDB.ArenaFrameElements = false
end

-- Helper to standardize addon printed messages

local function arenaPrintHelper(msg)
  if msg then
    print("BentoPlus: " .. msg)
  end
end

-- Force hide a frame and prevent it from showing again

local function persistHideFrame(frame)
  if not frame then return end
  frame:SetScript("OnShow", frame.Hide)
  frame:Hide()
end

-- Reposition stealth icon inside arena frame for clarity

local function positionStealthIcon(frame)
  local icon = frame and frame.StealthIcon
  if not icon then return end
  icon:SetScript("OnShow", function(self)
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
  end)
end

-- Hide unwanted arena frame subframes and reposition elements

local function styleArenaFrame(frame)
  if not frame then return end
  persistHideFrame(frame.name)
  persistHideFrame(frame.CcRemoverFrame)
  persistHideFrame(frame.DebuffFrame)
  positionStealthIcon(frame)
end

local maxArenaEnemies = _G.MAX_ARENA_ENEMIES or 5

-- Iterate and style all arena member frames

local function styleArenaFrames()
  for i = 1, maxArenaEnemies do
    local arenaMemberFrame = _G["CompactArenaFrameMember" .. i]
    if arenaMemberFrame then
      styleArenaFrame(arenaMemberFrame)
    end
  end
end

-- Sync castbar CVar with saved setting

local function applyCastbarVisibility()
  SetCVar("showArenaEnemyCastbar", BentoDB.ArenaFrameElements and 1 or 0)
end

-- Toggle arena frame element visibility state

local function toggleArenaElements()
  BentoDB.ArenaFrameElements = not BentoDB.ArenaFrameElements
  arenaPrintHelper(BentoDB.ArenaFrameElements and "Arena frame elements restored (castbar shown)." or "Arena frame elements modified (castbar hidden).")
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
arenaEventFrame:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGIN" then
    applyCastbarVisibility()
    if not BentoDB.ArenaFrameElements then
      arenaPrintHelper("Arena frame elements modified by default (castbar hidden). Use /bentoarena to toggle.")
    end
  elseif event == "PLAYER_ENTERING_WORLD" then
    styleArenaFrames()
  end
end)
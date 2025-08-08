-- Update savedVars to initialize arena frame config

if not BentoDB then BentoDB = {} end
if BentoDB.ArenaFrameElements == nil then
  BentoDB.ArenaFrameElements = false
end

-- Update printHelper to standardize addon messages

local function arenaPrintHelper(msg)
  if msg then
    print("BentoPlus: " .. msg)
  end
end

-- Update persistHideFrame to prevent frame reappearing

local function persistHideFrame(frame)
  if not frame then return end
  frame:SetScript("OnShow", frame.Hide)
  frame:Hide()
end

-- Update positionStealthIcon to adjust icon placement

local function positionStealthIcon(frame)
  local icon = frame and frame.StealthIcon
  if not icon then return end
  icon:SetScript("OnShow", function(self)
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
  end)
end

-- Update styleArenaFrame to hide unwanted subframes

local function styleArenaFrame(frame)
  if not frame then return end
  persistHideFrame(frame.name)
  persistHideFrame(frame.CcRemoverFrame)
  persistHideFrame(frame.DebuffFrame)
  positionStealthIcon(frame)
end

local maxArenaEnemies = _G.MAX_ARENA_ENEMIES or 5

-- Update styleAllArenaFrames to iterate and style members

local function styleAllArenaFrames()
  for i = 1, maxArenaEnemies do
    local arenaMemberFrame = _G["CompactArenaFrameMember" .. i]
    if arenaMemberFrame then
      styleArenaFrame(arenaMemberFrame)
    end
  end
end

-- Update applyCastbarVisibility to sync CVar with setting

local function applyCastbarVisibility()
  SetCVar("showArenaEnemyCastbar", BentoDB.ArenaFrameElements and 1 or 0)
end

-- Update toggleArenaElements to invert setting and restyle

local function toggleArenaElements()
  BentoDB.ArenaFrameElements = not BentoDB.ArenaFrameElements
  arenaPrintHelper(BentoDB.ArenaFrameElements and "Arena frame elements restored (castbar shown)." or "Arena frame elements modified (castbar hidden).")
  applyCastbarVisibility()
  styleAllArenaFrames()
end

-- Update slashCommand to register arena toggle

SLASH_BENTOPLUS_ARENAFRAMEELEMENTS1 = "/bentoarena"
SlashCmdList.BENTOPLUS_ARENAFRAMEELEMENTS = toggleArenaElements

-- Update arenaEventFrame to manage login and world entry

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
    styleAllArenaFrames()
  end
end)
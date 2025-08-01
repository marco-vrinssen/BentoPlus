-- Arena frame modification constants and database initialization

local ARENA_ELEMENTS_VISIBILITY_KEY = "ArenaFrameElements"
local MAXIMUM_ARENA_MEMBERS = 5
local CROWD_CONTROL_FRAME_SIZE = 40
local DEBUFF_FRAME_SIZE = 40

-- Initialize database for arena frame element visibility state

if not BentoDB then
  BentoDB = {}
end
if BentoDB[ARENA_ELEMENTS_VISIBILITY_KEY] == nil then
  BentoDB[ARENA_ELEMENTS_VISIBILITY_KEY] = false
end

-- Core arena frame element configuration functions

local function hideCastingBarFrame(arenaFrame)
  if not arenaFrame.CastingBarFrame then
    return
  end
  
  arenaFrame.CastingBarFrame:SetScript("OnShow", function(self)
    self:Hide()
  end)
  arenaFrame.CastingBarFrame:Hide()
end

local function hideNameText(arenaFrame)
  if not arenaFrame.name then
    return
  end
  
  arenaFrame.name:SetScript("OnShow", function(self)
    self:Hide()
  end)
  arenaFrame.name:Hide()
end

local function configureCrowdControlRemover(arenaFrame)
  if not arenaFrame.CcRemoverFrame then
    return
  end

  local crowdControlFrame = arenaFrame.CcRemoverFrame
  crowdControlFrame:SetSize(CROWD_CONTROL_FRAME_SIZE, CROWD_CONTROL_FRAME_SIZE)
  crowdControlFrame:ClearAllPoints()
  crowdControlFrame:SetPoint("TOPLEFT", arenaFrame, "TOPRIGHT")
end

local function repositionStealthIcon(arenaFrame)
  if not arenaFrame.StealthIcon then
    return
  end

  arenaFrame.StealthIcon:SetScript("OnShow", function(self)
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", arenaFrame, "TOPLEFT", 2, -2)
  end)
end

local function configureDebuffFrame(arenaFrame)
  if not arenaFrame.DebuffFrame then
    return
  end

  local debuffFrame = arenaFrame.DebuffFrame
  debuffFrame:SetScript("OnShow", function(self)
    self:SetSize(DEBUFF_FRAME_SIZE, DEBUFF_FRAME_SIZE)
    self:ClearAllPoints()
    self:SetPoint("BOTTOMLEFT", arenaFrame, "BOTTOMLEFT", 2, 2)
  end)
end

-- Main arena frame configuration orchestrator

local function configureIndividualArenaFrame(arenaFrame)
  if not arenaFrame then
    return
  end

  hideCastingBarFrame(arenaFrame)
  hideNameText(arenaFrame)
  configureCrowdControlRemover(arenaFrame)
  repositionStealthIcon(arenaFrame)
  configureDebuffFrame(arenaFrame)
end

local function configureAllArenaFrames()
  for arenaIndex = 1, MAXIMUM_ARENA_MEMBERS do
    local arenaFrame = _G["CompactArenaFrameMember" .. arenaIndex]
    if arenaFrame then
      configureIndividualArenaFrame(arenaFrame)
    end
  end
end

-- Arena frame visibility toggle functionality

local function printToggleStatusMessage()
  if BentoDB[ARENA_ELEMENTS_VISIBILITY_KEY] then
    print("|cffffffffBentoPlus: Arena frame elements are now |cffadc9ffrestored|r to default appearance.")
  else
    print("|cffffffffBentoPlus: Arena frame elements are now |cffadc9ffmodified|r for better visibility.")
  end
end

local function toggleArenaElementsVisibility()
  BentoDB[ARENA_ELEMENTS_VISIBILITY_KEY] = not BentoDB[ARENA_ELEMENTS_VISIBILITY_KEY]
  printToggleStatusMessage()
  configureAllArenaFrames()
end

-- Slash command registration for arena frame toggle

SLASH_BENTOPLUS_ARENAFRAMEELEMENTS1 = "/bentoarenaframe"
SlashCmdList["BENTOPLUS_ARENAFRAMEELEMENTS"] = toggleArenaElementsVisibility

-- Event handlers for initialization and login notifications

local function handlePlayerLogin()
  if not BentoDB[ARENA_ELEMENTS_VISIBILITY_KEY] then
    print("|cffffffffBentoPlus: Arena frame elements are |cffadc9ffmodified|r by default. Use |cffadc9ff/bentoarenaframe|r to toggle.")
  end
end

local arenaFrameLoginNotification = CreateFrame("Frame")
arenaFrameLoginNotification:RegisterEvent("PLAYER_LOGIN")
arenaFrameLoginNotification:SetScript("OnEvent", handlePlayerLogin)

local arenaFrameInitialization = CreateFrame("Frame")
arenaFrameInitialization:RegisterEvent("PLAYER_ENTERING_WORLD")
arenaFrameInitialization:SetScript("OnEvent", configureAllArenaFrames)
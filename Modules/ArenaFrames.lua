-- Arena frame database initialization

if not BentoDB then
  BentoDB = {}
end
if BentoDB.ArenaFrameElements == nil then
  BentoDB.ArenaFrameElements = false
end

-- Core frame hiding functions

local function hideArenaCastingBar(arenaFrame)
  if not arenaFrame.CastingBarFrame then
    return
  end
  
  arenaFrame.CastingBarFrame:SetScript("OnShow", function(self)
    self:Hide()
  end)
  arenaFrame.CastingBarFrame:Hide()
end

local function hideArenaNameText(arenaFrame)
  if not arenaFrame.name then
    return
  end
  
  arenaFrame.name:SetScript("OnShow", function(self)
    self:Hide()
  end)
  arenaFrame.name:Hide()
end

local function hideArenaCcRemover(arenaFrame)
  if not arenaFrame.CcRemoverFrame then
    return
  end

  arenaFrame.CcRemoverFrame:SetScript("OnShow", function(self)
    self:Hide()
  end)
  arenaFrame.CcRemoverFrame:Hide()
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

local function hideArenaDebuffFrame(arenaFrame)
  if not arenaFrame.DebuffFrame then
    return
  end

  arenaFrame.DebuffFrame:SetScript("OnShow", function(self)
    self:Hide()
  end)
  arenaFrame.DebuffFrame:Hide()
end

-- Main configuration functions

local function configureArenaFrame(arenaFrame)
  if not arenaFrame then
    return
  end

  hideArenaCastingBar(arenaFrame)
  hideArenaNameText(arenaFrame)
  hideArenaCcRemover(arenaFrame)
  repositionStealthIcon(arenaFrame)
  hideArenaDebuffFrame(arenaFrame)
end

local function configureAllArenaFrames()
  for arenaIndex = 1, 5 do
    local arenaFrame = _G["CompactArenaFrameMember" .. arenaIndex]
    if arenaFrame then
      configureArenaFrame(arenaFrame)
    end
  end
end

-- Toggle functionality

local function printArenaToggleStatus()
  if BentoDB.ArenaFrameElements then
    print("|cffffffffBentoPlus: Arena frame elements are now |cffadc9ffrestored|r to default appearance.")
  else
    print("|cffffffffBentoPlus: Arena frame elements are now |cffadc9ffmodified|r for better visibility.")
  end
end

local function toggleArenaElements()
  BentoDB.ArenaFrameElements = not BentoDB.ArenaFrameElements
  printArenaToggleStatus()
  configureAllArenaFrames()
end

-- Slash command registration

SLASH_BENTOPLUS_ARENAFRAMEELEMENTS1 = "/bentoarenaframe"
SlashCmdList["BENTOPLUS_ARENAFRAMEELEMENTS"] = toggleArenaElements

-- Event handlers

local function handleArenaPlayerLogin()
  if not BentoDB.ArenaFrameElements then
    print("|cffffffffBentoPlus: Arena frame elements are |cffadc9ffmodified|r by default. Use |cffadc9ff/bentoarenaframe|r to toggle.")
  end
end

local arenaLoginFrame = CreateFrame("Frame")
arenaLoginFrame:RegisterEvent("PLAYER_LOGIN")
arenaLoginFrame:SetScript("OnEvent", handleArenaPlayerLogin)

local arenaInitFrame = CreateFrame("Frame")
arenaInitFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
arenaInitFrame:SetScript("OnEvent", configureAllArenaFrames)
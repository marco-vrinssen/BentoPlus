-- Arena frame database initialization

if not BentoDB then
  BentoDB = {}
end
if BentoDB.ArenaFrameElements == nil then
  BentoDB.ArenaFrameElements = false
end

-- Core frame hiding functions

local function hideCastBar(arenaFrame)
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

local function hideCcRemover(arenaFrame)
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

local function hideDebuffFrame(arenaFrame)
  if not arenaFrame.DebuffFrame then
    return
  end

  arenaFrame.DebuffFrame:SetScript("OnShow", function(self)
    self:Hide()
  end)
  arenaFrame.DebuffFrame:Hide()
end

-- Main configuration functions

local function configFrame(arenaFrame)
  if not arenaFrame then
    return
  end

  hideCastBar(arenaFrame)
  hideNameText(arenaFrame)
  hideCcRemover(arenaFrame)
  repositionStealthIcon(arenaFrame)
  hideDebuffFrame(arenaFrame)
end

local function configAllFrames()
  for arenaIndex = 1, 5 do
    local arenaFrame = _G["CompactArenaFrameMember" .. arenaIndex]
    if arenaFrame then
      configFrame(arenaFrame)
    end
  end
end

-- Toggle functionality

local function printToggleStatus()
  if BentoDB.ArenaFrameElements then
    print("|cffffffffBentoPlus: Arena frame elements are now |cffadc9ffrestored|r to default appearance.")
  else
    print("|cffffffffBentoPlus: Arena frame elements are now |cffadc9ffmodified|r for better visibility.")
  end
end

local function toggleElements()
  BentoDB.ArenaFrameElements = not BentoDB.ArenaFrameElements
  printToggleStatus()
  configAllFrames()
end

-- Slash command registration

SLASH_BENTOPLUS_ARENAFRAMEELEMENTS1 = "/bentoarena"
SlashCmdList["BENTOPLUS_ARENAFRAMEELEMENTS"] = toggleElements

-- Event handlers

local function handleLogin()
  if not BentoDB.ArenaFrameElements then
    print("|cffffffffBentoPlus: Arena frame elements are |cffadc9ffmodified|r by default. Use |cffadc9ff/bentoarena|r to toggle.")
  end
end

local loginFrame = CreateFrame("Frame")
loginFrame:RegisterEvent("PLAYER_LOGIN")
loginFrame:SetScript("OnEvent", handleLogin)

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
initFrame:SetScript("OnEvent", configAllFrames)
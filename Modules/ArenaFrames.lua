
-- Hide elements within a given arena frame.

local function hideFrameElements(arenaFrame)
  if not arenaFrame then
    return
  end

  local frameElements = {
    arenaFrame.CastingBarFrame,
    arenaFrame.CcRemoverFrame,
    arenaFrame.name,
    arenaFrame.DebuffFrame
  }

  for _, frameElement in ipairs(frameElements) do
    if frameElement then
      frameElement:SetScript("OnShow", function(self)
        self:Hide()
      end)
      frameElement:Hide()
    end
  end
end

-- Reposition the stealth icon for a given arena frame.

local function repositionStealthIcon(arenaFrame)
  if not arenaFrame or not arenaFrame.StealthIcon then
    return
  end

  arenaFrame.StealthIcon:SetScript("OnShow", function(self)
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", arenaFrame, "TOPRIGHT")
  end)
end

-- Configure all arena frames.

local function configureArenaFrames()
  for arenaIndex = 1, 5 do
    local arenaFrame = _G["CompactArenaFrameMember" .. arenaIndex]
    hideFrameElements(arenaFrame)
    repositionStealthIcon(arenaFrame)
  end
end

-- Defer frame configuration until the player enters the world.

local arenaFrameConfiguration = CreateFrame("Frame")
arenaFrameConfiguration:RegisterEvent("PLAYER_ENTERING_WORLD")
arenaFrameConfiguration:SetScript("OnEvent", configureArenaFrames)
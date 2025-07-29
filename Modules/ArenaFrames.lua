-- Initialize database for storing arena frame element visibility state

local arenaElementsVisibilityState = "ArenaFrameElements"

if not BentoDB then
  BentoDB = {}
end
if BentoDB[arenaElementsVisibilityState] == nil then
  BentoDB[arenaElementsVisibilityState] = false
end

-- Hide or show toggleable elements within arena frame based on settings

local function configureFrameElements(arenaFrame)
  if not arenaFrame then
    return
  end

  local toggleableElements = {
    arenaFrame.CastingBarFrame,
    arenaFrame.name,
    arenaFrame.DebuffFrame
  }

  for _, frameElement in ipairs(toggleableElements) do
    if frameElement then
      if BentoDB[arenaElementsVisibilityState] then
        frameElement:SetScript("OnShow", nil)
        frameElement:Show()
      else
        frameElement:SetScript("OnShow", function(self)
          self:Hide()
        end)
        frameElement:Hide()
      end
    end
  end
end

-- Configure crowd control remover frame size and position

local function configureCrowdControlRemover(arenaFrame)
  if not arenaFrame or not arenaFrame.CcRemoverFrame then
    return
  end

  local crowdControlFrame = arenaFrame.CcRemoverFrame
  crowdControlFrame:SetSize(40, 40)
  crowdControlFrame:ClearAllPoints()
  crowdControlFrame:SetPoint("TOPLEFT", arenaFrame, "TOPRIGHT")
end

-- Reposition stealth icon for arena frame

local function repositionStealthIcon(arenaFrame)
  if not arenaFrame or not arenaFrame.StealthIcon then
    return
  end

  arenaFrame.StealthIcon:SetScript("OnShow", function(self)
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", arenaFrame, "TOPRIGHT")
  end)
end

-- Configure all arena frames with current settings

local function configureAllArenaFrames()
  for arenaIndex = 1, 5 do
    local arenaFrame = _G["CompactArenaFrameMember" .. arenaIndex]
    if arenaFrame then
      configureFrameElements(arenaFrame)
      configureCrowdControlRemover(arenaFrame)
      repositionStealthIcon(arenaFrame)
    end
  end
end

-- Toggle visibility of arena frame elements and refresh all frames

local function toggleElementsVisibility()
  BentoDB[arenaElementsVisibilityState] = not BentoDB[arenaElementsVisibilityState]
  if BentoDB[arenaElementsVisibilityState] then
    print("|cffffffffBentoPlus: Arena frame elements are now |cff0080ffshown|r.")
  else
    print("|cffffffffBentoPlus: Arena frame elements are now |cff0080ffhidden|r.")
  end
  configureAllArenaFrames()
end

-- Register slash command for toggling arena frame elements

SLASH_BENTOPLUS_ARENAFRAMEELEMENTS1 = "/arenaframeelements"
SlashCmdList["BENTOPLUS_ARENAFRAMEELEMENTS"] = toggleElementsVisibility

-- Show notification on login if arena frame elements are hidden

local arenaFrameLoginFrame = CreateFrame("Frame")
arenaFrameLoginFrame:RegisterEvent("PLAYER_LOGIN")
arenaFrameLoginFrame:SetScript("OnEvent", function()
  if not BentoDB[arenaElementsVisibilityState] then
    print("|cffffffffBentoPlus: Arena frame elements are |cff0080ffhidden|r by default. Use /arenaframeelements to toggle.")
  end
end)

-- Defer frame configuration until player enters the world

local arenaFrameConfiguration = CreateFrame("Frame")
arenaFrameConfiguration:RegisterEvent("PLAYER_ENTERING_WORLD")
arenaFrameConfiguration:SetScript("OnEvent", configureAllArenaFrames)
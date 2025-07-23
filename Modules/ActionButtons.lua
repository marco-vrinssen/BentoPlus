-- Find and scale button flipbook by twenty percent
local function findScaleFlipbook(button)
  if not button then
    return
  end

  local flipbook = nil

  if button.AssistedCombatHighlightFrame then
    if button.AssistedCombatHighlightFrame.Flipbook then
      flipbook = button.AssistedCombatHighlightFrame.Flipbook
    elseif button.AssistedCombatHighlightFrame.flipbook then
      flipbook = button.AssistedCombatHighlightFrame.flipbook
    end
  end

  if not flipbook and button.AssistedCombatHighlightFrame then
    local regions = {button.AssistedCombatHighlightFrame:GetRegions()}
    for _, region in ipairs(regions) do
      if region and region:GetObjectType() == "Texture" and
          (region:GetName() and
           string.find(region:GetName():lower(), "flipbook")) then
        flipbook = region
        break
      end
    end
  end

  if flipbook and not flipbook._bento_scaled then
    local width, height = flipbook:GetSize()

    if width <= 0 or height <= 0 then
      local buttonWidth, buttonHeight = button:GetSize()
      width, height = buttonWidth, buttonHeight
    end

    if width > 0 and height > 0 then
      flipbook:ClearAllPoints()
      flipbook:SetPoint("CENTER", button, "CENTER", 0, 0)
      flipbook:SetSize(width * 1.2, height * 1.2)
      flipbook._bento_scaled = true
      return true
    end
  end

  return false
end

-- Process single button flipbook
local function processButton(button)
  if not button then
    return
  end
  findScaleFlipbook(button)
end

-- Collect all button names
local function getAllButtons()
  local patterns = {
    "ActionButton",
    "MultiBarBottomLeftButton",
    "MultiBarBottomRightButton",
    "MultiBarRightButton",
    "MultiBarLeftButton",
    "MultiBar5Button",
    "MultiBar6Button",
    "MultiBar7Button",
    "PetActionButton",
    "StanceButton",
    "OverrideActionBarButton",
    "VehicleMenuBarActionButton"
  }

  local buttons = {}
  for _, pattern in ipairs(patterns) do
    local maxCount = 12
    if pattern == "PetActionButton" or pattern == "StanceButton" then
      maxCount = 10
    elseif pattern == "OverrideActionBarButton" or
           pattern == "VehicleMenuBarActionButton" then
      maxCount = 6
    end

    for index = 1, maxCount do
      local button = _G[pattern .. index]
      if button then
        table.insert(buttons, button)
      end
    end
  end

  return buttons
end

-- Process all discovered buttons
local function processAllButtons()
  local buttons = getAllButtons()

  for _, button in ipairs(buttons) do
    findScaleFlipbook(button)
  end
end

-- Schedule delayed processing
local function scheduleDelayed()
  C_Timer.After(2, function()
    processAllButtons()
    C_Timer.After(3, processAllButtons)
  end)
end

-- Initialize event system
local eventFrame = CreateFrame("Frame")
local eventsRegistered = false

-- Register required game events
local function registerEvents()
  if eventsRegistered then
    return
  end

  eventFrame:RegisterEvent("ADDON_LOADED")
  eventFrame:RegisterEvent("PLAYER_LOGIN")
  eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  eventFrame:RegisterEvent("ACTIONBAR_SHOWGRID")
  eventFrame:RegisterEvent("ACTIONBAR_HIDEGRID")
  eventFrame:RegisterEvent("UPDATE_BINDINGS")
  eventFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")

  eventsRegistered = true
end

eventFrame:SetScript("OnEvent", function(self, eventName, addonName)
  if eventName == "ADDON_LOADED" and addonName == "BentoPlus" then
    scheduleDelayed()
  elseif eventName == "PLAYER_LOGIN" or eventName == "PLAYER_ENTERING_WORLD" then
    scheduleDelayed()
  else
    C_Timer.After(0.1, processAllButtons)
  end
end)

registerEvents()

-- Hook button creation for dynamic processing
local originalOnLoad = ActionButton_OnLoad
if originalOnLoad then
  ActionButton_OnLoad = function(self, ...)
    originalOnLoad(self, ...)
    C_Timer.After(0.5, function()
      processButton(self)
    end)
  end
end
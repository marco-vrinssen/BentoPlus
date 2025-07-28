local highlightScaleFactor = 1.1
local isScaledFlag = "_bentoPlusCombatHighlightScaled"

-- Scale combat highlight animation.

local function scaleHighlightAnimation(actionButton)
  if not actionButton then
    return false
  end

  local combatFlipbook = nil
  local highlightFrame = actionButton.AssistedCombatHighlightFrame

  if highlightFrame then
    if highlightFrame.Flipbook then
      combatFlipbook = highlightFrame.Flipbook
    elseif highlightFrame.flipbook then
      combatFlipbook = highlightFrame.flipbook
    end
  end

  if not combatFlipbook and highlightFrame then
    local regions = {highlightFrame:GetRegions()}
    for _, region in ipairs(regions) do
      if region and region:GetObjectType() == "Texture" and
          (region:GetName() and
           string.find(region:GetName():lower(), "flipbook")) then
        combatFlipbook = region
        break
      end
    end
  end

  if combatFlipbook and not combatFlipbook[isScaledFlag] then
    local flipbookWidth, flipbookHeight = combatFlipbook:GetSize()

    if flipbookWidth <= 0 or flipbookHeight <= 0 then
      local buttonWidth, buttonHeight = actionButton:GetSize()
      flipbookWidth, flipbookHeight = buttonWidth, buttonHeight
    end

    if flipbookWidth > 0 and flipbookHeight > 0 then
      combatFlipbook:ClearAllPoints()
      combatFlipbook:SetPoint("CENTER", actionButton, "CENTER", 0, 0)
      combatFlipbook:SetSize(flipbookWidth * highlightScaleFactor, flipbookHeight * highlightScaleFactor)
      combatFlipbook[isScaledFlag] = true
      return true
    end
  end

  return false
end

-- Process highlight for a single button.

local function processSingleButton(actionButton)
  if not actionButton then
    return
  end
  scaleHighlightAnimation(actionButton)
end

-- Define patterns for all action buttons.

local actionButtonDefinitions = {
  {pattern = "ActionButton", maxCount = 12},
  {pattern = "MultiBarBottomLeftButton", maxCount = 12},
  {pattern = "MultiBarBottomRightButton", maxCount = 12},
  {pattern = "MultiBarRightButton", maxCount = 12},
  {pattern = "MultiBarLeftButton", maxCount = 12},
  {pattern = "MultiBar5Button", maxCount = 12},
  {pattern = "MultiBar6Button", maxCount = 12},
  {pattern = "MultiBar7Button", maxCount = 12},
  {pattern = "PetActionButton", maxCount = 10},
  {pattern = "StanceButton", maxCount = 10},
  {pattern = "OverrideActionBarButton", maxCount = 6},
  {pattern = "VehicleMenuBarActionButton", maxCount = 6}
}

-- Collect all available action buttons.

local function collectActionButtons()
  local actionButtons = {}
  
  for _, buttonInfo in ipairs(actionButtonDefinitions) do
    local buttonPattern = buttonInfo.pattern
    local maxCount = buttonInfo.maxCount

    for buttonIndex = 1, maxCount do
      local buttonName = buttonPattern .. buttonIndex
      local buttonFrame = _G[buttonName]
      
      if buttonFrame then
        table.insert(actionButtons, buttonFrame)
      end
    end
  end

  return actionButtons
end

-- Process highlights for all collected buttons.

local function processAllButtons()
  local allButtons = collectActionButtons()

  for _, actionButton in ipairs(allButtons) do
    scaleHighlightAnimation(actionButton)
  end
end

-- Define constants for delayed processing.

local initialDelay = 2
local secondaryDelay = 3
local quickDelay = 0.1
local buttonCreationDelay = 0.5

-- Schedule delayed processing of highlights.

local function scheduleDelayedProcessing()
  C_Timer.After(initialDelay, function()
    processAllButtons()
    C_Timer.After(secondaryDelay, processAllButtons)
  end)
end

-- Create a frame to handle action button events.

local actionButtonEventFrame = CreateFrame("Frame", "BentoPlusActionButtonEventFrame")
local areEventsRegistered = false

-- Register events for the action button frame.

local function registerButtonEvents()
  if areEventsRegistered then
    return
  end

  actionButtonEventFrame:RegisterEvent("ADDON_LOADED")
  actionButtonEventFrame:RegisterEvent("PLAYER_LOGIN")
  actionButtonEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  actionButtonEventFrame:RegisterEvent("ACTIONBAR_SHOWGRID")
  actionButtonEventFrame:RegisterEvent("ACTIONBAR_HIDEGRID")
  actionButtonEventFrame:RegisterEvent("UPDATE_BINDINGS")
  actionButtonEventFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")

  areEventsRegistered = true
end

-- Set event handler for the action button frame.

actionButtonEventFrame:SetScript("OnEvent", function(self, eventName, addonName)
  if eventName == "ADDON_LOADED" and addonName == "BentoPlus" then
    scheduleDelayedProcessing()
  elseif eventName == "PLAYER_LOGIN" or eventName == "PLAYER_ENTERING_WORLD" then
    scheduleDelayedProcessing()
  else
    C_Timer.After(quickDelay, processAllButtons)
  end
end)

registerButtonEvents()

-- Hook into action button creation to process highlights.

local originalActionButtonOnLoad = ActionButton_OnLoad
if originalActionButtonOnLoad then
  ActionButton_OnLoad = function(actionButton, ...)
    originalActionButtonOnLoad(actionButton, ...)
    C_Timer.After(buttonCreationDelay, function()
      processSingleButton(actionButton)
    end)
  end
end
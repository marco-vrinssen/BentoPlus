-- Constants for flipbook scaling
local FLIPBOOK_SCALE_FACTOR = 1.2
local BENTO_SCALED_FLAG = "_bentoplus_combat_highlight_scaled"

-- Find and scale combat highlight flipbook animation by twenty percent
local function ActionButton_ScaleCombatHighlightFlipbook(actionButton)
  if not actionButton then
    return false
  end

  local combatHighlightFlipbook = nil
  local combatHighlightFrame = actionButton.AssistedCombatHighlightFrame

  -- First, try to find flipbook through direct property access
  if combatHighlightFrame then
    if combatHighlightFrame.Flipbook then
      combatHighlightFlipbook = combatHighlightFrame.Flipbook
    elseif combatHighlightFrame.flipbook then
      combatHighlightFlipbook = combatHighlightFrame.flipbook
    end
  end

  -- If not found, search through all regions for flipbook texture
  if not combatHighlightFlipbook and combatHighlightFrame then
    local frameRegions = {combatHighlightFrame:GetRegions()}
    for _, frameRegion in ipairs(frameRegions) do
      if frameRegion and frameRegion:GetObjectType() == "Texture" and
          (frameRegion:GetName() and
           string.find(frameRegion:GetName():lower(), "flipbook")) then
        combatHighlightFlipbook = frameRegion
        break
      end
    end
  end

  -- Scale the flipbook if found and not already scaled
  if combatHighlightFlipbook and not combatHighlightFlipbook[BENTO_SCALED_FLAG] then
    local flipbookWidth, flipbookHeight = combatHighlightFlipbook:GetSize()

    -- Fallback to button size if flipbook size is invalid
    if flipbookWidth <= 0 or flipbookHeight <= 0 then
      local buttonWidth, buttonHeight = actionButton:GetSize()
      flipbookWidth, flipbookHeight = buttonWidth, buttonHeight
    end

    -- Apply scaling transformation
    if flipbookWidth > 0 and flipbookHeight > 0 then
      combatHighlightFlipbook:ClearAllPoints()
      combatHighlightFlipbook:SetPoint("CENTER", actionButton, "CENTER", 0, 0)
      combatHighlightFlipbook:SetSize(flipbookWidth * FLIPBOOK_SCALE_FACTOR, flipbookHeight * FLIPBOOK_SCALE_FACTOR)
      combatHighlightFlipbook[BENTO_SCALED_FLAG] = true
      return true
    end
  end

  return false
end

-- Process combat highlight scaling for a single action button
local function ActionButton_ProcessCombatHighlight(actionButton)
  if not actionButton then
    return
  end
  ActionButton_ScaleCombatHighlightFlipbook(actionButton)
end

-- Action button frame name patterns and their maximum counts
local ACTION_BUTTON_PATTERNS = {
  {pattern = "ActionButton", maxCount = 12},           -- Main action bar
  {pattern = "MultiBarBottomLeftButton", maxCount = 12},   -- Bottom left bar
  {pattern = "MultiBarBottomRightButton", maxCount = 12},  -- Bottom right bar  
  {pattern = "MultiBarRightButton", maxCount = 12},        -- Right bar
  {pattern = "MultiBarLeftButton", maxCount = 12},         -- Left bar
  {pattern = "MultiBar5Button", maxCount = 12},            -- Additional bar 5
  {pattern = "MultiBar6Button", maxCount = 12},            -- Additional bar 6
  {pattern = "MultiBar7Button", maxCount = 12},            -- Additional bar 7
  {pattern = "PetActionButton", maxCount = 10},            -- Pet action bar
  {pattern = "StanceButton", maxCount = 10},               -- Stance/form bar
  {pattern = "OverrideActionBarButton", maxCount = 6},     -- Override bar (vehicles, etc)
  {pattern = "VehicleMenuBarActionButton", maxCount = 6}   -- Vehicle menu bar
}

-- Collect all available action button frames from the global namespace
local function ActionButton_GetAllActionButtons()
  local discoveredActionButtons = {}
  
  for _, buttonInfo in ipairs(ACTION_BUTTON_PATTERNS) do
    local buttonPattern = buttonInfo.pattern
    local maxButtonCount = buttonInfo.maxCount

    for buttonIndex = 1, maxButtonCount do
      local globalButtonName = buttonPattern .. buttonIndex
      local actionButtonFrame = _G[globalButtonName]
      
      if actionButtonFrame then
        table.insert(discoveredActionButtons, actionButtonFrame)
      end
    end
  end

  return discoveredActionButtons
end

-- Process combat highlight scaling for all discovered action buttons
local function ActionButton_ProcessAllCombatHighlights()
  local allActionButtons = ActionButton_GetAllActionButtons()

  for _, actionButton in ipairs(allActionButtons) do
    ActionButton_ScaleCombatHighlightFlipbook(actionButton)
  end
end

-- Timer delays for processing combat highlights
local INITIAL_PROCESSING_DELAY = 2
local SECONDARY_PROCESSING_DELAY = 3
local QUICK_PROCESSING_DELAY = 0.1
local BUTTON_CREATION_DELAY = 0.5

-- Schedule delayed processing of combat highlights after addon initialization
local function ActionButton_ScheduleDelayedProcessing()
  C_Timer.After(INITIAL_PROCESSING_DELAY, function()
    ActionButton_ProcessAllCombatHighlights()
    C_Timer.After(SECONDARY_PROCESSING_DELAY, ActionButton_ProcessAllCombatHighlights)
  end)
end

-- Event handling system for action button modifications
local bentoActionButtonEventFrame = CreateFrame("Frame", "BentoPlus_ActionButtonEventFrame")
local areActionButtonEventsRegistered = false

-- Register game events that affect action button states
local function ActionButton_RegisterGameEvents()
  if areActionButtonEventsRegistered then
    return
  end

  bentoActionButtonEventFrame:RegisterEvent("ADDON_LOADED")
  bentoActionButtonEventFrame:RegisterEvent("PLAYER_LOGIN")
  bentoActionButtonEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  bentoActionButtonEventFrame:RegisterEvent("ACTIONBAR_SHOWGRID")
  bentoActionButtonEventFrame:RegisterEvent("ACTIONBAR_HIDEGRID")
  bentoActionButtonEventFrame:RegisterEvent("UPDATE_BINDINGS")
  bentoActionButtonEventFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")

  areActionButtonEventsRegistered = true
end

-- Event handler for action button related game events
bentoActionButtonEventFrame:SetScript("OnEvent", function(self, eventName, addonName)
  if eventName == "ADDON_LOADED" and addonName == "BentoPlus" then
    ActionButton_ScheduleDelayedProcessing()
  elseif eventName == "PLAYER_LOGIN" or eventName == "PLAYER_ENTERING_WORLD" then
    ActionButton_ScheduleDelayedProcessing()
  else
    -- Handle other action bar events with quick processing
    C_Timer.After(QUICK_PROCESSING_DELAY, ActionButton_ProcessAllCombatHighlights)
  end
end)

ActionButton_RegisterGameEvents()

-- Hook into action button creation for dynamic combat highlight processing
local originalActionButtonOnLoad = ActionButton_OnLoad
if originalActionButtonOnLoad then
  ActionButton_OnLoad = function(actionButtonSelf, ...)
    originalActionButtonOnLoad(actionButtonSelf, ...)
    C_Timer.After(BUTTON_CREATION_DELAY, function()
      ActionButton_ProcessCombatHighlight(actionButtonSelf)
    end)
  end
end
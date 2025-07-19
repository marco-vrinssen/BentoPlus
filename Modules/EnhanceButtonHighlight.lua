
-- Scale action button combat highlights by twenty percent.

local function findAndScaleFlipbook(target_button)
  if not target_button then
    return
  end

  local combat_flipbook = nil

  if target_button.AssistedCombatHighlightFrame then
    if target_button.AssistedCombatHighlightFrame.Flipbook then
      combat_flipbook = target_button.AssistedCombatHighlightFrame.Flipbook
    elseif target_button.AssistedCombatHighlightFrame.flipbook then
      combat_flipbook = target_button.AssistedCombatHighlightFrame.flipbook
    end
  end

  if not combat_flipbook and target_button.AssistedCombatHighlightFrame then
    local frame_regions = {target_button.AssistedCombatHighlightFrame:GetRegions()}
    for _, current_region in ipairs(frame_regions) do
      if current_region and current_region:GetObjectType() == "Texture" and
          (current_region:GetName() and
           string.find(current_region:GetName():lower(), "flipbook")) then
        combat_flipbook = current_region
        break
      end
    end
  end

  if combat_flipbook and not combat_flipbook._bento_scaled then
    local original_width, original_height = combat_flipbook:GetSize()

    if original_width <= 0 or original_height <= 0 then
      local button_width, button_height = target_button:GetSize()
      original_width, original_height = button_width, button_height
    end

    if original_width > 0 and original_height > 0 then
      combat_flipbook:ClearAllPoints()
      combat_flipbook:SetPoint("CENTER", target_button, "CENTER", 0, 0)

      combat_flipbook:SetSize(original_width * 1.2, original_height * 1.2)
      combat_flipbook._bento_scaled = true
      return true
    end
  end

  return false
end

local function processSingleButton(target_button)
  if not target_button then
    return
  end
  findAndScaleFlipbook(target_button)
end

local function getAllButtonNames()
  local button_patterns = {
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

  local button_collection = {}
  for _, pattern_name in ipairs(button_patterns) do
    local max_button_count = 12
    if pattern_name == "PetActionButton" or pattern_name == "StanceButton" then
      max_button_count = 10
    elseif pattern_name == "OverrideActionBarButton" or
           pattern_name == "VehicleMenuBarActionButton" then
      max_button_count = 6
    end

    for current_index = 1, max_button_count do
      local found_button = _G[pattern_name .. current_index]
      if found_button then
        table.insert(button_collection, found_button)
      end
    end
  end

  return button_collection
end

-- Process all discovered action buttons.
local function processAllButtons()
  local button_collection = getAllButtonNames()

  for _, current_button in ipairs(button_collection) do
    findAndScaleFlipbook(current_button)
  end
end

-- Schedule delayed button processing.
local function scheduleDelayedProcess()
  C_Timer.After(2, function()
    processAllButtons()
    C_Timer.After(3, processAllButtons)
  end)
end

-- Initialize event handling system.

local event_frame = CreateFrame("Frame")
local events_registered = false

-- Register all required game events.
local function registerGameEvents()
  if events_registered then
    return
  end

  event_frame:RegisterEvent("ADDON_LOADED")
  event_frame:RegisterEvent("PLAYER_LOGIN")
  event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  event_frame:RegisterEvent("ACTIONBAR_SHOWGRID")
  event_frame:RegisterEvent("ACTIONBAR_HIDEGRID")
  event_frame:RegisterEvent("UPDATE_BINDINGS")
  event_frame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")

  events_registered = true
end

event_frame:SetScript("OnEvent", function(self, event_name, addon_name)
  if event_name == "ADDON_LOADED" and addon_name == "BentoPlus" then
    scheduleDelayedProcess()
  elseif event_name == "PLAYER_LOGIN" or event_name == "PLAYER_ENTERING_WORLD" then
    scheduleDelayedProcess()
  else
    C_Timer.After(0.1, processAllButtons)
  end
end)

registerGameEvents()

-- Hook button creation for dynamic processing.

local original_action_button_on_load = ActionButton_OnLoad
if original_action_button_on_load then
  ActionButton_OnLoad = function(self, ...)
    original_action_button_on_load(self, ...)
    C_Timer.After(0.5, function()
      processSingleButton(self)
    end)
  end
end
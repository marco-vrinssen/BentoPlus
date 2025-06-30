
-- Scale action button combat highlights by twenty percent

local function findAndScaleFlipbook(targetButton)
    if not targetButton then return end
    
    local combatFlipbook = nil
    
    if targetButton.AssistedCombatHighlightFrame then
        if targetButton.AssistedCombatHighlightFrame.Flipbook then
            combatFlipbook = targetButton.AssistedCombatHighlightFrame.Flipbook
        elseif targetButton.AssistedCombatHighlightFrame.flipbook then
            combatFlipbook = targetButton.AssistedCombatHighlightFrame.flipbook
        end
    end
    
    if not combatFlipbook and targetButton.AssistedCombatHighlightFrame then
        local frameRegions = {targetButton.AssistedCombatHighlightFrame:GetRegions()}
        for _, currentRegion in ipairs(frameRegions) do
            if currentRegion and currentRegion:GetObjectType() == "Texture" and 
               (currentRegion:GetName() and string.find(currentRegion:GetName():lower(), "flipbook")) then
                combatFlipbook = currentRegion
                break
            end
        end
    end
    
    if combatFlipbook and not combatFlipbook._bentoScaled then
        local originalWidth, originalHeight = combatFlipbook:GetSize()
        
        if originalWidth <= 0 or originalHeight <= 0 then
            local buttonWidth, buttonHeight = targetButton:GetSize()
            originalWidth, originalHeight = buttonWidth, buttonHeight
        end
        
        if originalWidth > 0 and originalHeight > 0 then
            combatFlipbook:ClearAllPoints()
            combatFlipbook:SetPoint("CENTER", targetButton, "CENTER", 0, 0)
            
            combatFlipbook:SetSize(originalWidth * 1.2, originalHeight * 1.2)
            combatFlipbook._bentoScaled = true
            return true
        end
    end
    
    return false
end

local function processSingleButton(targetButton)
    if not targetButton then return end
    findAndScaleFlipbook(targetButton)
end

local function getAllButtonNames()
    local buttonPatterns = {
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
    
    local buttonCollection = {}
    for _, patternName in ipairs(buttonPatterns) do
        local maxButtonCount = (patternName == "PetActionButton" or patternName == "StanceButton") and 10 or 12
        if patternName == "OverrideActionBarButton" or patternName == "VehicleMenuBarActionButton" then
            maxButtonCount = 6
        end
        
        for currentIndex = 1, maxButtonCount do
            local foundButton = _G[patternName .. currentIndex]
            if foundButton then
                table.insert(buttonCollection, foundButton)
            end
        end
    end
    
    return buttonCollection
end

-- Process all discovered action buttons
local function processAllButtons()
    local buttonCollection = getAllButtonNames()
    
    for _, currentButton in ipairs(buttonCollection) do
        findAndScaleFlipbook(currentButton)
    end
end

-- Schedule delayed button processing
local function scheduleDelayedProcess()
    C_Timer.After(2, function()
        processAllButtons()
        C_Timer.After(3, processAllButtons)
    end)
end

-- Initialize event handling system

local eventFrame = CreateFrame("Frame")
local eventsRegistered = false

-- Register all required game events
local function registerGameEvents()
    if eventsRegistered then return end
    
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
        scheduleDelayedProcess()
    elseif eventName == "PLAYER_LOGIN" or eventName == "PLAYER_ENTERING_WORLD" then
        scheduleDelayedProcess()
    else
        C_Timer.After(0.1, processAllButtons)
    end
end)

registerGameEvents()

-- Hook button creation for dynamic processing

local originalActionButtonOnLoad = ActionButton_OnLoad
if originalActionButtonOnLoad then
    ActionButton_OnLoad = function(self, ...)
        originalActionButtonOnLoad(self, ...)
        C_Timer.After(0.5, function()
            processSingleButton(self)
        end)
    end
end
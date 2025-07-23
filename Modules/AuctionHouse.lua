-- Initialize auction house automation
local ADDON_NAME = "BentoPlus"
local eventFrame = CreateFrame("Frame")
local hooks = {}

-- Track hook registration
local function isHookRegistered(hookName)
    return hooks[hookName]
end

-- Mark hook as registered
local function markHookRegistered(hookName)
    hooks[hookName] = true
end

-- Apply expansion filter to search
local function applyExpansionFilter()
    local searchBar = AuctionHouseFrame.SearchBar
    if not searchBar or not searchBar.FilterButton then return end
    
    searchBar.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
    searchBar:UpdateClearFiltersButton()
end

-- Handle auction house events
local function handleEvents(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon ~= ADDON_NAME then return end
        
    elseif event == "AUCTION_HOUSE_SHOW" then
        if not isHookRegistered("searchBarShow") then
            local searchBar = AuctionHouseFrame.SearchBar
            if searchBar then
                local function triggerFilter()
                    applyExpansionFilter()
                end
                
                searchBar:HookScript("OnShow", function()
                    C_Timer.After(0, triggerFilter)
                end)
                
                markHookRegistered("searchBarShow")
                C_Timer.After(0, triggerFilter)
            end
        end
    end
end

-- Register events and handler
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
eventFrame:SetScript("OnEvent", handleEvents)

-- Enable spacebar posting
local keyboardFrame = CreateFrame("Frame")
local keyboardEnabled = false
local SPACEBAR_KEY = "SPACE"

-- Post auction item on spacebar
local function postAuctionItem()
    if not keyboardEnabled then return end
    if not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then return end
    
    local commoditiesFrame = AuctionHouseFrame.CommoditiesSellFrame
    if commoditiesFrame and commoditiesFrame:IsShown() then
        if commoditiesFrame.PostButton and commoditiesFrame.PostButton:IsEnabled() then
            commoditiesFrame.PostButton:Click()
            return
        end
    end
    
    local itemFrame = AuctionHouseFrame.ItemSellFrame
    if itemFrame and itemFrame:IsShown() then
        if itemFrame.PostButton and itemFrame.PostButton:IsEnabled() then
            itemFrame.PostButton:Click()
            return
        end
    end
    
    local sellFrame = AuctionHouseFrame.SellFrame
    if sellFrame and sellFrame:IsShown() then
        if sellFrame.PostButton and sellFrame.PostButton:IsEnabled() then
            sellFrame.PostButton:Click()
            return
        end
    end
end

-- Handle keyboard input
local function handleKeyInput(self, key)
    if key == SPACEBAR_KEY and keyboardEnabled then
        postAuctionItem()
    else
        self:SetPropagateKeyboardInput(true)
    end
end

-- Enable keyboard events
local function enableKeyboard()
    keyboardEnabled = true
    keyboardFrame:SetScript("OnKeyDown", handleKeyInput)
    keyboardFrame:SetPropagateKeyboardInput(true)
    keyboardFrame:EnableKeyboard(true)
    keyboardFrame:SetFrameStrata("HIGH")
end

-- Disable keyboard events
local function disableKeyboard()
    keyboardEnabled = false
    keyboardFrame:SetScript("OnKeyDown", nil)
    keyboardFrame:EnableKeyboard(false)
end

-- Handle keyboard frame events
keyboardFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
keyboardFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
keyboardFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "AUCTION_HOUSE_SHOW" then
        enableKeyboard()
    elseif event == "AUCTION_HOUSE_CLOSED" then
        disableKeyboard()
    end
end)
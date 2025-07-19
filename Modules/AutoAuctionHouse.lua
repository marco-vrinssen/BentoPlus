local currentAddonName = "BentoPlus"

-- Create eventHandlerFrame to manage auction house events

local auctionHouseEventFrame = CreateFrame("Frame")

-- Initialize hookTrackingRegistry to prevent duplicate hook registration

local hookTrackingRegistry = {}

-- Define helper functions for hook state management

local function checkHookAlreadyRegistered(hookIdentifierKey)
    return hookTrackingRegistry[hookIdentifierKey]
end

local function recordHookAsRegistered(hookIdentifierKey)
    hookTrackingRegistry[hookIdentifierKey] = true
end

-- Apply currentExpansionOnlyFilter to auction house search interface

local function enforceCurrentExpansionOnlyFilter()
    local auctionSearchBarInterface = AuctionHouseFrame.SearchBar
    if not auctionSearchBarInterface or not auctionSearchBarInterface.FilterButton then return end
    
    auctionSearchBarInterface.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
    
    auctionSearchBarInterface:UpdateClearFiltersButton()
end

-- Handle addon and auction house events for filter automation

local function processAuctionHouseEvents(self, eventType, ...)
    if eventType == "ADDON_LOADED" then
        local loadedAddonName = ...

        if loadedAddonName ~= currentAddonName then return end
        
    elseif eventType == "AUCTION_HOUSE_SHOW" then
        
        if not checkHookAlreadyRegistered("AuctionHouseSearchBar") then
            local auctionSearchBarInterface = AuctionHouseFrame.SearchBar
            if auctionSearchBarInterface then
                local function applyFilterOnShow()
                    enforceCurrentExpansionOnlyFilter()
                end
                
                auctionSearchBarInterface:HookScript("OnShow", function(searchBarInstance)
                    C_Timer.After(0, applyFilterOnShow)
                end)
                
                recordHookAsRegistered("AuctionHouseSearchBar")
                
                C_Timer.After(0, applyFilterOnShow)
            end
        end
    end
end

-- Register required events for auction house automation

auctionHouseEventFrame:RegisterEvent("ADDON_LOADED")
auctionHouseEventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")

-- Bind event processor to frame event system

auctionHouseEventFrame:SetScript("OnEvent", processAuctionHouseEvents)
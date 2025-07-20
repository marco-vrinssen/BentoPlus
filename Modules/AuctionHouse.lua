

-- Define addonNameString for consistent addon identification

local addonNameString = "BentoPlus"



-- Create auctionHouseEventFrame to manage auction house related events

local auctionHouseEventFrame = CreateFrame("Frame")



-- Initialize hookRegistrationStatusTable to prevent duplicate hook registration

local hookRegistrationStatusTable = {}



-- Check if a specific hook has already been registered to avoid duplicate hooks

local function isHookAlreadyRegistered(hookIdentifierString)
    return hookRegistrationStatusTable[hookIdentifierString]
end


-- Record that a specific hook has been registered for future reference

local function markHookAsRegistered(hookIdentifierString)
    hookRegistrationStatusTable[hookIdentifierString] = true
end



-- Enforce current expansion only filter on the auction house search bar

local function applyCurrentExpansionOnlyFilterToSearchBar()
    local auctionHouseSearchBarFrame = AuctionHouseFrame.SearchBar
    if not auctionHouseSearchBarFrame or not auctionHouseSearchBarFrame.FilterButton then return end

    auctionHouseSearchBarFrame.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true

    auctionHouseSearchBarFrame:UpdateClearFiltersButton()
end



-- Process auction house events to automate filter application and hook registration

local function handleAuctionHouseEventFrameEvents(self, eventTypeString, ...)
    if eventTypeString == "ADDON_LOADED" then
        local loadedAddonNameString = ...

        if loadedAddonNameString ~= addonNameString then return end

    elseif eventTypeString == "AUCTION_HOUSE_SHOW" then

        if not isHookAlreadyRegistered("AuctionHouseSearchBarOnShow") then
            local auctionHouseSearchBarFrame = AuctionHouseFrame.SearchBar
            if auctionHouseSearchBarFrame then

                local function triggerExpansionFilterOnShow()
                    applyCurrentExpansionOnlyFilterToSearchBar()
                end

                auctionHouseSearchBarFrame:HookScript("OnShow", function(searchBarInstance)
                    C_Timer.After(0, triggerExpansionFilterOnShow)
                end)

                markHookAsRegistered("AuctionHouseSearchBarOnShow")

                C_Timer.After(0, triggerExpansionFilterOnShow)
            end
        end
    end
end



-- Register required events for auction house automation

auctionHouseEventFrame:RegisterEvent("ADDON_LOADED")
auctionHouseEventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")



-- Bind event handler to auction house event frame

auctionHouseEventFrame:SetScript("OnEvent", handleAuctionHouseEventFrameEvents)










-- Create auctionHouseKeyboardEventFrame to manage keyboard posting events

local auctionHouseKeyboardEventFrame = CreateFrame("Frame")
local isAuctionHouseKeyboardEnabled = false

local SPACEBAR_KEY_STRING = "SPACE"

-- Post the currently listed auction house item if the spacebar is pressed

local function postAuctionItemOnSpacebar()
    if not isAuctionHouseKeyboardEnabled then
        return
    end

    if not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then
        return
    end

    local commoditiesSellFrame = AuctionHouseFrame.CommoditiesSellFrame
    if commoditiesSellFrame and commoditiesSellFrame:IsShown() then
        if commoditiesSellFrame.PostButton and commoditiesSellFrame.PostButton:IsEnabled() then
            commoditiesSellFrame.PostButton:Click()
            return
        end
    end

    local itemSellFrame = AuctionHouseFrame.ItemSellFrame
    if itemSellFrame and itemSellFrame:IsShown() then
        if itemSellFrame.PostButton and itemSellFrame.PostButton:IsEnabled() then
            itemSellFrame.PostButton:Click()
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

-- Handle keyboard input for auction posting

local function handleAuctionHouseKeyInput(self, keyString)
    if keyString == SPACEBAR_KEY_STRING and isAuctionHouseKeyboardEnabled then
        postAuctionItemOnSpacebar()
    else
        self:SetPropagateKeyboardInput(true)
    end
end

-- Enable keyboard event handling for auction house

local function enableAuctionHouseKeyboardEvents()
    isAuctionHouseKeyboardEnabled = true
    auctionHouseKeyboardEventFrame:SetScript("OnKeyDown", handleAuctionHouseKeyInput)
    auctionHouseKeyboardEventFrame:SetPropagateKeyboardInput(true)
    auctionHouseKeyboardEventFrame:EnableKeyboard(true)
    auctionHouseKeyboardEventFrame:SetFrameStrata("HIGH")
end

-- Disable keyboard event handling for auction house

local function disableAuctionHouseKeyboardEvents()
    isAuctionHouseKeyboardEnabled = false
    auctionHouseKeyboardEventFrame:SetScript("OnKeyDown", nil)
    auctionHouseKeyboardEventFrame:EnableKeyboard(false)
end

-- Register auction house show/close events to manage keyboard posting

auctionHouseKeyboardEventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
auctionHouseKeyboardEventFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")

auctionHouseKeyboardEventFrame:SetScript("OnEvent", function(self, eventTypeString, ...)
    if eventTypeString == "AUCTION_HOUSE_SHOW" then
        enableAuctionHouseKeyboardEvents()
    elseif eventTypeString == "AUCTION_HOUSE_CLOSED" then
        disableAuctionHouseKeyboardEvents()
    end
end)
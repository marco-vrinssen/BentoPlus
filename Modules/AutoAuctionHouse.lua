

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
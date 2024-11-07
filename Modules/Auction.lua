-- Automatically set the Current Expansion Only filter when opening the auction house, crafting orders, and Auctionator shopping tab.

local AuctionConfig = {}
AuctionConfig.config = {
    forAuctionHouseOverwrite = true,
    forCraftOrdersOverwrite = true,
    forAuctionatorOverwrite = true,
}

local function EnableCurrentExpansionFilter(searchBar, configValue)
    if searchBar and searchBar.FilterButton then
        searchBar.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = configValue or false
        searchBar:UpdateClearFiltersButton()
    end
end

local function OnAuctionHouseShow()
    if AuctionConfig.config.forAuctionHouseOverwrite then
        local searchBar = AuctionHouseFrame.SearchBar
        if searchBar then
            EnableCurrentExpansionFilter(searchBar, AuctionConfig.config.forAuctionHouseOverwrite)
        end
    end
end

local function OnCraftingOrdersShow()
    if AuctionConfig.config.forCraftOrdersOverwrite then
        local filterDropdown = ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar.FilterDropdown
        if filterDropdown then
            filterDropdown.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = AuctionConfig.config.forCraftOrdersOverwrite or false
            filterDropdown:ValidateResetState()
        end
    end
end

local function OnAuctionatorShow()
    if AuctionConfig.config.forAuctionatorOverwrite and C_AddOns.IsAddOnLoaded("Auctionator") then
        local shoppingTabItem = AuctionatorShoppingTabItemFrame
        if shoppingTabItem then
            local value = AuctionConfig.config.forAuctionatorOverwrite and tostring(LE_EXPANSION_LEVEL_CURRENT) or ""
            shoppingTabItem.ExpansionContainer.DropDown:SetValue(value)
        end
    end
end

local AuctionEvents = CreateFrame("Frame")
AuctionEvents:RegisterEvent("ADDON_LOADED")
AuctionEvents:RegisterEvent("AUCTION_HOUSE_SHOW")
AuctionEvents:RegisterEvent("CRAFTINGORDERS_SHOW_CUSTOMER")
AuctionEvents:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")

AuctionEvents:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "AuctionConfig" then
            AuctionConfig.config = AuctionConfig.config or {}
        end
    elseif event == "AUCTION_HOUSE_SHOW" then
        OnAuctionHouseShow()
    elseif event == "CRAFTINGORDERS_SHOW_CUSTOMER" then
        OnCraftingOrdersShow()
    elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
        local interactionType = ...
        if interactionType == Enum.PlayerInteractionType.Auctioneer then
            OnAuctionatorShow()
        end
    end
end)
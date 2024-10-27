-- Enable posting items with the space bar once an item is placed in the sale slot

local function OnKeyPress(self, key)
    if key == "SPACE" then
        if InCombatLockdown() then
            self:SetPropagateKeyboardInput(true)
            return
        end

        if AuctionHouseFrame and AuctionHouseFrame:IsShown() then
            local commoditiesSellFrame = AuctionHouseFrame.CommoditiesSellFrame
            local itemSellFrame = AuctionHouseFrame.ItemSellFrame

            if (commoditiesSellFrame and commoditiesSellFrame:IsShown()) or (itemSellFrame and itemSellFrame:IsShown()) then
                if commoditiesSellFrame and commoditiesSellFrame:IsShown() then
                    commoditiesSellFrame.PostButton:Click()
                elseif itemSellFrame and itemSellFrame:IsShown() then
                    itemSellFrame.PostButton:Click()
                end
                self:SetPropagateKeyboardInput(false)
                return
            end
        end
    end
    self:SetPropagateKeyboardInput(true)
end

local KeyPressFrame = CreateFrame("Frame")

KeyPressFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
KeyPressFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
KeyPressFrame:SetScript("OnEvent", function(self, event)
    if event == "AUCTION_HOUSE_SHOW" then
        self:SetScript("OnKeyDown", OnKeyPress)
        self:EnableKeyboard(true)
    elseif event == "AUCTION_HOUSE_CLOSED" then
        self:SetScript("OnKeyDown", nil)
        self:EnableKeyboard(false)
    end
end)

KeyPressFrame:SetPropagateKeyboardInput(true)




-- Through toggle command, have the Current Expansion Only filter pre-set and automatically focus the search bar when opening the auction house, crafting orders, and Auctionator shopping tab.

local AuctionConfig = {}
AuctionConfig.config = {
    forAuctionHouseOverwrite = true,
    forCraftOrdersOverwrite = true,
    forAuctionatorOverwrite = true,
    forAuctionHouseFocusSearchBar = true,
    forCraftOrdersFocusSearchBar = true,
}

local MyAuctionAddonFrame = CreateFrame("Frame")
MyAuctionAddonFrame:RegisterEvent("ADDON_LOADED")
MyAuctionAddonFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
MyAuctionAddonFrame:RegisterEvent("CRAFTINGORDERS_SHOW_CUSTOMER")
MyAuctionAddonFrame:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")

local function EnableCurrentExpansionFilter(searchBar, configValue)
    if searchBar and searchBar.FilterButton then
        searchBar.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = configValue or false
        searchBar:UpdateClearFiltersButton()
    end
end

local function FocusSearchBar(searchBox, shouldFocus)
    if shouldFocus then
        if not searchBox:HasFocus() then
            searchBox:SetFocus()
        end
    else
        if searchBox:HasFocus() then
            searchBox:ClearFocus()
        end
    end
end

local function OnAuctionHouseShow()
    if AuctionConfig.config.forAuctionHouseOverwrite then
        local searchBar = AuctionHouseFrame.SearchBar
        local searchBox = searchBar and searchBar.SearchBox
        if searchBar then
            EnableCurrentExpansionFilter(searchBar, AuctionConfig.config.forAuctionHouseOverwrite)
            FocusSearchBar(searchBox, AuctionConfig.config.forAuctionHouseFocusSearchBar)
        end
    end
end

local function OnCraftingOrdersShow()
    if AuctionConfig.config.forCraftOrdersOverwrite then
        local filterDropdown = ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar.FilterDropdown
        local searchBox = ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar.SearchBox
        if filterDropdown then
            filterDropdown.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = AuctionConfig.config.forCraftOrdersOverwrite or false
            filterDropdown:ValidateResetState()
            FocusSearchBar(searchBox, AuctionConfig.config.forCraftOrdersFocusSearchBar)
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

MyAuctionAddonFrame:SetScript("OnEvent", function(self, event, ...)
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

SLASH_BENTOAUCTION1 = "/bentoauction"
SlashCmdList["BENTOAUCTION"] = function()
    AuctionConfig.config.forAuctionHouseOverwrite = not AuctionConfig.config.forAuctionHouseOverwrite
    local state = AuctionConfig.config.forAuctionHouseOverwrite and "On" or "Off"
    print("Auction Auto Filter: " .. state)
end
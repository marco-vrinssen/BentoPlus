-- Enable posting items in the auction house post slot by pressing SPACE BAR.

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




-- This script reduces the price of an item by 20% when the auction house throttled system is ready

local function setReducedPrice()
    if AuctionHouseFrame.ItemSellFrame:IsShown() and not AuctionHouseFrame.CommoditiesSellFrame:IsShown() then
        local priceInput = AuctionHouseFrame.ItemSellFrame.PriceInput.MoneyInputFrame.GoldBox
        if priceInput then
            local currentPrice = tonumber(priceInput:GetText()) or 0
            local reducedPrice = math.floor(currentPrice * 0.9)
            priceInput:SetText(reducedPrice)
        end
    end
end

local function onEvent()
    C_Timer.After(0, setReducedPrice)
end

local ItemSellEvents = CreateFrame("Frame")
ItemSellEvents:RegisterEvent("AUCTION_HOUSE_THROTTLED_SYSTEM_READY")
ItemSellEvents:SetScript("OnEvent", onEvent)




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

local BentoAuctionEvents = CreateFrame("Frame")
BentoAuctionEvents:RegisterEvent("ADDON_LOADED")
BentoAuctionEvents:RegisterEvent("AUCTION_HOUSE_SHOW")
BentoAuctionEvents:RegisterEvent("CRAFTINGORDERS_SHOW_CUSTOMER")
BentoAuctionEvents:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")

BentoAuctionEvents:SetScript("OnEvent", function(self, event, ...)
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

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
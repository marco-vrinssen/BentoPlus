-- PostItem module: Post currently listed auction house item when pressing space bar

local postItemFrame = CreateFrame("Frame")
local isAuctionHouseOpen = false

-- Function to post the currently selected auction
local function postCurrentAuction()
    if not isAuctionHouseOpen then
        return
    end
    
    -- Check if we're in the correct auction house tab (selling)
    if not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then
        return
    end
    
    -- Try commodities sell frame first (for stackable items like herbs, ore, etc.)
    local commoditiesSellFrame = AuctionHouseFrame.CommoditiesSellFrame
    if commoditiesSellFrame and commoditiesSellFrame:IsShown() then
        if commoditiesSellFrame.PostButton and commoditiesSellFrame.PostButton:IsEnabled() then
            commoditiesSellFrame.PostButton:Click()
            return
        end
    end
    
    -- Try item sell frame (for equipment and non-stackable items)
    local itemSellFrame = AuctionHouseFrame.ItemSellFrame
    if itemSellFrame and itemSellFrame:IsShown() then
        if itemSellFrame.PostButton and itemSellFrame.PostButton:IsEnabled() then
            itemSellFrame.PostButton:Click()
            return
        end
    end
    
    -- Fallback to old sell frame (for compatibility)
    local sellFrame = AuctionHouseFrame.SellFrame
    if sellFrame and sellFrame:IsShown() then
        if sellFrame.PostButton and sellFrame.PostButton:IsEnabled() then
            sellFrame.PostButton:Click()
            return
        end
    end
end

-- Handle key bindings when auction house is open
local function handleKeyDown(self, key)
    if key == "SPACE" and isAuctionHouseOpen then
        postCurrentAuction()
    end
end

-- Event handlers
local function onAuctionHouseShow()
    isAuctionHouseOpen = true
    -- Set up key binding
    postItemFrame:SetScript("OnKeyDown", handleKeyDown)
    postItemFrame:SetPropagateKeyboardInput(false)
    postItemFrame:EnableKeyboard(true)
    postItemFrame:SetFrameStrata("HIGH")
end

local function onAuctionHouseHide()
    isAuctionHouseOpen = false
    -- Clean up key binding
    postItemFrame:SetScript("OnKeyDown", nil)
    postItemFrame:EnableKeyboard(false)
end

-- Initialize event handling
postItemFrame:RegisterEvent("ADDON_LOADED")
postItemFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
postItemFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")

postItemFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "BentoPlus" then
            print("|cff00ff00[BentoPlus]|r PostItem module loaded. Press SPACE at auction house to post items (works with both commodities and items).")
        end
    elseif event == "AUCTION_HOUSE_SHOW" then
        onAuctionHouseShow()
    elseif event == "AUCTION_HOUSE_CLOSED" then
        onAuctionHouseHide()
    end
end)

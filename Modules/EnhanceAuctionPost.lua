-- PostItem module: Post currently listed auction house item when pressing space bar

local auctionFrame = CreateFrame("Frame")
local isAuctionOpen = false

local SPACE_KEY = "SPACE"

-- Execute auction posting for active sell frame
local function executeAuctionPost()
    if not isAuctionOpen then
        return
    end
    
    if not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then
        return
    end
    
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

-- Process keyboard input for auction posting
local function processKeyInput(self, key)
    if key == SPACE_KEY and isAuctionOpen then
        executeAuctionPost()
    else
        self:SetPropagateKeyboardInput(true)
    end
end

-- Enable keyboard handling for auction house
local function enableAuctionKeys()
    isAuctionOpen = true
    auctionFrame:SetScript("OnKeyDown", processKeyInput)
    auctionFrame:SetPropagateKeyboardInput(true)
    auctionFrame:EnableKeyboard(true)
    auctionFrame:SetFrameStrata("HIGH")
end

-- Disable keyboard handling for auction house
local function disableAuctionKeys()
    isAuctionOpen = false
    auctionFrame:SetScript("OnKeyDown", nil)
    auctionFrame:EnableKeyboard(false)
end

-- Initialize auction house event monitoring
auctionFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
auctionFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")

auctionFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "AUCTION_HOUSE_SHOW" then
        enableAuctionKeys()
    elseif event == "AUCTION_HOUSE_CLOSED" then
        disableAuctionKeys()
    end
end)
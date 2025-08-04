-- Enable spacebar posting for auction house items.

local spacebarPostingEventFrame = CreateFrame("Frame")
local postAuctionKey = "SPACE"
local isSpacebarPostingEnabled = false

-- Post an auction item if possible.

local function postAuctionItem()
  if not isSpacebarPostingEnabled or not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then
    return
  end
  local commoditiesFrame = AuctionHouseFrame.CommoditiesSellFrame
  if commoditiesFrame and commoditiesFrame:IsShown() and commoditiesFrame.PostButton and commoditiesFrame.PostButton:IsEnabled() then
    commoditiesFrame.PostButton:Click()
    return
  end
  local itemFrame = AuctionHouseFrame.ItemSellFrame
  if itemFrame and itemFrame:IsShown() and itemFrame.PostButton and itemFrame.PostButton:IsEnabled() then
    itemFrame.PostButton:Click()
    return
  end
  local sellFrame = AuctionHouseFrame.SellFrame
  if sellFrame and sellFrame:IsShown() and sellFrame.PostButton and sellFrame.PostButton:IsEnabled() then
    sellFrame.PostButton:Click()
    return
  end
end

-- Handle key presses for posting auction items.

local function handleKeyDown(self, key)
  if key == postAuctionKey and isSpacebarPostingEnabled then
    postAuctionItem()
  else
    self:SetPropagateKeyboardInput(true)
  end
end

-- Handle auction house events for spacebar posting.

local function handleSpacebarPostingEvent(self, event, ...)
  if event == "AUCTION_HOUSE_SHOW" then
    isSpacebarPostingEnabled = true
    self:SetScript("OnKeyDown", handleKeyDown)
    self:SetPropagateKeyboardInput(true)
    self:EnableKeyboard(true)
    self:SetFrameStrata("HIGH")
  elseif event == "AUCTION_HOUSE_CLOSED" then
    isSpacebarPostingEnabled = false
    self:SetScript("OnKeyDown", nil)
    self:EnableKeyboard(false)
  end
end

spacebarPostingEventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
spacebarPostingEventFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
spacebarPostingEventFrame:SetScript("OnEvent", handleSpacebarPostingEvent)

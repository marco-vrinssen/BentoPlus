-- Enable spacebar posting for auction house items.

local spacePostFrame = CreateFrame("Frame")
local postKey = "SPACE"
local isSpacePostEnabled = false

-- Post an auction item if possible.

local function postAuctionItem()
  if not isSpacePostEnabled or not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then
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
  if key == postKey and isSpacePostEnabled then
    postAuctionItem()
  else
    self:SetPropagateKeyboardInput(true)
  end
end

-- Handle auction house events for spacebar posting.

local function handleSpacePostEvent(self, event, ...)
  if event == "AUCTION_HOUSE_SHOW" then
    isSpacePostEnabled = true
    self:SetScript("OnKeyDown", handleKeyDown)
    self:SetPropagateKeyboardInput(true)
    self:EnableKeyboard(true)
    self:SetFrameStrata("HIGH")
  elseif event == "AUCTION_HOUSE_CLOSED" then
    isSpacePostEnabled = false
    self:SetScript("OnKeyDown", nil)
    self:EnableKeyboard(false)
  end
end

spacePostFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
spacePostFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
spacePostFrame:SetScript("OnEvent", handleSpacePostEvent)

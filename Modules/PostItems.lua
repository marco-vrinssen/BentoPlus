-- Update auction posting to use spacebar so that we speed up listing

local spacePostFrame = CreateFrame("Frame")
local postKey = "SPACE"
local isPostEnabled = false

-- Post current item/commodity respecting which sell sub-frame is active

local function postAuctionItem()
  if not isPostEnabled or not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then
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

-- Capture spacebar presses while auction house is open

local function handleKeyDown(self, key)
  if key == postKey and isPostEnabled then
    postAuctionItem()
    self:SetPropagateKeyboardInput(false)
  else
    self:SetPropagateKeyboardInput(true)
  end
end

-- Enable or disable listener with auction house

local function handlePostEvent(self, event)
  if event == "AUCTION_HOUSE_SHOW" then
  isPostEnabled = true
    self:SetScript("OnKeyDown", handleKeyDown)
    self:SetPropagateKeyboardInput(true)
    self:EnableKeyboard(true)
    self:SetFrameStrata("HIGH")
  elseif event == "AUCTION_HOUSE_CLOSED" then
  isPostEnabled = false
    self:SetScript("OnKeyDown", nil)
    self:EnableKeyboard(false)
  end
end

spacePostFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
spacePostFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
spacePostFrame:SetScript("OnEvent", handlePostEvent)
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




-- Automatically apply current expansion filter to auction house search.

local expFilterFrame = CreateFrame("Frame")

-- Apply the current expansion filter to the search bar.

local function applyExpFilter()
  local searchBar = AuctionHouseFrame and AuctionHouseFrame.SearchBar
  if not searchBar or not searchBar.FilterButton then
    return
  end
  searchBar.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
  searchBar:UpdateClearFiltersButton()
end

-- Handle auction house events for expansion filter.

local function handleExpEvent(self, event, ...)
  if event == "AUCTION_HOUSE_SHOW" then
    if AuctionHouseFrame and AuctionHouseFrame.SearchBar then
      local searchBar = AuctionHouseFrame.SearchBar
      if not searchBar._bentoPlusFilterHooked then
        searchBar:HookScript("OnShow", applyExpFilter)
        searchBar._bentoPlusFilterHooked = true
      end
      applyExpFilter()
    end
  end
end

expFilterFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
expFilterFrame:SetScript("OnEvent", handleExpEvent)




-- Synchronize auction house favorite items across sessions.

local favFrame = CreateFrame("Frame")
local favKey = "AuctionFavorites"

-- Initialize persistent storage for auction favorites.

if not BentoDB then
  BentoDB = {}
end
if BentoDB[favKey] == nil then
  BentoDB[favKey] = {}
end

-- Create a serialized string from an item key for storage.

local function createKeyString(itemKey)
  local sortedKeys, keyValues = {}, {}
  for key in pairs(itemKey) do
    table.insert(sortedKeys, key)
  end
  table.sort(sortedKeys)
  for _, key in ipairs(sortedKeys) do
    table.insert(keyValues, itemKey[key])
  end
  return table.concat(keyValues, "-")
end

-- Store a favorite item in the persistent database.

local function storeFavItem(itemKey, isFavorite)
  if not BentoDB then
    BentoDB = {}
  end
  if not BentoDB[favKey] then
    BentoDB[favKey] = {}
  end

  local keyString = createKeyString(itemKey)
  if isFavorite then
    BentoDB[favKey][keyString] = itemKey
  else
    BentoDB[favKey][keyString] = nil
  end
end

-- Update the favorite status for a given item.

local function updateFavStatus(itemKey)
  storeFavItem(itemKey, C_AuctionHouse.IsFavoriteItem(itemKey))
end

-- Hook favorite changes to automatically update the database.

hooksecurefunc(C_AuctionHouse, "SetFavoriteItem", storeFavItem)

-- Handle auction house events for favorites management.

local function handleFavEvent(self, event, ...)
  if event == "AUCTION_HOUSE_SHOW" then
    local refreshNeeded = false
    if BentoDB and BentoDB[favKey] then
      for _, itemKey in pairs(BentoDB[favKey]) do
        C_AuctionHouse.SetFavoriteItem(itemKey, true)
        refreshNeeded = true
      end
    end
    if refreshNeeded then
      C_AuctionHouse.SearchForFavorites({})
    end
  elseif event == "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED" then
    for _, result in ipairs(C_AuctionHouse.GetBrowseResults()) do
      updateFavStatus(result.itemKey)
    end
  elseif event == "AUCTION_HOUSE_BROWSE_RESULTS_ADDED" then
    for _, result in ipairs(...) do
      updateFavStatus(result.itemKey)
    end
  elseif event == "COMMODITY_SEARCH_RESULTS_UPDATED" or event == "COMMODITY_SEARCH_RESULTS_ADDED" then
    updateFavStatus(C_AuctionHouse.MakeItemKey(...))
  elseif event == "ITEM_SEARCH_RESULTS_UPDATED" or event == "ITEM_SEARCH_RESULTS_ADDED" then
    updateFavStatus(...)
  end
end

favFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
favFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
favFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_ADDED")
favFrame:RegisterEvent("COMMODITY_SEARCH_RESULTS_UPDATED")
favFrame:RegisterEvent("COMMODITY_SEARCH_RESULTS_ADDED")
favFrame:RegisterEvent("ITEM_SEARCH_RESULTS_UPDATED")
favFrame:RegisterEvent("ITEM_SEARCH_RESULTS_ADDED")
favFrame:SetScript("OnEvent", handleFavEvent)
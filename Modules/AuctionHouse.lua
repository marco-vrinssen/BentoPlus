-- Enable expansion filter and spacebar posting.

local auctionHouseEventFrame = CreateFrame("Frame")
local postAuctionKey = "SPACE"
local isSpacebarPostingEnabled = false

-- Apply the current expansion filter to the search bar.

local function applyExpansionFilter()
  local searchBar = AuctionHouseFrame and AuctionHouseFrame.SearchBar
  if not searchBar or not searchBar.FilterButton then
    return
  end
  searchBar.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
  searchBar:UpdateClearFiltersButton()
end

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

-- Handle auction house and keyboard events.

local function handleAuctionHouseEvent(self, event, ...)
  if event == "AUCTION_HOUSE_SHOW" then
    if AuctionHouseFrame and AuctionHouseFrame.SearchBar then
      local searchBar = AuctionHouseFrame.SearchBar
      if not searchBar._bentoPlusFilterHooked then
        searchBar:HookScript("OnShow", applyExpansionFilter)
        searchBar._bentoPlusFilterHooked = true
      end
      applyExpansionFilter()
    end
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

auctionHouseEventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
auctionHouseEventFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
auctionHouseEventFrame:SetScript("OnEvent", handleAuctionHouseEvent)

-- Initialize persistent storage for auction favorites.

local auctionFavoritesKey = "AuctionFavorites"
if not BentoDB then
  BentoDB = {}
end
if BentoDB[auctionFavoritesKey] == nil then
  BentoDB[auctionFavoritesKey] = {}
end

-- Create a serialized string from an item key for storage.

local function createItemKeyString(itemKey)
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

local function storeFavoriteItem(itemKey, isFavorite)
  if not BentoDB then
    BentoDB = {}
  end
  if not BentoDB[auctionFavoritesKey] then
    BentoDB[auctionFavoritesKey] = {}
  end

  local keyString = createItemKeyString(itemKey)
  if isFavorite then
    BentoDB[auctionFavoritesKey][keyString] = itemKey
  else
    BentoDB[auctionFavoritesKey][keyString] = nil
  end
end

-- Update the favorite status for a given item.

local function updateFavoriteStatus(itemKey)
  storeFavoriteItem(itemKey, C_AuctionHouse.IsFavoriteItem(itemKey))
end

-- Hook favorite changes to automatically update the database.

hooksecurefunc(C_AuctionHouse, "SetFavoriteItem", storeFavoriteItem)

-- Create an event frame for managing auction house favorites.

local favoritesEventFrame = CreateFrame("Frame")
favoritesEventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
favoritesEventFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
favoritesEventFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_ADDED")
favoritesEventFrame:RegisterEvent("COMMODITY_SEARCH_RESULTS_UPDATED")
favoritesEventFrame:RegisterEvent("COMMODITY_SEARCH_RESULTS_ADDED")
favoritesEventFrame:RegisterEvent("ITEM_SEARCH_RESULTS_UPDATED")
favoritesEventFrame:RegisterEvent("ITEM_SEARCH_RESULTS_ADDED")

-- Handle auction house events for favorites management.

favoritesEventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "AUCTION_HOUSE_SHOW" then
    local refreshNeeded = false
    if BentoDB and BentoDB[auctionFavoritesKey] then
      for _, itemKey in pairs(BentoDB[auctionFavoritesKey]) do
        C_AuctionHouse.SetFavoriteItem(itemKey, true)
        refreshNeeded = true
      end
    end
    if refreshNeeded then
      C_AuctionHouse.SearchForFavorites({})
    end
  elseif event == "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED" then
    for _, result in ipairs(C_AuctionHouse.GetBrowseResults()) do
      updateFavoriteStatus(result.itemKey)
    end
  elseif event == "AUCTION_HOUSE_BROWSE_RESULTS_ADDED" then
    for _, result in ipairs(...) do
      updateFavoriteStatus(result.itemKey)
    end
  elseif event == "COMMODITY_SEARCH_RESULTS_UPDATED" or event == "COMMODITY_SEARCH_RESULTS_ADDED" then
    updateFavoriteStatus(C_AuctionHouse.MakeItemKey(...))
  elseif event == "ITEM_SEARCH_RESULTS_UPDATED" or event == "ITEM_SEARCH_RESULTS_ADDED" then
    updateFavoriteStatus(...)
  end
end)
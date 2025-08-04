-- Synchronize auction house favorite items across sessions.

local favoritesEventFrame = CreateFrame("Frame")
local auctionFavoritesKey = "AuctionFavorites"

-- Initialize persistent storage for auction favorites.

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

-- Handle auction house events for favorites management.

local function handleFavoritesEvent(self, event, ...)
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
end

favoritesEventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
favoritesEventFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
favoritesEventFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_ADDED")
favoritesEventFrame:RegisterEvent("COMMODITY_SEARCH_RESULTS_UPDATED")
favoritesEventFrame:RegisterEvent("COMMODITY_SEARCH_RESULTS_ADDED")
favoritesEventFrame:RegisterEvent("ITEM_SEARCH_RESULTS_UPDATED")
favoritesEventFrame:RegisterEvent("ITEM_SEARCH_RESULTS_ADDED")
favoritesEventFrame:SetScript("OnEvent", handleFavoritesEvent)

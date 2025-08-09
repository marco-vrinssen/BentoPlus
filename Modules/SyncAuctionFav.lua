-- Update auction favorites to persist and restore so that we keep choices across sessions

local favoriteFrame = CreateFrame("Frame")
local favoriteKey = "AuctionFavorites"

-- Initialize persistent storage for favorites table

if not BentoDB then
  BentoDB = {}
end
if BentoDB[favoriteKey] == nil then
  BentoDB[favoriteKey] = {}
end

-- Serialize itemKey table into stable key string

local function buildKeyString(itemKey)
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

-- Store or remove a favorite item entry

local function storeFavoriteItem(itemKey, isFavorite)
  if not BentoDB then
    BentoDB = {}
  end
  if not BentoDB[favoriteKey] then
    BentoDB[favoriteKey] = {}
  end

  local keyString = buildKeyString(itemKey)
  if isFavorite then
    BentoDB[favoriteKey][keyString] = itemKey
  else
    BentoDB[favoriteKey][keyString] = nil
  end
end

-- Refresh stored favorite status for an item key

local function refreshFavorite(itemKey)
  storeFavoriteItem(itemKey, C_AuctionHouse.IsFavoriteItem(itemKey))
end

-- Hook SetFavoriteItem to update persistence automatically

hooksecurefunc(C_AuctionHouse, "SetFavoriteItem", storeFavoriteItem)

-- Handle auction house events to sync and refresh favorites

local function handleFavoriteEvent(self, event, ...)
  if event == "AUCTION_HOUSE_SHOW" then
    local refreshNeeded = false
    if BentoDB and BentoDB[favoriteKey] then
      for _, itemKey in pairs(BentoDB[favoriteKey]) do
        C_AuctionHouse.SetFavoriteItem(itemKey, true)
        refreshNeeded = true
      end
    end
    if refreshNeeded then
      C_AuctionHouse.SearchForFavorites({})
    end
  elseif event == "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED" then
    for _, result in ipairs(C_AuctionHouse.GetBrowseResults()) do
      refreshFavorite(result.itemKey)
    end
  elseif event == "AUCTION_HOUSE_BROWSE_RESULTS_ADDED" then
    for _, result in ipairs(...) do
      refreshFavorite(result.itemKey)
    end
  elseif event == "COMMODITY_SEARCH_RESULTS_UPDATED" or event == "COMMODITY_SEARCH_RESULTS_ADDED" then
    refreshFavorite(C_AuctionHouse.MakeItemKey(...))
  elseif event == "ITEM_SEARCH_RESULTS_UPDATED" or event == "ITEM_SEARCH_RESULTS_ADDED" then
    refreshFavorite(...)
  end
end

favoriteFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
favoriteFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
favoriteFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_ADDED")
favoriteFrame:RegisterEvent("COMMODITY_SEARCH_RESULTS_UPDATED")
favoriteFrame:RegisterEvent("COMMODITY_SEARCH_RESULTS_ADDED")
favoriteFrame:RegisterEvent("ITEM_SEARCH_RESULTS_UPDATED")
favoriteFrame:RegisterEvent("ITEM_SEARCH_RESULTS_ADDED")
favoriteFrame:SetScript("OnEvent", handleFavoriteEvent)
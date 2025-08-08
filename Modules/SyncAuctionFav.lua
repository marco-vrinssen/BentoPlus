-- Persist and restore auction house favorite items across sessions only (split logic)

local favFrame = CreateFrame("Frame")
local favKey = "AuctionFavorites"

-- Initialize persistent storage for favorites table

if not BentoDB then
  BentoDB = {}
end
if BentoDB[favKey] == nil then
  BentoDB[favKey] = {}
end

-- Serialize itemKey table into stable key string

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

-- Store or remove a favorite item entry

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

-- Refresh stored favorite status for an item key

local function updateFavStatus(itemKey)
  storeFavItem(itemKey, C_AuctionHouse.IsFavoriteItem(itemKey))
end

-- Hook SetFavoriteItem to update persistence automatically

hooksecurefunc(C_AuctionHouse, "SetFavoriteItem", storeFavItem)

-- Handle auction house events to sync and refresh favorites

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
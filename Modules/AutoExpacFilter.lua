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

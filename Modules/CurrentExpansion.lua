-- Automatically apply current expansion filter to auction house search.

local expansionFilterEventFrame = CreateFrame("Frame")

-- Apply the current expansion filter to the search bar.

local function applyExpansionFilter()
  local searchBar = AuctionHouseFrame and AuctionHouseFrame.SearchBar
  if not searchBar or not searchBar.FilterButton then
    return
  end
  searchBar.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
  searchBar:UpdateClearFiltersButton()
end

-- Handle auction house events for expansion filter.

local function handleExpansionFilterEvent(self, event, ...)
  if event == "AUCTION_HOUSE_SHOW" then
    if AuctionHouseFrame and AuctionHouseFrame.SearchBar then
      local searchBar = AuctionHouseFrame.SearchBar
      if not searchBar._bentoPlusFilterHooked then
        searchBar:HookScript("OnShow", applyExpansionFilter)
        searchBar._bentoPlusFilterHooked = true
      end
      applyExpansionFilter()
    end
  end
end

expansionFilterEventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
expansionFilterEventFrame:SetScript("OnEvent", handleExpansionFilterEvent)

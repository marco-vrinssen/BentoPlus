-- Update search to apply current expansion filter so that we streamline auction results

local expansionFilterFrame = CreateFrame("Frame")

-- Apply current expansion filter state to search bar button

local function applyExpansionFilter()
  local searchBar = AuctionHouseFrame and AuctionHouseFrame.SearchBar
  if not searchBar or not searchBar.FilterButton then
    return
  end
  searchBar.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
  searchBar:UpdateClearFiltersButton()
end

-- Hook search bar and apply filter when auction house is shown

local function handleExpansionEvent(self, event, ...)
  if event == "AUCTION_HOUSE_SHOW" then
    if AuctionHouseFrame and AuctionHouseFrame.SearchBar then
      local searchBar = AuctionHouseFrame.SearchBar
      if not searchBar._bentoFilterHooked then
        searchBar:HookScript("OnShow", applyExpansionFilter)
        searchBar._bentoFilterHooked = true
      end
      applyExpansionFilter()
    end
  end
end

expansionFilterFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
expansionFilterFrame:SetScript("OnEvent", handleExpansionEvent)
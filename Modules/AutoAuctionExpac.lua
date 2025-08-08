-- Apply current expansion filter to search

local expFilterFrame = CreateFrame("Frame")

-- Apply current expansion filter state to search bar button

local function applyExpFilter()
  local searchBar = AuctionHouseFrame and AuctionHouseFrame.SearchBar
  if not searchBar or not searchBar.FilterButton then
    return
  end
  searchBar.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
  searchBar:UpdateClearFiltersButton()
end

-- Hook search bar and apply filter when AH is shown

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
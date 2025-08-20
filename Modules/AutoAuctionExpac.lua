-- Scope auction house searches to current expansion for cleaner results

-- Listen for auction house show event

local auctionEventFrame = CreateFrame("Frame")

-- Apply current expansion filter on search bar

local function applyExpansionFilter()
  local searchBar = AuctionHouseFrame and AuctionHouseFrame.SearchBar
  local filterButton = searchBar and searchBar.FilterButton
  if not filterButton then return end

  filterButton.filters = filterButton.filters or {}
  filterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
  searchBar:UpdateClearFiltersButton()
end

-- Hook and apply on auction house show

local function auctionHouseEvent(_, event)
  if event ~= "AUCTION_HOUSE_SHOW" then return end

  local searchBar = AuctionHouseFrame and AuctionHouseFrame.SearchBar
  if not searchBar then return end

  if not searchBar.bentoHooked then
    searchBar:HookScript("OnShow", applyExpansionFilter)
    searchBar.bentoHooked = true
  end

  applyExpansionFilter()
end

auctionEventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
auctionEventFrame:SetScript("OnEvent", auctionHouseEvent)
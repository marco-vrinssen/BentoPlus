-- Keep AH searches scoped to the current expansion for cleaner results

local ahEventFrame = CreateFrame("Frame")

-- Apply current-expansion-only filter on the search bar
local function applyCurrExpFilter()
  local searchBar = AuctionHouseFrame and AuctionHouseFrame.SearchBar
  local filterBtn = searchBar and searchBar.FilterButton
  if not filterBtn then return end

  filterBtn.filters = filterBtn.filters or {}
  filterBtn.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
  searchBar:UpdateClearFiltersButton()
end

-- Hook and apply on AH show
local function onAHEvent(_, event)
  if event ~= "AUCTION_HOUSE_SHOW" then return end

  local searchBar = AuctionHouseFrame and AuctionHouseFrame.SearchBar
  if not searchBar then return end

  if not searchBar._bentoExpHooked then
    searchBar:HookScript("OnShow", applyCurrExpFilter)
    searchBar._bentoExpHooked = true
  end

  applyCurrExpFilter()
end

ahEventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
ahEventFrame:SetScript("OnEvent", onAHEvent)
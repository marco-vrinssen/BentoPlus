-- Set the loot rate to be instant.

local function setInstantLootRate()
  SetCVar("autoLootRate", 0)
end

-- Loot all available items from the loot frame.

local function lootAllItems()
  if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
    local lootCount = GetNumLootItems()
    if lootCount > 0 then
      LootFrame:Hide()
      for slot = lootCount, 1, -1 do
        LootSlot(slot)
      end
    end
  end
end

-- Close the loot window if it is empty.

local function closeEmptyLootWindow()
  if GetNumLootItems() == 0 then
    CloseLoot()
  end
end

-- Handle all loot-related events.

local function handleLootEvents(_, eventType)
  if eventType == "PLAYER_ENTERING_WORLD" then
    setInstantLootRate()
  elseif eventType == "LOOT_READY" then
    lootAllItems()
  elseif eventType == "LOOT_OPENED" then
    closeEmptyLootWindow()
  end
end

-- Register loot events.

local lootEventsFrame = CreateFrame("Frame")
lootEventsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
lootEventsFrame:RegisterEvent("LOOT_READY")
lootEventsFrame:RegisterEvent("LOOT_OPENED")
lootEventsFrame:SetScript("OnEvent", handleLootEvents)
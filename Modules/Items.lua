-- Sell all junk items at a merchant.

local function sellAllJunk()
  C_Timer.After(0, function()
    MerchantSellAllJunkButton:Click()

    C_Timer.After(0, function()
      StaticPopup1Button1:Click()
    end)
  end)
end

-- Repair all equipment at a merchant.

local function repairAllItems()
  C_Timer.After(0, function()
    MerchantRepairAllButton:Click()
  end)
end

-- Handle events when the merchant window is shown.

local function handleMerchantShow()
  sellAllJunk()
  repairAllItems()
end

-- Register merchant events.

local merchantEventsFrame = CreateFrame("Frame")
merchantEventsFrame:SetScript("OnEvent", handleMerchantShow)
merchantEventsFrame:RegisterEvent("MERCHANT_SHOW")

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
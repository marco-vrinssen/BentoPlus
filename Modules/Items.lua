-- Auto loot functionality with delay

local lootTime = 0
local LOOT_DELAY = 0.05

-- Set instant auto loot rate

local function setInstantAutoLootRate()
    SetCVar("autoLootRate", 0)
end

-- Handle auto loot with delay

local function handleAutoLootWithDelay()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        if (GetTime() - lootTime) >= LOOT_DELAY then
            for slotIndex = GetNumLootItems(), 1, -1 do
                LootSlot(slotIndex)
            end
            lootTime = GetTime()
        end
    end
end

local lootAddon = CreateFrame("Frame")
lootAddon:RegisterEvent("PLAYER_ENTERING_WORLD")
lootAddon:RegisterEvent("LOOT_READY")
lootAddon:SetScript("OnEvent", function(self, eventType)
    if eventType == "PLAYER_ENTERING_WORLD" then
        setInstantAutoLootRate()
    elseif eventType == "LOOT_READY" then
        handleAutoLootWithDelay()
    end
end)

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


-- Sell junk items at merchants
local function sellJunkItems()
    C_Timer.After(0.1, function()
        MerchantSellAllJunkButton:Click()
        
        C_Timer.After(0.1, function()
            StaticPopup1Button1:Click()
        end)
    end)
end

-- Repair equipment at merchants
local function repairEquipment()
    C_Timer.After(0.1, function()
        MerchantRepairAllButton:Click()
    end)
end

-- Handle merchant window events
local function onMerchantShow()
    sellJunkItems()
    repairEquipment()
end

-- Register merchant events
local merchantFrame = CreateFrame("Frame")
merchantFrame:SetScript("OnEvent", onMerchantShow)
merchantFrame:RegisterEvent("MERCHANT_SHOW")


-- Set instant loot rate
local function setInstantLoot()
    SetCVar("autoLootRate", 0)
end

-- Loot all items when auto loot enabled
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

-- Close empty loot windows
local function closeLootIfEmpty()
    if GetNumLootItems() == 0 then
        CloseLoot()
    end
end

-- Register loot events
local lootFrame = CreateFrame("Frame")
lootFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
lootFrame:RegisterEvent("LOOT_READY")
lootFrame:RegisterEvent("LOOT_OPENED")
lootFrame:SetScript("OnEvent", function(_, eventType)
    if eventType == "PLAYER_ENTERING_WORLD" then
        setInstantLoot()
    elseif eventType == "LOOT_READY" then
        lootAllItems()
    elseif eventType == "LOOT_OPENED" then
        closeLootIfEmpty()
    end
end)
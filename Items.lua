-- AUTO SELL JUNK AND REPAIR ITEMS

local function AutoSellRepair()
    MerchantSellAllJunkButton:Click()
    StaticPopup1Button1:Click()
    C_Timer.After(0, function()
        MerchantRepairAllButton:Click()
    end)
end

local MerchantEvents = CreateFrame("Frame")
MerchantEvents:SetScript("OnEvent", AutoSellRepair)
MerchantEvents:RegisterEvent("MERCHANT_SHOW")




-- SPEED UP AUTO LOOTING

local function FasterLooting()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        local ItemsTotal = GetNumLootItems()
        if ItemsTotal > 0 then
            LootFrame:Hide()
            for ItemCount = 1, ItemsTotal do
                LootSlot(ItemCount)
            end
            LootFrame:Hide()
        end
    end
end

local LootEvents = CreateFrame("Frame")
LootEvents:RegisterEvent("LOOT_READY")
LootEvents:SetScript("OnEvent", FasterLooting)
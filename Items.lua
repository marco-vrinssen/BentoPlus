-- AUTO SELL JUNK AND REPAIR ITEMS

local function AutoSellRepair()
    MerchantSellAllJunkButton:Click()
    StaticPopup1Button1:Click()
    C_Timer.After(0.1, function()
        MerchantRepairAllButton:Click()
    end)
end

local MerchantEvents = CreateFrame("Frame")
MerchantEvents:SetScript("OnEvent", AutoSellRepair)
MerchantEvents:RegisterEvent("MERCHANT_SHOW")




-- SPEED UP AUTO LOOTING

local function AutoLootAllItems()
    if GetCVar("autoLootDefault") == "1" and not IsModifiedClick("AUTOLOOTTOGGLE") then
        for i = GetNumLootItems(), 1, -1 do
            LootSlot(i)
        end
        LootFrame:Hide()
    end
end

local LootFrame = CreateFrame("Frame")
LootFrame:SetScript("OnEvent", AutoLootAllItems)
LootFrame:RegisterEvent("LOOT_READY")
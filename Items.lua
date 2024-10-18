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




-- SPEED UP AUTO LOOTING ITEMS

local function AutoLootItems()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        for i = GetNumLootItems(), 1, -1 do
            LootSlot(i)
        end
    end
end

local LootEvents = CreateFrame("Frame")
LootEvents:SetScript("OnEvent", AutoLootItems)
LootEvents:RegisterEvent("LOOT_READY")
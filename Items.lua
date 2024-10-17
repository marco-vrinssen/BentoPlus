-- AUTO SELL JUNK AND REPAIR ITEMS

local function AutoSellRepair()
    MerchantSellAllJunkButton:Click()
    StaticPopup1Button1:Click()
    MerchantRepairAllButton:Click()
end

local MerchantEvents = CreateFrame("Frame")
MerchantEvents:SetScript("OnEvent", AutoSellRepair)
MerchantEvents:RegisterEvent("MERCHANT_SHOW")




-- AUTO LOOT ALL ITEMS
local function AutoLootAllItems()
    if GetCVarBool("autoLootDefault") and not IsModifiedClick("AUTOLOOTTOGGLE") then
        for i = GetNumLootItems(), 1, -1 do
            LootSlot(i)
        end
    end
end

local LootFrame = CreateFrame("Frame")
LootFrame:SetScript("OnEvent", AutoLootAllItems)
LootFrame:RegisterEvent("LOOT_READY")
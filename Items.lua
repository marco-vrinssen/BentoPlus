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
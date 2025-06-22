local function sellJunkAndRepair()
    MerchantSellAllJunkButton:Click()
    StaticPopup1Button1:Click()
    C_Timer.After(0, function()
        MerchantRepairAllButton:Click()
    end)
end

-- Initialize merchant automation

local merchantHandler = CreateFrame("Frame")
merchantHandler:SetScript("OnEvent", sellJunkAndRepair)
merchantHandler:RegisterEvent("MERCHANT_SHOW")
-- Process automated junk selling

local function processJunkSelling()
    C_Timer.After(0.1, function()
        MerchantSellAllJunkButton:Click()
        
        C_Timer.After(0.1, function()
            StaticPopup1Button1:Click()
        end)
    end)
end

-- Process automated equipment repair

local function processEquipmentRepair()
    C_Timer.After(0.1, function()
        MerchantRepairAllButton:Click()
    end)
end

-- Handle merchant interaction events

local function handleMerchantShow()
    processJunkSelling()
    processEquipmentRepair()
end

-- Initialize merchant automation

local merchantHandler = CreateFrame("Frame")
merchantHandler:SetScript("OnEvent", handleMerchantShow)
merchantHandler:RegisterEvent("MERCHANT_SHOW")
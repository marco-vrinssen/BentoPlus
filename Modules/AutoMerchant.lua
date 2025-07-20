

-- Sell all junk items automatically when merchant window opens

local function sellAllJunkItemsAutomatically()
    C_Timer.After(0.1, function()
        MerchantSellAllJunkButton:Click()

        C_Timer.After(0.1, function()
            StaticPopup1Button1:Click()
        end)
    end)
end



-- Repair all equipment automatically when merchant window opens

local function repairAllEquipmentAutomatically()
    C_Timer.After(0.1, function()
        MerchantRepairAllButton:Click()
    end)
end



-- Handle merchant window show event to trigger automation

local function handleMerchantWindowShowEvent()
    sellAllJunkItemsAutomatically()
    repairAllEquipmentAutomatically()
end



-- Create merchantAutomationEventFrame to manage merchant automation events

local merchantAutomationEventFrame = CreateFrame("Frame")
merchantAutomationEventFrame:SetScript("OnEvent", handleMerchantWindowShowEvent)
merchantAutomationEventFrame:RegisterEvent("MERCHANT_SHOW")
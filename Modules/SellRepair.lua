-- Automatically sell all junk items to merchant
local function sellJunk()
    C_Timer.After(0, function()
        MerchantSellAllJunkButton:Click()
        
        -- Confirm the sale popup
        C_Timer.After(0, function()
            StaticPopup1Button1:Click()
        end)
    end)
end

-- Automatically repair all items using merchant services
local function repairItems()
    C_Timer.After(0, function()
        MerchantRepairAllButton:Click()
    end)
end

-- Handle merchant interaction by selling junk and repairing items
local function handleMerchant()
    sellJunk()
    repairItems()
end

-- Create and configure merchant event handler
local merchantFrame = CreateFrame("Frame")
merchantFrame:SetScript("OnEvent", handleMerchant)
merchantFrame:RegisterEvent("MERCHANT_SHOW")
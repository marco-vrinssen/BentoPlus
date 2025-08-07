-- Sell all junk items at a merchant.

local function sellAllJunk()
  C_Timer.After(0, function()
    MerchantSellAllJunkButton:Click()

    C_Timer.After(0, function()
      StaticPopup1Button1:Click()
    end)
  end)
end

-- Repair all equipment at a merchant.

local function repairAllItems()
  C_Timer.After(0, function()
    MerchantRepairAllButton:Click()
  end)
end

-- Handle events when the merchant window is shown.

local function handleMerchantShow()
  sellAllJunk()
  repairAllItems()
end

-- Register merchant events.

local merchantEventsFrame = CreateFrame("Frame")
merchantEventsFrame:SetScript("OnEvent", handleMerchantShow)
merchantEventsFrame:RegisterEvent("MERCHANT_SHOW")
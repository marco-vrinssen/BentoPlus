

-- Select warband bank tab automatically when bank frame opens

local warbandBankTabEventFrame = CreateFrame("Frame")
warbandBankTabEventFrame:RegisterEvent("BANKFRAME_OPENED")
warbandBankTabEventFrame:SetScript("OnEvent", function()
    C_Timer.After(0.1, function()
        BankFrameTab3:Click()
    end)
end)
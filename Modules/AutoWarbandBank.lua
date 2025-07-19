-- Automate warband tab selection

local bankHandler = CreateFrame("Frame")
bankHandler:RegisterEvent("BANKFRAME_OPENED")
bankHandler:SetScript("OnEvent", function()
    C_Timer.After(0.1, function()
        BankFrameTab3:Click()
    end)
end)
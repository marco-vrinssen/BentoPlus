-- Automatically select the warband bank tab when the bank frame is opened.

local warbandBankFrame = CreateFrame("Frame")
warbandBankFrame:RegisterEvent("BANKFRAME_OPENED")
warbandBankFrame:SetScript("OnEvent", function()
  C_Timer.After(0, function()
    BankFrameTab3:Click()
  end)
end)
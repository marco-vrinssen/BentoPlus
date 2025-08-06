-- Automatically select the warband bank tab when the bank frame is opened.

local warbandFrame = CreateFrame("Frame")
warbandFrame:RegisterEvent("BANKFRAME_OPENED")
warbandFrame:SetScript("OnEvent", function()
  C_Timer.After(0, function()
    BankFrameTab3:Click()
  end)
end)
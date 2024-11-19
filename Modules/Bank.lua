-- Auto-open Warband Bank tab when the bank frame is accessed.

local BankFrameEvents = CreateFrame("Frame")
BankFrameEvents:RegisterEvent("BANKFRAME_OPENED")
BankFrameEvents:SetScript("OnEvent", function()
    C_Timer.After(0, BankFrameTab3:Click())
end)
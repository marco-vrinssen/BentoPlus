-- Auto-open Warband Bank tab when the bank frame is accessed.

-- Function to handle the BANKFRAME_OPENED event
local function OpenWarbandBankTab()
    BankFrameTab3:Click()
end

-- Create a frame to handle bank frame events
local BankFrameEvents = CreateFrame("Frame")
BankFrameEvents:RegisterEvent("BANKFRAME_OPENED")
BankFrameEvents:SetScript("OnEvent", function()
    C_Timer.After(0, OpenWarbandBankTab)
end)
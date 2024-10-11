-- OPEN WARBAND BANK WHEN OPENING BANK FRAME

local function OpenWarbandBank()
    BankFrameTab3:Click()
end

local BankFrameEvents = CreateFrame("Frame")
BankFrameEvents:RegisterEvent("BANKFRAME_OPENED")
BankFrameEvents:SetScript("OnEvent", function()
    C_Timer.After(0, OpenWarbandBank)
end)
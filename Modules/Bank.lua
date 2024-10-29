-- Auto-open Warband Bank tab when the bank frame is accessed.

local function openWarbandBank()
    BankFrameTab3:Click()
end

local bankFrameEvents = CreateFrame("Frame")
bankFrameEvents:RegisterEvent("BANKFRAME_OPENED")

bankFrameEvents:SetScript("OnEvent", function()
    C_Timer.After(0, openWarbandBank)
end)
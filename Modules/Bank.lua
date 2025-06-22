local function openWarbandTab()
    BankFrameTab3:Click()
end

-- Initialize warband tab automation

local bankEventHandler = CreateFrame("Frame")
bankEventHandler:RegisterEvent("BANKFRAME_OPENED")
bankEventHandler:SetScript("OnEvent", function()
    C_Timer.After(0, openWarbandTab)
end)
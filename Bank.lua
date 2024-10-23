-- Function to open the Warband Bank tab
local function openWarbandBank()
    BankFrameTab3:Click()
end

-- Create a frame to handle bank frame events
local bankFrameEvents = CreateFrame("Frame")
bankFrameEvents:RegisterEvent("BANKFRAME_OPENED")

-- Set the script to run when the bank frame is opened
bankFrameEvents:SetScript("OnEvent", function()
    C_Timer.After(0, openWarbandBank)
end)
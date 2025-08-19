-- Update vehicle seat indicator to stay hidden so that we declutter screen

local vehicleSeatIndicatorFrame = _G["VehicleSeatIndicator"]
vehicleSeatIndicatorFrame:Hide()
vehicleSeatIndicatorFrame:SetScript("OnShow", vehicleSeatIndicatorFrame.Hide)
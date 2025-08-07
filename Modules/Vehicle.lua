-- Hide vehicle seat indicator permanently

local vehicleSeatIndicatorFrame = _G["VehicleSeatIndicator"]
vehicleSeatIndicatorFrame:Hide()
vehicleSeatIndicatorFrame:SetScript("OnShow", vehicleSeatIndicatorFrame.Hide)
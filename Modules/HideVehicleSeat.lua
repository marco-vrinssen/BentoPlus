
-- Hide the vehicle seat indicator frame and prevent it from showing

local vehicleSeatIndicatorFrame = _G["VehicleSeatIndicator"]
vehicleSeatIndicatorFrame:Hide()
vehicleSeatIndicatorFrame:SetScript("OnShow", vehicleSeatIndicatorFrame.Hide)
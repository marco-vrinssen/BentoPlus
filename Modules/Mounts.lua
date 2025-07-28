-- Hide the vehicle seat indicator and prevent it from reappearing.

local vehicleSeatIndicator = _G["VehicleSeatIndicator"]
vehicleSeatIndicator:Hide()
vehicleSeatIndicator:SetScript("OnShow", vehicleSeatIndicator.Hide)
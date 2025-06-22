-- Initialize vehicle seat hiding

local vehicleIndicator = _G["VehicleSeatIndicator"]
vehicleIndicator:Hide()
vehicleIndicator:SetScript("OnShow", vehicleIndicator.Hide)
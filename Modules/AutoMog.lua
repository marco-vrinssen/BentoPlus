-- Automatically apply transmog changes when wardrobe opens

local function autoTransmogApplyOnWardrobeShow()
    if not WardrobeTransmogFrame or not WardrobeTransmogFrame.ApplyButton then return end
    C_Timer.After(0.1, function()
        if WardrobeTransmogFrame.ApplyButton:IsEnabled() then
            WardrobeTransmogFrame.ApplyButton:Click()
        end
    end)
end

if WardrobeTransmogFrame then
    WardrobeTransmogFrame:HookScript("OnShow", autoTransmogApplyOnWardrobeShow)
else
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(self, event, addonName)
        if addonName == "Blizzard_Collections" and WardrobeTransmogFrame then
            WardrobeTransmogFrame:HookScript("OnShow", autoTransmogApplyOnWardrobeShow)
            self:UnregisterEvent("ADDON_LOADED")
        end
    end)
end
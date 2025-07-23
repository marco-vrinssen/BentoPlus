-- Apply transmog changes on wardrobe show
local function applyChanges()
    if not WardrobeTransmogFrame or not WardrobeTransmogFrame.ApplyButton then return end
    C_Timer.After(0.1, function()
        if WardrobeTransmogFrame.ApplyButton:IsEnabled() then
            WardrobeTransmogFrame.ApplyButton:Click()
        end
    end)
end

-- Hook wardrobe frame events
if WardrobeTransmogFrame then
    WardrobeTransmogFrame:HookScript("OnShow", applyChanges)
else
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(self, event, addon)
        if addon == "Blizzard_Collections" and WardrobeTransmogFrame then
            WardrobeTransmogFrame:HookScript("OnShow", applyChanges)
            self:UnregisterEvent("ADDON_LOADED")
        end
    end)
end
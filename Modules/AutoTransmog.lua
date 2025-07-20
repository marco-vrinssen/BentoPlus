

-- Apply transmog changes automatically when the wardrobe frame is shown

local function applyTransmogChangesOnWardrobeShow()
    if not WardrobeTransmogFrame or not WardrobeTransmogFrame.ApplyButton then return end
    C_Timer.After(0.1, function()
        if WardrobeTransmogFrame.ApplyButton:IsEnabled() then
            WardrobeTransmogFrame.ApplyButton:Click()
        end
    end)
end



-- Register wardrobe show event to trigger automatic transmog application

if WardrobeTransmogFrame then
    WardrobeTransmogFrame:HookScript("OnShow", applyTransmogChangesOnWardrobeShow)
else
    local wardrobeTransmogEventFrame = CreateFrame("Frame")
    wardrobeTransmogEventFrame:RegisterEvent("ADDON_LOADED")
    wardrobeTransmogEventFrame:SetScript("OnEvent", function(self, eventTypeString, loadedAddonNameString)
        if loadedAddonNameString == "Blizzard_Collections" and WardrobeTransmogFrame then
            WardrobeTransmogFrame:HookScript("OnShow", applyTransmogChangesOnWardrobeShow)
            self:UnregisterEvent("ADDON_LOADED")
        end
    end)
end
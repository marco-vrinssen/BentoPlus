-- Apply transmog changes when the wardrobe is shown.

local function applyTransmogChanges()
  if not WardrobeTransmogFrame or not WardrobeTransmogFrame.ApplyButton then
    return
  end
  C_Timer.After(0.1, function()
    if WardrobeTransmogFrame.ApplyButton:IsEnabled() then
      WardrobeTransmogFrame.ApplyButton:Click()
    end
  end)
end

-- Hook into the wardrobe frame to apply changes automatically.

if WardrobeTransmogFrame then
  WardrobeTransmogFrame:HookScript("OnShow", applyTransmogChanges)
else
  local transmogEventFrame = CreateFrame("Frame")
  transmogEventFrame:RegisterEvent("ADDON_LOADED")
  transmogEventFrame:SetScript("OnEvent", function(self, event, addon)
    if addon == "Blizzard_Collections" and WardrobeTransmogFrame then
      WardrobeTransmogFrame:HookScript("OnShow", applyTransmogChanges)
      self:UnregisterEvent("ADDON_LOADED")
    end
  end)
end
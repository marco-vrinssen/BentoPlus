-- Apply transmog changes when the wardrobe is shown.

local function applyMogChanges()
  if not WardrobeTransmogFrame or not WardrobeTransmogFrame.ApplyButton then
    return
  end
  C_Timer.After(0, function()
    if WardrobeTransmogFrame.ApplyButton:IsEnabled() then
      WardrobeTransmogFrame.ApplyButton:Click()
    end
  end)
end

-- Hook into the wardrobe frame to apply changes automatically.

if WardrobeTransmogFrame then
  WardrobeTransmogFrame:HookScript("OnShow", applyMogChanges)
else
  local mogFrame = CreateFrame("Frame")
  mogFrame:RegisterEvent("ADDON_LOADED")
  mogFrame:SetScript("OnEvent", function(self, event, addon)
    if addon == "Blizzard_Collections" and WardrobeTransmogFrame then
      WardrobeTransmogFrame:HookScript("OnShow", applyMogChanges)
      self:UnregisterEvent("ADDON_LOADED")
    end
  end)
end
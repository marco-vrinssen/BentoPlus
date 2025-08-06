-- Hide prestige elements from target frame

local function hideTargetFramePrestigeElements()
  if TargetFrame and TargetFrame.TargetFrameContent and TargetFrame.TargetFrameContent.TargetFrameContentContextual then
    local targetFrameContextual = TargetFrame.TargetFrameContent.TargetFrameContentContextual
    
    if targetFrameContextual.PrestigeBadge then
      targetFrameContextual.PrestigeBadge:SetShown(false)
    end
    
    if targetFrameContextual.PrestigePortrait then
      targetFrameContextual.PrestigePortrait:SetShown(false)
    end
  end
end

-- Monitor target changes to hide prestige elements

local targetFramePrestigeFrame = CreateFrame("Frame")
targetFramePrestigeFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
targetFramePrestigeFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
targetFramePrestigeFrame:SetScript("OnEvent", hideTargetFramePrestigeElements)
-- Hide prestige elements from player frame

local function hidePlayerFramePrestigeElements()
  if PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual then
    local playerFrameContextual = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual
    
    if playerFrameContextual.PrestigeBadge then
      playerFrameContextual.PrestigeBadge:SetShown(false)
    end
    
    if playerFrameContextual.PrestigePortrait then
      playerFrameContextual.PrestigePortrait:SetShown(false)
    end
  end
end

-- Monitor player frame updates to hide prestige elements

local playerFramePrestigeFrame = CreateFrame("Frame")
playerFramePrestigeFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
playerFramePrestigeFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
playerFramePrestigeFrame:SetScript("OnEvent", hidePlayerFramePrestigeElements)
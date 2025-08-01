-- Hide prestige elements from the player frame.

local function hidePlayerPrestigeElements()
  if PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual then
    local playerContext = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual
    if playerContext.PrestigeBadge then
      playerContext.PrestigeBadge:SetShown(false)
    end
    if playerContext.PrestigePortrait then
      playerContext.PrestigePortrait:SetShown(false)
    end
  end
end

-- Register frame events to hide player prestige elements.

local playerFrameEvents = CreateFrame("Frame")
playerFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerFrameEvents:RegisterEvent("UNIT_PORTRAIT_UPDATE")
playerFrameEvents:SetScript("OnEvent", hidePlayerPrestigeElements)
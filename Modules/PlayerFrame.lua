-- Hide prestige elements from the player and target frames.

local function hidePrestigeElements()
  if PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual then
    local playerContext = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual
    if playerContext.PrestigeBadge then
      playerContext.PrestigeBadge:SetShown(false)
    end
    if playerContext.PrestigePortrait then
      playerContext.PrestigePortrait:SetShown(false)
    end
  end

  if TargetFrame and TargetFrame.TargetFrameContent and TargetFrame.TargetFrameContent.TargetFrameContentContextual then
    local targetContext = TargetFrame.TargetFrameContent.TargetFrameContentContextual
    if targetContext.PrestigeBadge then
      targetContext.PrestigeBadge:SetShown(false)
    end
    if targetContext.PrestigePortrait then
      targetContext.PrestigePortrait:SetShown(false)
    end
  end
end

-- Register frame events to hide prestige elements.

local playerFrameEvents = CreateFrame("Frame")
playerFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerFrameEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
playerFrameEvents:RegisterEvent("UNIT_PORTRAIT_UPDATE")
playerFrameEvents:RegisterEvent("PLAYER_LEVEL_UP")
playerFrameEvents:SetScript("OnEvent", hidePrestigeElements)
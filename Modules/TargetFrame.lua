-- Hide prestige elements from the target frame.

local function hideTargetPrestigeElements()
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


-- Register frame events to hide target prestige elements.

local targetFrameEvents = CreateFrame("Frame")
targetFrameEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetFrameEvents:RegisterEvent("UNIT_PORTRAIT_UPDATE")
targetFrameEvents:SetScript("OnEvent", hideTargetPrestigeElements)
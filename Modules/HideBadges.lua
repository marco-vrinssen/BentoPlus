-- Hook prestige badges to hide on show

local function setupHideBadges()
  -- Target badgeEvents badges
  if TargetFrame and TargetFrame.TargetFrameContent and TargetFrame.TargetFrameContent.TargetFrameContentContextual then
    local contextual = TargetFrame.TargetFrameContent.TargetFrameContentContextual
    
    if contextual.PrestigeBadge then
      contextual.PrestigeBadge:SetScript("OnShow", function(self) self:Hide() end)
    end
    
    if contextual.PrestigePortrait then
      contextual.PrestigePortrait:SetScript("OnShow", function(self) self:Hide() end)
    end
  end
  
  -- Player badgeEvents badges
  if PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual then
    local contextual = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual
    
    if contextual.PrestigeBadge then
      contextual.PrestigeBadge:SetScript("OnShow", function(self) self:Hide() end)
    end
    
    if contextual.PrestigePortrait then
      contextual.PrestigePortrait:SetScript("OnShow", function(self) self:Hide() end)
    end
  end
end

-- Apply hooks when ready
local badgeEvents = CreateFrame("Frame")
badgeEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
badgeEvents:SetScript("OnEvent", setupHideBadges)
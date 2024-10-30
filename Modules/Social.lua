-- Move the QuickJoinToastButton to the top left corner with a margin of 24
QuickJoinToastButton:ClearAllPoints()
QuickJoinToastButton:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 24, -24)

-- Reduce the alpha of the QuickJoinToastButton to 50%
QuickJoinToastButton:SetAlpha(0)
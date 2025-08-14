-- Create tooltip frame for main menu button

local menuTooltip = CreateFrame("GameTooltip", "BentoPlusMenuTooltip", UIParent, "GameTooltipTemplate")

-- Add right-click reload and tooltip for main menu button

MainMenuMicroButton:HookScript("OnClick", function(self, mouseButton)
  if mouseButton == "RightButton" then
    ReloadUI()
  end
end)

MainMenuMicroButton:HookScript("OnEnter", function()
  menuTooltip:SetOwner(GameTooltip, "ANCHOR_NONE")
  menuTooltip:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -2)
  menuTooltip:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", 0, -2)
  menuTooltip:ClearLines()
  menuTooltip:AddLine("Right-Click: Reload UI", 1, 1, 1)
  menuTooltip:Show()
end)

MainMenuMicroButton:HookScript("OnLeave", function()
  menuTooltip:Hide()
end)

-- Removed login helper print; consolidated in Intro.lua
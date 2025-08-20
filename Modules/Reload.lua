-- Main menu: right-click reload and helper tooltip

-- create menu tooltip
local tip = CreateFrame("GameTooltip", "BentoPlusMenuTooltip", UIParent, "GameTooltipTemplate")

-- handle right-click reload
local function on_click(_, btn)
  if btn == "RightButton" then ReloadUI() end
end

-- show helper tooltip
local function on_enter()
  tip:SetOwner(GameTooltip, "ANCHOR_NONE")
  tip:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -2)
  tip:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", 0, -2)
  tip:ClearLines()
  tip:AddLine("Right-Click: Reload UI", 1, 1, 1)
  tip:Show()
end

-- hide helper tooltip
local function on_leave()
  tip:Hide()
end

-- hook menu button scripts
if MainMenuMicroButton then
  MainMenuMicroButton:HookScript("OnClick", on_click)
  MainMenuMicroButton:HookScript("OnEnter", on_enter)
  MainMenuMicroButton:HookScript("OnLeave", on_leave)
end
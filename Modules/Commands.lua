-- Reload the UI with a graphics restart and cache clear.

local function performFullReload()
  ReloadUI()
  ConsoleExec("gxRestart")
  ConsoleExec("clearCache")
end

-- Create a custom tooltip for the main menu.

local customTooltipFrame = CreateFrame("GameTooltip", "CustomTooltip", UIParent, "GameTooltipTemplate")

-- Register slash commands for UI and error management.

SLASH_ERRORDISPLAY1 = "/errors"
SlashCmdList["ERRORDISPLAY"] = function()
  local errorState = GetCVar("scriptErrors")
  if errorState == "1" then
    SetCVar("scriptErrors", 0)
    print("[Error Display]: Off")
  else
    SetCVar("scriptErrors", 1)
    print("[Error Display]: On")
  end
end

SLASH_RELOADUI1 = "/ui"
SlashCmdList["RELOADUI"] = function()
  ReloadUI()
end

SLASH_GXRESTART1 = "/gx"
SlashCmdList["GXRESTART"] = function()
  ConsoleExec("gxRestart")
end

SLASH_FULLRELOAD1 = "/rl"
SlashCmdList["FULLRELOAD"] = performFullReload

-- Add a right-click reload option to the main menu button.

MainMenuMicroButton:HookScript("OnClick", function(self, mouseButton)
  if mouseButton == "RightButton" then
    ReloadUI()
  end
end)

MainMenuMicroButton:HookScript("OnEnter", function(self)
  customTooltipFrame:SetOwner(GameTooltip, "ANCHOR_NONE")
  customTooltipFrame:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -2)
  customTooltipFrame:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", 0, -2)
  customTooltipFrame:ClearLines()
  customTooltipFrame:AddLine("Right-Click: Reload UI", 1, 1, 1)
  customTooltipFrame:Show()
end)

MainMenuMicroButton:HookScript("OnLeave", function()
  customTooltipFrame:Hide()
end)
-- Update commands to manage interface and error display so that we streamline actions

-- Full reload helper with graphics restart and cache clear

local function performFullReload()
  ReloadUI()
  ConsoleExec("gxRestart")
  ConsoleExec("clearCache")
end

SLASH_BENTOPLUS_ERRORS1 = "/errors"
SlashCmdList["BENTOPLUS_ERRORS"] = function()
  local errorState = GetCVar("scriptErrors")
  if errorState == "1" then
    SetCVar("scriptErrors", 0)
  print("BentoPlus: Script errors off")
  else
    SetCVar("scriptErrors", 1)
  print("BentoPlus: Script errors on")
  end
end

SLASH_BENTOPLUS_RELOAD1 = "/ui"
SlashCmdList["BENTOPLUS_RELOAD"] = function()
  ReloadUI()
end

SLASH_BENTOPLUS_GXRESTART1 = "/gx"
SlashCmdList["BENTOPLUS_GXRESTART"] = function()
  ConsoleExec("gxRestart")
end

SLASH_BENTOPLUS_FULLRELOAD1 = "/rl"
SlashCmdList["BENTOPLUS_FULLRELOAD"] = performFullReload

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
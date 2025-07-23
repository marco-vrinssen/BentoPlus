-- Reload ui with graphics restart and cache clear
local function fullReload()
    ReloadUI()
    ConsoleExec("gxRestart")
    ConsoleExec("clearCache")
end

-- Create custom tooltip for main menu
local customTooltip = CreateFrame("GameTooltip", "CustomTooltip", UIParent, "GameTooltipTemplate")

-- Register slash commands
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
SlashCmdList["FULLRELOAD"] = fullReload

-- Add right click reload to main menu button
MainMenuMicroButton:HookScript("OnClick", function(self, mouseButton)
    if mouseButton == "RightButton" then
        ReloadUI()
    end
end)

MainMenuMicroButton:HookScript("OnEnter", function(self)
    customTooltip:SetOwner(GameTooltip, "ANCHOR_NONE")
    customTooltip:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -2)
    customTooltip:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", 0, -2)
    customTooltip:ClearLines()
    customTooltip:AddLine("Right-Click: Reload UI", 1, 1, 1)
    customTooltip:Show()
end)

MainMenuMicroButton:HookScript("OnLeave", function()
    customTooltip:Hide()
end)
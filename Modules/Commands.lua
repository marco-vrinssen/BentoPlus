

-- Perform a full UI reload, graphics restart, and cache clear

local function performFullUiReloadAndCacheClear()
    ReloadUI()
    ConsoleExec("gxRestart")
    ConsoleExec("clearCache")
end



-- Create a custom tooltip for the main menu micro button

local mainMenuCustomTooltipFrame = CreateFrame("GameTooltip", "CustomTooltip", UIParent, "GameTooltipTemplate")



-- Register slash commands for error display, UI reload, graphics restart, and full reload

SLASH_ERRORDISPLAY1 = "/errors"
SlashCmdList["ERRORDISPLAY"] = function()
    local scriptErrorsCVarState = GetCVar("scriptErrors")
    if scriptErrorsCVarState == "1" then
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
SlashCmdList["FULLRELOAD"] = performFullUiReloadAndCacheClear



-- Add right-click reload and tooltip to the main menu micro button

MainMenuMicroButton:HookScript("OnClick", function(self, mouseButtonString)
    if mouseButtonString == "RightButton" then
        ReloadUI()
    end
end)

MainMenuMicroButton:HookScript("OnEnter", function(self)
    mainMenuCustomTooltipFrame:SetOwner(GameTooltip, "ANCHOR_NONE")
    mainMenuCustomTooltipFrame:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -2)
    mainMenuCustomTooltipFrame:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", 0, -2)
    mainMenuCustomTooltipFrame:ClearLines()
    mainMenuCustomTooltipFrame:AddLine("Right-Click: Reload UI", 1, 1, 1)
    mainMenuCustomTooltipFrame:Show()
end)

MainMenuMicroButton:HookScript("OnLeave", function()
    mainMenuCustomTooltipFrame:Hide()
end)
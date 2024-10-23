-- Function to toggle Lua errors on or off
local function ToggleLuaErrors()
    local currentSetting = GetCVar("scriptErrors")
    if currentSetting == "1" then
        SetCVar("scriptErrors", 0)
        print("LUA Errors Off")
    else
        SetCVar("scriptErrors", 1)
        print("LUA Errors On")
    end
end

SLASH_TOGGLELUA1 = "/lua"
SlashCmdList["TOGGLELUA"] = ToggleLuaErrors

-- Function to reload the UI
local function CustomReloadUI()
    ReloadUI()
end

SLASH_RELOADUI1 = "/ui"
SlashCmdList["RELOADUI"] = CustomReloadUI

-- Function to restart graphics
local function CustomGXRestart()
    ConsoleExec("gxRestart")
end

SLASH_GXRESTART1 = "/gx"
SlashCmdList["GXRESTART"] = CustomGXRestart

-- Function to reload the UI and restart graphics
local function CustomReloadAndRestart()
    ReloadUI()
    ConsoleExec("gxRestart")
end

SLASH_RELOADANDRESTART1 = "/rl"
SlashCmdList["RELOADANDRESTART"] = CustomReloadAndRestart

-- Function to leave the current group
SlashCmdList["LEAVEGROUP"] = function()
    C_PartyInfo.LeaveParty()
end

SLASH_LEAVEGROUP1 = "/q"

-- Function to leave the arena or battleground match
SlashCmdList["LEAVEARENA"] = function()
    if IsInInstance() then
        if C_PvP.IsBattleground() then
            C_PvP.LeaveBattlefield()
        elseif C_PvP.IsArena() then
            C_PvP.SurrenderArena()
        end
    end
end

SLASH_LEAVEARENA1 = "/gg"
-- COMMAND TO TOGGLE LUA ERRORS

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




-- COMMAND TO RELOAD THE UI

local function CustomReloadUI()
    ReloadUI()
end

SLASH_RELOADUI1 = "/ui"
SlashCmdList["RELOADUI"] = CustomReloadUI




-- COMMAND TO RESTART GRAPHICS

local function CustomGXRestart()
    ConsoleExec("gxRestart")
end

SLASH_GXRESTART1 = "/gx"
SlashCmdList["GXRESTART"] = CustomGXRestart




-- COMMAND TO RELOAD AND RESTART GRAPHICS

local function CustomReloadAndRestart()
    ReloadUI()
    ConsoleExec("gxRestart")
end

SLASH_RELOADANDRESTART1 = "/rl"
SlashCmdList["RELOADANDRESTART"] = CustomReloadAndRestart




-- ADD COMMAND TO LEAVE GROUP

SlashCmdList["LEAVEGROUP"] = function()
    C_PartyInfo.LeaveParty()
end

SLASH_LEAVEGROUP1 = "/q"
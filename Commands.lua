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




-- COMMAND TO SURRENDER IN ARENA

SlashCmdList["GGFORFEIT"] = function()
    if IsInInstance() and select(2, GetInstanceInfo()) == "arena" then
        LeaveBattlefield()
    end
end

SLASH_GGFORFEIT1 = "/gg"




-- ADD COMMAND TO LEAVE GROUP

SlashCmdList["LEAVEGROUP"] = function()
    if IsInGroup() then
        C_PartyInfo.LeaveParty()
    end
end

SLASH_LEAVEGROUP = "/q"
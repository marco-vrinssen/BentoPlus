-- DISABLE SCREEN EFFECTS AND INCREASE MAXIMUM CAMERA DISTANCE

local function SetupCVar()
    SetCVar("ffxGlow", 0)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxNether", 0)

    SetCVar("cameraDistanceMaxZoomFactor", 2.4)

    SetCVar("floatingCombatTextCombatHealing", 0)
    SetCVar("floatingCombatTextCombatDamage", 0)

    SetCVar("nameplateMotion", 1)
    SetCVar("nameplateMotionSpeed", 0.05)
    SetCVar("nameplateOverlapV", 0.5)

    SetCVar("autoLootRate", 0.1)
end

local CVarEvents = CreateFrame("Frame")
CVarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
CVarEvents:SetScript("OnEvent", SetupCVar)




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
    if IsInGroup() then
        C_PartyInfo.LeaveParty()
    end
end

SLASH_LEAVEGROUP = "/q"
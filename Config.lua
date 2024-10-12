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

    SetCVar("mouseAcceleration", -1)

    SetCVar("autoLootRate", 0.001)
end

local CVarEvents = CreateFrame("Frame")
CVarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
CVarEvents:SetScript("OnEvent", SetupCVar)

-- Update the TAB key binding based on instance and PvP context

local function updateTabKeyBindingForContext()
    local isPlayerInInstance, instanceTypeString = IsInInstance()
    local zonePvpTypeString = C_PvP.GetZonePVPInfo()

    local tabKeyBindingString = "TAB"
    local currentBindingSetIndex = GetCurrentBindingSet()

    if InCombatLockdown() or (currentBindingSetIndex ~= 1 and currentBindingSetIndex ~= 2) then
        return
    end

    local currentTabTargetActionString = GetBindingAction(tabKeyBindingString)
    local desiredTabTargetActionString

    if instanceTypeString == "arena" or instanceTypeString == "pvp" or zonePvpTypeString == "combat" then
        desiredTabTargetActionString = "TARGETNEARESTENEMYPLAYER"
    else
        desiredTabTargetActionString = "TARGETNEARESTENEMY"
    end

    if currentTabTargetActionString ~= desiredTabTargetActionString then
        SetBinding(tabKeyBindingString, desiredTabTargetActionString)
        SaveBindings(currentBindingSetIndex)
        if desiredTabTargetActionString == "TARGETNEARESTENEMYPLAYER" then
            print("PvP Tab")
        else
            print("PvE Tab")
        end
    end
end

-- Register events to update TAB key binding dynamically

local tabKeyBindingEventFrame = CreateFrame("Frame")
tabKeyBindingEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
tabKeyBindingEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
tabKeyBindingEventFrame:SetScript("OnEvent", updateTabKeyBindingForContext)








-- Release ghost automatically in PvP or combat zones if no self-resurrect options are available

local function autoReleaseGhostIfEligible()
    if C_DeathInfo.GetSelfResurrectOptions() and #C_DeathInfo.GetSelfResurrectOptions() > 0 then
        return
    end

    local isPlayerInInstance, instanceTypeString = IsInInstance()
    local zonePvpTypeString = C_PvP.GetZonePVPInfo()

    if (instanceTypeString == "pvp" or zonePvpTypeString == "combat") then
        C_Timer.After(0.5, function()
            local deathPopupDialogFrame = StaticPopup_FindVisible("DEATH")
            if deathPopupDialogFrame and deathPopupDialogFrame.button1 and deathPopupDialogFrame.button1:IsEnabled() then
                deathPopupDialogFrame.button1:Click()
            end
        end)
    end
end



-- Create ghostReleaseEventFrame to manage automatic ghost release events

local ghostReleaseEventFrame = CreateFrame("Frame")
ghostReleaseEventFrame:RegisterEvent("PLAYER_DEAD")
ghostReleaseEventFrame:SetScript("OnEvent", autoReleaseGhostIfEligible)
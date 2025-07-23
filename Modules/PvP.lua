-- Update tab targeting for pvp context
local function updateTabTargeting()
    local inInstance, instanceType = IsInInstance()
    local zonePvpType = C_PvP.GetZonePVPInfo()
    
    local TAB_KEY = "TAB"
    local bindingSet = GetCurrentBindingSet()
    
    if InCombatLockdown() or (bindingSet ~= 1 and bindingSet ~= 2) then
        return
    end
    
    local currentAction = GetBindingAction(TAB_KEY)
    local targetAction
    
    if instanceType == "arena" or instanceType == "pvp" or zonePvpType == "combat" then
        targetAction = "TARGETNEARESTENEMYPLAYER"
    else
        targetAction = "TARGETNEARESTENEMY"
    end
    
    if currentAction ~= targetAction then
        SetBinding(TAB_KEY, targetAction)
        SaveBindings(bindingSet)
        if targetAction == "TARGETNEARESTENEMYPLAYER" then
            print("PvP Tab")
        else
            print("PvE Tab")
        end
    end
end

-- Register tab targeting events
local tabFrame = CreateFrame("Frame")
tabFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
tabFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
tabFrame:SetScript("OnEvent", updateTabTargeting)

-- Release ghost in pvp zones when no resurrect options exist
local function autoReleaseGhost()
    if C_DeathInfo.GetSelfResurrectOptions() and #C_DeathInfo.GetSelfResurrectOptions() > 0 then
        return
    end
    
    local inInstance, instanceType = IsInInstance()
    local zonePvpType = C_PvP.GetZonePVPInfo()
    
    if instanceType == "pvp" or zonePvpType == "combat" then
        C_Timer.After(0.5, function()
            local deathDialog = StaticPopup_FindVisible("DEATH")
            if deathDialog and deathDialog.button1 and deathDialog.button1:IsEnabled() then
                deathDialog.button1:Click()
            end
        end)
    end
end

-- Register ghost release events
local ghostFrame = CreateFrame("Frame")
ghostFrame:RegisterEvent("PLAYER_DEAD")
ghostFrame:SetScript("OnEvent", autoReleaseGhost)
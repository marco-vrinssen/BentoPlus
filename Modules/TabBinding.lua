local function updateTabBinding()
    local currentInstance, instanceContentType = IsInInstance()
    local zonePvpInfo = C_PvP.GetZonePVPInfo()
    
    local tabKeyBinding = "TAB"
    local activeBindingSet = GetCurrentBindingSet()

    if InCombatLockdown() or (activeBindingSet ~= 1 and activeBindingSet ~= 2) then
        return
    end

    local existingTargetAction = GetBindingAction(tabKeyBinding)
    local desiredTargetAction

    if instanceContentType == "arena" or instanceContentType == "pvp" or zonePvpInfo == "combat" then
        desiredTargetAction = "TARGETNEARESTENEMYPLAYER"
    else
        desiredTargetAction = "TARGETNEARESTENEMY"
    end

    if existingTargetAction ~= desiredTargetAction then
        SetBinding(tabKeyBinding, desiredTargetAction)
        SaveBindings(activeBindingSet)
        if desiredTargetAction == "TARGETNEARESTENEMYPLAYER" then
            print("PvP Tab")
        else
            print("PvE Tab")
        end
    end
end

-- Configure tab key dynamic binding system

local tabBindingFrame = CreateFrame("Frame")
tabBindingFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
tabBindingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
tabBindingFrame:SetScript("OnEvent", updateTabBinding)
-- Rebind Tab key based on the player's environment (PvP or PvE

local function rebindTabKey()
    local inInstance, instanceType = IsInInstance()
    local pvpType = C_PvP.GetZonePVPInfo()
    
    local targetKey = "TAB"
    local bindSet = GetCurrentBindingSet()

    if InCombatLockdown() or (bindSet ~= 1 and bindSet ~= 2) then
        return
    end

    local currentBinding = GetBindingAction(targetKey)
    local newBinding

    if instanceType == "arena" or instanceType == "pvp" or pvpType == "combat" then
        newBinding = "TARGETNEARESTENEMYPLAYER"
    else
        newBinding = "TARGETNEARESTENEMY"
    end

    if currentBinding ~= newBinding then
        SetBinding(targetKey, newBinding)
        SaveBindings(bindSet)
        if newBinding == "TARGETNEARESTENEMYPLAYER" then
            print("PvP Tab")
        else
            print("PvE Tab")
        end
    end
end

local tabBindEvents = CreateFrame("Frame")
tabBindEvents:RegisterEvent("ZONE_CHANGED_NEW_AREA")
tabBindEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
tabBindEvents:SetScript("OnEvent", rebindTabKey)


-- Display the time remaining in the PvP queue dialog

local timeLeft = -1

local queueTimer = PVPReadyDialog:CreateFontString(nil, "ARTWORK")
queueTimer:SetFontObject(GameFontNormal)
queueTimer:SetFont(GameFontNormal:GetFont(), 32, "OUTLINE")
queueTimer:SetTextColor(1, 1, 1)
queueTimer:SetPoint("TOP", PVPReadyDialog, "BOTTOM", 0, -16)

local function updatePvPTimer(self, elapsed)
    timeLeft = timeLeft - elapsed
    if timeLeft > 0 then
        queueTimer:SetText(tostring(floor(timeLeft + 0.5)))
    else
        queueTimer:Hide()
        self:SetScript("OnUpdate", nil)
    end
end

hooksecurefunc("PVPReadyDialog_Display", function(self, id)
    timeLeft = GetBattlefieldPortExpiration(id)
    if timeLeft and timeLeft > 0 then
        PVPReadyDialog:SetScript("OnUpdate", updatePvPTimer)
        queueTimer:Show()
    else
        queueTimer:Hide()
        PVPReadyDialog:SetScript("OnUpdate", nil)
    end
end)

PVPReadyDialog:HookScript("OnHide", function()
    queueTimer:Hide()
    PVPReadyDialog:SetScript("OnUpdate", nil)
end)


-- Automatically release the ghost in PvP zones

local function AutoReleaseGhost()
    if C_DeathInfo.GetSelfResurrectOptions() and #C_DeathInfo.GetSelfResurrectOptions() > 0 then
        return
    end

    local inInstance, instanceType = IsInInstance()
    local pvpType = C_PvP.GetZonePVPInfo()

    if (instanceType == "pvp" or pvpType == "combat") then
        C_Timer.After(0.5, function()
            local deathDialog = StaticPopup_FindVisible("DEATH")
            if deathDialog and deathDialog.button1 and deathDialog.button1:IsEnabled() then
                deathDialog.button1:Click()
            end
        end)
    end
end

local ReleaseEvents = CreateFrame("Frame")
ReleaseEvents:RegisterEvent("PLAYER_DEAD")
ReleaseEvents:SetScript("OnEvent", AutoReleaseGhost)
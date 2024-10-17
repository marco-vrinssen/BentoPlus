-- AUTO REBIND TAB KEY FOR PVP AND PVE

local function RebindTabKey()
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

local TabBindEvents = CreateFrame("Frame")
TabBindEvents:RegisterEvent("ZONE_CHANGED_NEW_AREA")
TabBindEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TabBindEvents:SetScript("OnEvent", RebindTabKey)




-- PVP QUEUE TIMER
local TimeLeft = -1

local QueueTimer = PVPReadyDialog:CreateFontString(nil, "ARTWORK")
QueueTimer:SetFontObject(GameFontNormal)
QueueTimer:SetFont(GameFontNormal:GetFont(), 24)
QueueTimer:SetTextColor(1, 1, 1)
QueueTimer:SetPoint("TOP", PVPReadyDialog, "BOTTOM", 0, -8)

local function UpdatePvPTimer(self, elapsed)
    TimeLeft = TimeLeft - elapsed
    if TimeLeft > 0 then
        QueueTimer:SetText(tostring(floor(TimeLeft + 0.5)))
    else
        QueueTimer:Hide()
        self:SetScript("OnUpdate", nil)
    end
end

hooksecurefunc("PVPReadyDialog_Display", function(self, id)
    TimeLeft = GetBattlefieldPortExpiration(id)
    if TimeLeft and TimeLeft > 0 then
        PVPReadyDialog:SetScript("OnUpdate", UpdatePvPTimer)
        QueueTimer:Show()
    else
        QueueTimer:Hide()
        PVPReadyDialog:SetScript("OnUpdate", nil)
    end
end)

PVPReadyDialog:HookScript("OnHide", function()
    QueueTimer:Hide()
    PVPReadyDialog:SetScript("OnUpdate", nil)
end)




-- AUTO RELEASE GHOST IN PVP ZONES

local function AutoReleaseGhost()
    if C_DeathInfo.GetSelfResurrectOptions() and #C_DeathInfo.GetSelfResurrectOptions() > 0 then
        return
    end

    local inInstance, instanceType = IsInInstance()
    local pvpType = C_PvP.GetZonePVPInfo()

    if (instanceType == "pvp" or pvpType == "combat") then
        C_Timer.After(0.5, function()
            local deathDialog = StaticPopup_FindVisible("DEATH")
            if deathDialog and deathDialog.button1:IsEnabled() then
                deathDialog.button1:Click()
            end
        end)
    end
end

local ReleaseEvents = CreateFrame("Frame")
ReleaseEvents:RegisterEvent("PLAYER_DEAD")
ReleaseEvents:SetScript("OnEvent", AutoReleaseGhost)




-- COMMAND TO SURRENDER OR LEAVE IN ARENA

local function CanSurrenderArena()
    return C_PvP and C_PvP.CanSurrenderArena and C_PvP.CanSurrenderArena()
end

local function SurrenderArena()
    if C_PvP and C_PvP.SurrenderArena then
        C_PvP.SurrenderArena()
        return true
    end
    return false
end

SlashCmdList["GGFORFEIT"] = function()
    if IsInInstance() and select(2, GetInstanceInfo()) == "arena" then
        if CanSurrenderArena() then
            if SurrenderArena() then
                print("Surrendering arena match...")
            else
                print("Failed to surrender. Leaving battlefield...")
                LeaveBattlefield()
            end
        else
            print("Cannot surrender. Leaving battlefield...")
            LeaveBattlefield()
        end
    else
        print("You are not in an arena match.")
    end
end

SLASH_GGFORFEIT1 = "/gg"


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
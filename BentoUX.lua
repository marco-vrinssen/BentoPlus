local function DisableScreenEffectsAndSetCameraDistance()
    SetCVar("ffxGlow", 0)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxNether", 0)
    SetCVar("cameraDistanceMaxZoomFactor", 2.4)
end

local CVarEvents = CreateFrame("Frame")
CVarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
CVarEvents:SetScript("OnEvent", DisableScreenEffectsAndSetCameraDistance)




-- HIDE TARGET FRAME AND FOCUS FRAME AURAS, ADJUST TARGET FRAME SPELL BAR

local function HideTargetFrameAuras()
    TargetFrame.maxBuffs = 0
    TargetFrame.maxDebuffs = 0
    MAX_TARGET_BUFFS = 0
    MAX_TARGET_DEBUFFS = 0

    if TargetFrame_UpdateAuras then
        TargetFrame_UpdateAuras(TargetFrame)
    end
end

local function HideFocusFrameAuras()
    if FocusFrame:IsShown() then
        FocusFrame.maxBuffs = 0
        FocusFrame.maxDebuffs = 0
        MAX_FOCUS_BUFFS = 0
        MAX_FOCUS_DEBUFFS = 0

        if FocusFrame_UpdateAuras then
            FocusFrame_UpdateAuras(FocusFrame)
        end
    end
end

local UnitFrameEvents = CreateFrame("Frame")
UnitFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
UnitFrameEvents:SetScript("OnEvent", function()
    HideTargetFrameAuras()
    HideFocusFrameAuras()
end)




-- HIDE NAMEPLATE AND PLAYER AURAS

local function HideNameplateAuras(unitId)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
    if not nameplate or nameplate.UnitFrame:IsForbidden() then
        return
    end
    local unitFrame = nameplate.UnitFrame
    unitFrame.BuffFrame:ClearAllPoints()
    unitFrame.BuffFrame:SetAlpha(0)
end

local function HidePlayerAuras(unitId)
    if unitId == "player" then
        local resourceFrame = PersonalResourceDisplayFrame
        if resourceFrame and not resourceFrame:IsForbidden() then
            resourceFrame.BuffFrame:ClearAllPoints()
            resourceFrame.BuffFrame:SetAlpha(0)
        end
    end
end

local NameplateAuraEvents = CreateFrame("Frame")
NameplateAuraEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NameplateAuraEvents:RegisterEvent("UNIT_AURA")
NameplateAuraEvents:SetScript("OnEvent", function(_, event, unitId)
    HideNameplateAuras(unitId)
    HidePlayerAuras(unitId)
end)




-- HIDE ACHIEVEMENT ALERTS

local original_AddAlert = AchievementAlertSystem.AddAlert

AchievementAlertSystem.AddAlert = function(self, achievementID, name, points, alreadyEarned, icon, rewardText)
    if hiddenAchievements[achievementID] then
        MuteSoundFile(569143)
        C_Timer.After(0.5, function() UnmuteSoundFile(569143) end)
        return
    end
    return original_AddAlert(self, achievementID, name, points, alreadyEarned, icon, rewardText)
end

local AchievementEvents = CreateFrame("Frame")
AchievementEvents:RegisterEvent("ACHIEVEMENT_EARNED")
AchievementEvents:SetScript("OnEvent", function(self, event, achievementID)
    if hiddenAchievements[achievementID] then return end
end)




-- HIDE TALKING HEAD FRAME

hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    self:Hide()
end)




-- AUTOMATICALLY HANDLE LOOT CONFIRMATIONS

local function ConfirmLootDialog(self, event, arg1, arg2, ...)
    if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
        ConfirmLootRoll(arg1, arg2)
        StaticPopup_Hide("CONFIRM_LOOT_ROLL")
    elseif event == "LOOT_BIND_CONFIRM" then
        ConfirmLootSlot(arg1, arg2)
        StaticPopup_Hide("LOOT_BIND", ...)
    elseif event == "MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL" then
        SellCursorItem()
    elseif event == "MAIL_LOCK_SEND_ITEMS" then
        RespondMailLockSendItem(arg1, true)
    end
end

local LootDialogEvents = CreateFrame("Frame")
LootDialogEvents:SetScript("OnEvent", ConfirmLootDialog)
LootDialogEvents:RegisterEvent("CONFIRM_LOOT_ROLL")
LootDialogEvents:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
LootDialogEvents:RegisterEvent("LOOT_BIND_CONFIRM")
LootDialogEvents:RegisterEvent("MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
LootDialogEvents:RegisterEvent("MAIL_LOCK_SEND_ITEMS")




-- AUTO SELL GREY ITEMS AND REPAIR GEAR

local function AutoSellRepair()
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink then
                local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemLink)
                if itemRarity == 0 and itemSellPrice > 0 then
                    C_Container.UseContainerItem(bag, slot)
                    PickupMerchantItem()
                end
            end
        end
    end

    if CanMerchantRepair() then
        local repairCost, canRepair = GetRepairAllCost()
        if canRepair and repairCost > 0 then
            if IsInGuild() and CanGuildBankRepair() then
                local availableFunds = min(GetGuildBankWithdrawMoney(), GetGuildBankMoney())
                if availableFunds >= repairCost then
                    RepairAllItems(true)
                end
            end
            if repairCost <= GetMoney() then
                RepairAllItems(false)
            end
        end
    end
end

local MerchantEvents = CreateFrame("Frame")
MerchantEvents:SetScript("OnEvent", AutoSellRepair)
MerchantEvents:RegisterEvent("MERCHANT_SHOW")




-- HIDE STATUS TRACKING BARS

local function HideStatusTrackingBars()
    if MainStatusTrackingBarContainer then
        MainStatusTrackingBarContainer:Hide()
        MainStatusTrackingBarContainer:SetScript("OnShow", MainStatusTrackingBarContainer.Hide)
    end

    if SecondaryStatusTrackingBarContainer then
        SecondaryStatusTrackingBarContainer:Hide()
        SecondaryStatusTrackingBarContainer:SetScript("OnShow", SecondaryStatusTrackingBarContainer.Hide)
    end
end

local StatusTrackingEvents = CreateFrame("Frame")
StatusTrackingEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
StatusTrackingEvents:SetScript("OnEvent", function(self, event)
    C_Timer.After(1, HideStatusTrackingBars)
end)




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




-- AUTO RELEASE GHOST IN PVP ZONES

local function AutoGhostRelease()
    if C_DeathInfo.GetSelfResurrectOptions() and #C_DeathInfo.GetSelfResurrectOptions() > 0 then
        return
    end

    local inInstance, instanceType = IsInInstance()
    local pvpType = C_PvP.GetZonePVPInfo()

    if instanceType == "arena" or instanceType == "pvp" or pvpType == "combat" then
        C_Timer.After(0, function() StaticPopupDialogs["DEATH"].button1:Click() end)
    end
end

local GhostReleaseEvents = CreateFrame("Frame")
GhostReleaseEvents:RegisterEvent("PLAYER_DEAD")
GhostReleaseEvents:SetScript("OnEvent", AutoGhostRelease)
-- DISABLE SCREEN EFFECTS AND INCREASE MAXIMUM CAMERA DISTANCE

local function DisableScreenEffectsAndSetCameraDistance()
    SetCVar("ffxGlow", 0)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxNether", 0)
    SetCVar("cameraDistanceMaxZoomFactor", 2.6)
end

local CVarEvents = CreateFrame("Frame")
CVarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
CVarEvents:SetScript("OnEvent", DisableScreenEffectsAndSetCameraDistance)




-- COMMAND TO TOGGLE LUA ERRORS DISPLAY

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




-- FASTER AUTO LOOTING

local EPOCH = 0
local DELAY = 0.1

local function AutoLoot()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        if (GetTime() - EPOCH) >= DELAY then
            for i = GetNumLootItems(), 1, -1 do
                LootSlot(i)
            end
            EPOCH = GetTime()
        end
    end
end

local FastLootEvents = CreateFrame("Frame")
FastLootEvents:RegisterEvent("LOOT_READY")
FastLootEvents:SetScript("OnEvent", AutoLoot)




-- HIDE CHAT BUTTONS WHEN PLAYER ENTERS WORLD

local function HideChatButtons()
    QuickJoinToastButton:Hide()
    ChatFrameChannelButton:Hide()
    ChatFrameToggleVoiceDeafenButton:Hide()
    ChatFrameToggleVoiceMuteButton:Hide()
    ChatFrameMenuButton:Hide()

    for i = 1, 20 do
        local chatFrameButtonFrame = _G["ChatFrame" .. i .. "ButtonFrame"]
        if chatFrameButtonFrame then
            chatFrameButtonFrame:Hide()
            chatFrameButtonFrame:SetScript("OnShow", chatFrameButtonFrame.Hide)
        end
    end
end

local ChatButtonEvents = CreateFrame("Frame")
ChatButtonEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ChatButtonEvents:RegisterEvent("CHAT_MSG_WHISPER")
ChatButtonEvents:SetScript("OnEvent", HideChatButtons)




-- HIDE XP AND STATUS BARS

local function HideStatusTrackingBars()
    local playerLevel = UnitLevel("player")
    local maxLevel = GetMaxPlayerLevel()

    if playerLevel < maxLevel then
        if MainStatusTrackingBarContainer then
            MainStatusTrackingBarContainer:Show()
            MainStatusTrackingBarContainer:SetScript("OnShow", nil)
        end
    else
        if MainStatusTrackingBarContainer then
            MainStatusTrackingBarContainer:Hide()
            MainStatusTrackingBarContainer:SetScript("OnShow", MainStatusTrackingBarContainer.Hide)
        end
    end

    if SecondaryStatusTrackingBarContainer then
        SecondaryStatusTrackingBarContainer:Hide()
        SecondaryStatusTrackingBarContainer:SetScript("OnShow", SecondaryStatusTrackingBarContainer.Hide)
    end
end

local StatusTrackingEvents = CreateFrame("Frame")
StatusTrackingEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
StatusTrackingEvents:RegisterEvent("PLAYER_LEVEL_UP")
StatusTrackingEvents:SetScript("OnEvent", function(self, event)
    C_Timer.After(1, HideStatusTrackingBars)
end)




-- HIDE TALKING HEAD FRAME

hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    self:Hide()
end)




-- HIDE VEHICLE SEAT INDICATOR

local VehicleSeatIndicator = _G["VehicleSeatIndicator"]
VehicleSeatIndicator:Hide()
VehicleSeatIndicator:SetScript("OnShow", VehicleSeatIndicator.Hide)




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




-- HIDE AND MUTE ALERTS

local function MuteAndHideAlerts()
    MuteSoundFile(569143)

    hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
        AlertFrame:UnregisterEvent(event)
    end)
    AlertFrame:UnregisterAllEvents()
end

MuteAndHideAlerts()




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
        C_Timer.After(0, function()
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





-- AUTOMATICALLY HANDLE LOOT CONFIRMATIONS

local function ConfirmLootDialog(self, event, arg1, arg2, ...)
    print("Event triggered:", event, arg1, arg2, ...)
    if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
        ConfirmLootRoll(arg1, arg2)
        StaticPopup_Hide("CONFIRM_LOOT_ROLL")
    elseif event == "LOOT_BIND_CONFIRM" then
        ConfirmLootSlot(arg1)
        StaticPopup_Hide("LOOT_BIND", ...)
    elseif event == "MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL" then
        SellCursorItem()
    elseif event == "MAIL_LOCK_SEND_ITEMS" then
        RespondMailLockSendItem(arg1, true)
    elseif event == "EQUIP_BIND_CONFIRM" then
        EquipPendingItem(arg1)
        StaticPopup_Hide("EQUIP_BIND", ...)
    end
end

local LootDialogEvents = CreateFrame("Frame")
LootDialogEvents:SetScript("OnEvent", ConfirmLootDialog)
LootDialogEvents:RegisterEvent("CONFIRM_LOOT_ROLL")
LootDialogEvents:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
LootDialogEvents:RegisterEvent("LOOT_BIND_CONFIRM")
LootDialogEvents:RegisterEvent("MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
LootDialogEvents:RegisterEvent("MAIL_LOCK_SEND_ITEMS")
LootDialogEvents:RegisterEvent("EQUIP_BIND_CONFIRM")
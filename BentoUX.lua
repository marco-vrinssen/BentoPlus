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

    SetCVar("rawMouseEnable", 0)
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




-- COMMAND TO SURRENDER IN ARENA

SlashCmdList["GGFORFEIT"] = function()
    if IsInInstance() and select(2, GetInstanceInfo()) == "arena" then
        LeaveBattlefield()
    end
end

SLASH_GGFORFEIT1 = "/gg"




SlashCmdList["GGQUIT"] = function()
    if IsInGroup() or IsInRaid() then
        LeaveParty()
    end
end

SLASH_GGQUIT1 = "/q"




-- HIDE NATIVE ACTION BUTTON GLOWS

hooksecurefunc("ActionButton_ShowOverlayGlow", function(actionButton)
    if actionButton.SpellActivationAlert then
        actionButton.SpellActivationAlert:Hide()
    elseif actionButton.overlay then
        actionButton.overlay:Hide()
    end
end)




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




-- HIDE RAID FRAME AURAS
local function HideBuffsForUnit(unitPrefix, unitCount)
    for i = 1, unitCount do
        local unitFrame = _G[unitPrefix .. i]
        if unitFrame then
            for j = 1, 32 do
                local buffIcon = _G[unitPrefix .. i .. "Buff" .. j .. "Icon"]
                local buffCooldown = _G[unitPrefix .. i .. "Buff" .. j .. "Cooldown"]
                if buffIcon then
                    buffIcon:Hide()
                end
                if buffCooldown then
                    buffCooldown:Hide()
                end
            end
        end
    end
end

local function HideBuffs()
    HideBuffsForUnit("CompactPartyFrameMember", 40)
    HideBuffsForUnit("CompactRaidFrame", 40)
end

local RaidFrameEvents = CreateFrame("Frame")
RaidFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
RaidFrameEvents:RegisterEvent("GROUP_ROSTER_UPDATE")
RaidFrameEvents:SetScript("OnEvent", HideBuffs)

hooksecurefunc("CompactUnitFrame_UpdateAuras", HideBuffs)




-- SPEED UP AUTO LOOTING

local function AutoLoot()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        for i = GetNumLootItems(), 1, -1 do
            LootSlot(i)
        end
    end
end

local FastLootEvents = CreateFrame("Frame")
FastLootEvents:RegisterEvent("LOOT_READY")
FastLootEvents:SetScript("OnEvent", AutoLoot)




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




-- OPEN WARBAND BANK WHEN OPENING BANK FRAME

local function OpenWarbandBank()
    BankFrameTab3:Click()
end

local BankFrameEvents = CreateFrame("Frame")
BankFrameEvents:RegisterEvent("BANKFRAME_OPENED")
BankFrameEvents:SetScript("OnEvent", function()
    C_Timer.After(0, OpenWarbandBank)
end)




-- HIDE PVP BADGES ON TARGET AND PLAYER FRAMES

local function HidePvPBadges()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentContextual:Hide()
end

local PvPBadgeEvents = CreateFrame("Frame")
PvPBadgeEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PvPBadgeEvents:SetScript("OnEvent", HidePvPBadges)




-- HIDE AND MUTE ALERTS

local function MuteAndHideAlerts()
    MuteSoundFile(569143)

    hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
        AlertFrame:UnregisterEvent(event)
    end)
    AlertFrame:UnregisterAllEvents()
end

MuteAndHideAlerts()




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
        C_Timer.After(0.25, function()
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
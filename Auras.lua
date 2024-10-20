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
                local buffCount = _G[unitPrefix .. i .. "Buff" .. j .. "Count"]
                if buffIcon then
                    buffIcon:Hide()
                end
                if buffCooldown then
                    buffCooldown:Hide()
                end
                if buffCount then
                    buffCount:Hide()
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
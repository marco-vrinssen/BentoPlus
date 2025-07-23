-- Initialize database for aura state
local AURA_STATE = "RaidFrameAuras"

if not BentoDB then BentoDB = {} end
if BentoDB[AURA_STATE] == nil then BentoDB[AURA_STATE] = false end

-- Hide raid frame auras when disabled
local function hideAuras(frame)
    if not frame or not frame:IsForbidden() then
        if not BentoDB[AURA_STATE] then
            if CompactUnitFrame_HideAllBuffs then CompactUnitFrame_HideAllBuffs(frame) end
            if CompactUnitFrame_HideAllDebuffs then CompactUnitFrame_HideAllDebuffs(frame) end
        end
    end
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", hideAuras)

-- Toggle aura visibility and refresh frames
local function toggleAuras()
    BentoDB[AURA_STATE] = not BentoDB[AURA_STATE]
    if BentoDB[AURA_STATE] then
        print("|cff00ff00BentoPlus: Raid frame auras are now |cffffff00VISIBLE|r.")
    else
        print("|cff00ff00BentoPlus: Raid frame auras are now |cffff0000HIDDEN|r.")
    end
    if CompactRaidFrameContainer and CompactRaidFrameContainer.memberUnitFrames then
        for frame in pairs(CompactRaidFrameContainer.memberUnitFrames) do
            if frame.UpdateAuras then frame:UpdateAuras() end
        end
    end
end

-- Register slash command
SLASH_BENTOPLUS_RAIDFRAMEAURAS1 = "/raidframeauras"
SlashCmdList["BENTOPLUS_RAIDFRAMEAURAS"] = toggleAuras

-- Show login notification when auras hidden
local loginFrame = CreateFrame("Frame")
loginFrame:RegisterEvent("PLAYER_LOGIN")
loginFrame:SetScript("OnEvent", function()
    if not BentoDB[AURA_STATE] then
        print("|cff00ff00BentoPlus: Raid frame auras are |cffff0000HIDDEN|r by default. Use /raidframeauras to toggle.")
    end
end)
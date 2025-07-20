-- Raid frame aura visibility state
local state = "RaidFrameAuras"

-- Database initialization
if not BentoDB then BentoDB = {} end
if BentoDB[state] == nil then BentoDB[state] = false end

-- Hide auras when disabled
local function hide(frame)
    if not frame or not frame:IsForbidden() then
        if not BentoDB[state] then
            if CompactUnitFrame_HideAllBuffs then CompactUnitFrame_HideAllBuffs(frame) end
            if CompactUnitFrame_HideAllDebuffs then CompactUnitFrame_HideAllDebuffs(frame) end
        end
    end
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", hide)

-- Toggle aura visibility
local function toggle()
    BentoDB[state] = not BentoDB[state]
    if BentoDB[state] then
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

-- Command registration
SLASH_BENTOPLUS_RAIDFRAMEAURAS1 = "/raidframeauras"
SlashCmdList["BENTOPLUS_RAIDFRAMEAURAS"] = toggle

-- Login notification
local login = CreateFrame("Frame")
login:RegisterEvent("PLAYER_LOGIN")
login:SetScript("OnEvent", function()
    if not BentoDB[state] then
        print("|cff00ff00BentoPlus: Raid frame auras are |cffff0000HIDDEN|r by default. Use /raidframeauras to toggle.")
    end
end)
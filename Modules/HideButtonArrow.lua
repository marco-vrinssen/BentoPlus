
-- Hide combat rotation assistant arrows on all action buttons

local function hideCombatRotationAssistantArrowsOnButtons()
    local actionButtonNamePrefixList = {
        "ActionButton",
        "MultiBarBottomLeftButton",
        "MultiBarBottomRightButton",
        "MultiBarRightButton",
        "MultiBarLeftButton",
        "MultiBar5Button",
        "MultiBar6Button",
        "MultiBar7Button"
    }

    for _, actionButtonPrefix in ipairs(actionButtonNamePrefixList) do
        for actionButtonSlotIndex = 1, 12 do
            local actionButtonFrame = _G[actionButtonPrefix .. actionButtonSlotIndex]
            if actionButtonFrame and actionButtonFrame.AssistedCombatRotationFrame then
                local assistantRotationFrame = actionButtonFrame.AssistedCombatRotationFrame
                if assistantRotationFrame.InactiveTexture then
                    assistantRotationFrame.InactiveTexture:SetAlpha(0)
                end
                if assistantRotationFrame.ActiveFrame then
                    assistantRotationFrame.ActiveFrame:SetAlpha(0)
                end
            end
        end
    end
end


-- Register events to hide combat rotation assistant arrows

local combatRotationArrowHiderEventFrame = CreateFrame("Frame")
local combatRotationArrowHiderEventList = {
    "PLAYER_ENTERING_WORLD",
    "PLAYER_REGEN_DISABLED",
    "UPDATE_BONUS_ACTIONBAR",
    "PLAYER_SPECIALIZATION_CHANGED",
    "PLAYER_TALENT_UPDATE",
    "ACTIVE_TALENT_GROUP_CHANGED"
}

for _, combatRotationArrowHiderEventName in ipairs(combatRotationArrowHiderEventList) do
    combatRotationArrowHiderEventFrame:RegisterEvent(combatRotationArrowHiderEventName)
end

combatRotationArrowHiderEventFrame:SetScript("OnEvent", function()
    hideCombatRotationAssistantArrowsOnButtons()
    C_Timer.After(0.5, hideCombatRotationAssistantArrowsOnButtons)
end)
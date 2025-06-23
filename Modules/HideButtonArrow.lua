-- Hide combat rotation assistant arrows on action buttons
local function hideAssistantArrows()
    local buttonNamePrefixes = {
        "ActionButton",
        "MultiBarBottomLeftButton",
        "MultiBarBottomRightButton",
        "MultiBarRightButton",
        "MultiBarLeftButton",
        "MultiBar5Button",
        "MultiBar6Button",
        "MultiBar7Button"
    }

    for _, buttonPrefix in ipairs(buttonNamePrefixes) do
        for slotNumber = 1, 12 do
            local currentButton = _G[buttonPrefix .. slotNumber]
            if currentButton and currentButton.AssistedCombatRotationFrame then
                local assistantFrame = currentButton.AssistedCombatRotationFrame
                if assistantFrame.InactiveTexture then
                    assistantFrame.InactiveTexture:SetAlpha(0)
                end
                if assistantFrame.ActiveFrame then
                    assistantFrame.ActiveFrame:SetAlpha(0)
                end
            end
        end
    end
end

local assistantEventHandler = CreateFrame("Frame")
local assistantTriggerEvents = {
    "PLAYER_ENTERING_WORLD",
    "PLAYER_REGEN_DISABLED", 
    "UPDATE_BONUS_ACTIONBAR",
    "PLAYER_SPECIALIZATION_CHANGED",
    "PLAYER_TALENT_UPDATE",
    "ACTIVE_TALENT_GROUP_CHANGED"
}

for _, triggerEvent in ipairs(assistantTriggerEvents) do
    assistantEventHandler:RegisterEvent(triggerEvent)
end

assistantEventHandler:SetScript("OnEvent", function()
    hideAssistantArrows()
    C_Timer.After(0.5, hideAssistantArrows)
end)
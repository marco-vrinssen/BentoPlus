-- Function to hide a chat element and prevent it from showing again
local function HideChatElement(chatElement)
    if chatElement then
        chatElement:Hide()
        chatElement:SetScript("OnShow", chatElement.Hide)
    end
end

-- Function to customize a chat frame, excluding the combat log
local function CustomizeChatFrame(chatFrame)
    if chatFrame:GetID() == 2 then return end

    for _, region in ipairs({chatFrame:GetRegions()}) do
        if region:IsObjectType("Texture") then
            HideChatElement(region)
        end
    end

    local childElementsToHide = {
        "ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight",
        "EditBoxHeaderSuffix", "TabUpButton", "TabDownButton",
        "TabBottomButton", "TabMinimizeButton",
        "EditBoxFocusLeft", "EditBoxFocusMid", "EditBoxFocusRight",
        "ScrollBar", "ScrollToBottomButton"
    }
    for _, elementName in ipairs(childElementsToHide) do
        local childElement = _G[chatFrame:GetName() .. elementName] or chatFrame[elementName]
        HideChatElement(childElement)
    end

    local chatTab = _G[chatFrame:GetName() .. "Tab"]
    local chatTabText = _G[chatFrame:GetName() .. "TabText"]
    if chatTab then
        for _, region in ipairs({chatTab:GetRegions()}) do
            if region:IsObjectType("Texture") then
                HideChatElement(region)
            end
        end
    end
    if chatTabText then
        chatTabText:SetFont(STANDARD_TEXT_FONT, 12)
        chatTabText:ClearAllPoints()
        chatTabText:SetPoint("LEFT", chatTab, "LEFT", 4, 0)
    end
end

-- Function to update all chat frames
local function UpdateAllChatFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        CustomizeChatFrame(_G["ChatFrame" .. i])
    end

    HideChatElement(ChatFrameMenuButton)
    HideChatElement(ChatFrameChannelButton)
    if CombatLogQuickButtonFrame_Custom then
        CombatLogQuickButtonFrame_Custom:SetAlpha(0)
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        local editBoxHeader = _G["ChatFrame" .. i .. "EditBoxHeader"]
        if editBox and editBoxHeader then
            editBoxHeader:ClearAllPoints()
            editBoxHeader:SetPoint("LEFT", editBox, "LEFT", 6, 0)
        end
    end
end

-- Function to update chat scroll behavior
local function UpdateChatScroll()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrameTab = _G["ChatFrame" .. i .. "Tab"]
        if not chatFrameTab.scrollHooked then
            chatFrameTab:HookScript("OnClick", function() _G["ChatFrame" .. i]:ScrollToBottom() end)
            chatFrameTab.scrollHooked = true
        end
    end
end

-- Create a frame to handle chat events
local chatEventsFrame = CreateFrame("Frame")
chatEventsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
chatEventsFrame:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
chatEventsFrame:RegisterEvent("CHAT_MSG_WHISPER")
chatEventsFrame:RegisterEvent("UI_SCALE_CHANGED")
chatEventsFrame:SetScript("OnEvent", function()
    UpdateAllChatFrames()
    UpdateChatScroll()
end)

-- Hook function to customize temporary chat windows
hooksecurefunc("FCF_OpenTemporaryWindow", function()
    local currentChatFrame = FCF_GetCurrentChatFrame()
    if currentChatFrame then
        CustomizeChatFrame(currentChatFrame)
        UpdateChatScroll()
    end
end)
-- Function to hide a chat element
local function HideChatElement(chatElement)
    if chatElement then
        chatElement:Hide()  -- Hide the element
        chatElement:SetScript("OnShow", chatElement.Hide)  -- Ensure it stays hidden when shown
    end
end

-- Function to customize a chat frame
local function CustomizeChatFrame(chatFrame)
    if chatFrame:GetID() == 2 then return end  -- Skip the combat log frame

    -- Hide all texture regions of the chat frame
    for _, region in ipairs({chatFrame:GetRegions()}) do
        if region:IsObjectType("Texture") then
            HideChatElement(region)
        end
    end

    -- List of child elements to hide
    local childElementsToHide = {
        "ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight",
        "EditBoxHeaderSuffix", "TabUpButton", "TabDownButton",
        "TabBottomButton", "TabMinimizeButton",
        "EditBoxFocusLeft", "EditBoxFocusMid", "EditBoxFocusRight",
        "ScrollBar", "ScrollToBottomButton"
    }
    -- Hide each child element in the list
    for _, elementName in ipairs(childElementsToHide) do
        local childElement = _G[chatFrame:GetName() .. elementName] or chatFrame[elementName]
        HideChatElement(childElement)
    end

    -- Customize the chat tab
    local chatTab = _G[chatFrame:GetName() .. "Tab"]
    local chatTabText = _G[chatFrame:GetName() .. "TabText"]
    if chatTab then
        -- Hide all texture regions of the chat tab
        for _, region in ipairs({chatTab:GetRegions()}) do
            if region:IsObjectType("Texture") then
                HideChatElement(region)
            end
        end
    end
    if chatTabText then
        chatTabText:SetFont(STANDARD_TEXT_FONT, 12)  -- Set font size
        chatTabText:ClearAllPoints()  -- Clear existing points
        chatTabText:SetPoint("LEFT", chatTab, "LEFT", 4, 0)  -- Set new position
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
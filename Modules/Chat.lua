-- Hide and reposition chat buttons and elements

local function HideChatElement(element)
    if element then
        element:Hide()
        element:SetScript("OnShow", element.Hide)
    end
end

local function HideChildElements(parentFrame, elementNames)
    for _, elementName in ipairs(elementNames) do
        local childElement = _G[parentFrame:GetName() .. elementName] or parentFrame[elementName]
        HideChatElement(childElement)
    end
end

local function HideTextureRegions(parentFrame)
    for _, region in ipairs({parentFrame:GetRegions()}) do
        if region:IsObjectType("Texture") then
            HideChatElement(region)
        end
    end
end

local function CustomizeChatTab(chatTabFrame)
    local chatTab = _G[chatTabFrame:GetName() .. "Tab"]
    local chatTabText = _G[chatTabFrame:GetName() .. "TabText"]
    
    HideTextureRegions(chatTab)
    if chatTabText then
        chatTabText:SetFont(STANDARD_TEXT_FONT, 12) -- Changed font size to 12
        chatTabText:ClearAllPoints()
        chatTabText:SetPoint("LEFT", chatTab, "LEFT", 4, 0)
    end
end

local function CustomizeChatFrame(chatFrame)
    HideTextureRegions(chatFrame)
    
    local elementsToHide = {
        "ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight",
        "EditBoxHeaderSuffix", "TabUpButton", "TabDownButton",
        "TabBottomButton", "TabMinimizeButton",
        "EditBoxFocusLeft", "EditBoxFocusMid", "EditBoxFocusRight",
        "ScrollBar", "ScrollToBottomButton"
    }
    
    HideChildElements(chatFrame, elementsToHide)
    CustomizeChatTab(chatFrame)
end

local function AlignEditBoxHeader()
    for i = 1, NUM_CHAT_WINDOWS do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        local editBoxHeader = _G["ChatFrame" .. i .. "EditBoxHeader"]
        if editBox and editBoxHeader then
            editBoxHeader:ClearAllPoints()
            editBoxHeader:SetPoint("LEFT", editBox, "LEFT", 6, 0)
        end
    end
end

local function HideCombatLog()
    if (ChatFrame2.isDocked or ChatFrame2:IsShown()) then
        FCF_Close(ChatFrame2)
    end
    ChatFrame2.isDocked = 1
end

local function UpdateAllChatFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        CustomizeChatFrame(_G["ChatFrame" .. i])
    end
    
    HideChatElement(ChatFrameMenuButton)
    HideChatElement(ChatFrameChannelButton)
    if CombatLogQuickButtonFrame_Custom then
        CombatLogQuickButtonFrame_Custom:SetAlpha(0)
    end
    
    AlignEditBoxHeader()
    HideCombatLog()
end

local function ChatScrollHook(chatFrameID)
    local chatFrameTab = _G["ChatFrame" .. chatFrameID .. "Tab"]
    if not chatFrameTab.scrollHooked then
        chatFrameTab:HookScript("OnClick", function() _G["ChatFrame" .. chatFrameID]:ScrollToBottom() end)
        chatFrameTab.scrollHooked = true
    end
end

local function UpdateChatScroll()
    for i = 1, NUM_CHAT_WINDOWS do
        ChatScrollHook(i)
    end
end

local function OnPlayerEnteringWorld()
    HideCombatLog()
end

local chatEvents = CreateFrame("Frame")
chatEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
chatEvents:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
chatEvents:RegisterEvent("CHAT_MSG_WHISPER")
chatEvents:RegisterEvent("UI_SCALE_CHANGED")
chatEvents:SetScript("OnEvent", function()
    UpdateAllChatFrames()
    UpdateChatScroll()
end)

hooksecurefunc("FCF_OpenTemporaryWindow", function()
    local currentChatFrame = FCF_GetCurrentChatFrame()
    if currentChatFrame then
        CustomizeChatFrame(currentChatFrame)
        ChatScrollHook(currentChatFrame:GetID())
        AlignEditBoxHeader()
    end
end)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", OnPlayerEnteringWorld)
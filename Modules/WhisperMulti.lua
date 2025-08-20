-- Update whisper list to send batch messages so that we reach many players

local multiWhisperName = "MultiWhisperAddon"
local whisperFrame = nil
local namesScroll = nil
local namesInput = nil
local playerNames = nil
local messagePanel = nil

-- Initialize saved message so that we persist user choice.

BentoDB = BentoDB or {}
BentoDB.multiWhisperMessage = BentoDB.multiWhisperMessage or ""

-- Create whisper frame so that we collect player names.

local function createWhisperFrame()
    if whisperFrame then
        return whisperFrame
    end
    
    whisperFrame = CreateFrame("Frame", "MultiWhisperAddonFrame", UIParent, "BasicFrameTemplateWithInset")
    whisperFrame:SetSize(500, 600)
    whisperFrame:SetPoint("CENTER")
    whisperFrame:SetMovable(true)
    whisperFrame:EnableMouse(true)
    whisperFrame:RegisterForDrag("LeftButton")
    whisperFrame:SetScript("OnDragStart", whisperFrame.StartMoving)
    whisperFrame:SetScript("OnDragStop", whisperFrame.StopMovingOrSizing)
    whisperFrame:Hide()
    
    whisperFrame.title = whisperFrame:CreateFontString(nil, "OVERLAY")
    whisperFrame.title:SetFontObject("GameFontHighlight")
    whisperFrame.title:SetPoint("LEFT", whisperFrame.TitleBg, "LEFT", 5, 0)
    whisperFrame.title:SetText("Multi Whisper")
    
    -- Add helper text so that we explain usage.
    
    whisperFrame.helperText = whisperFrame:CreateFontString(nil, "OVERLAY")
    whisperFrame.helperText:SetFontObject("GameFontNormal")
    whisperFrame.helperText:SetPoint("TOPLEFT", whisperFrame, "TOPLEFT", 15, -35)
    whisperFrame.helperText:SetText('Use "/w+" to open this list, or "/w+ MESSAGE" to send the MESSAGE to all players here')
    whisperFrame.helperText:SetTextColor(0.7, 0.7, 0.7)
    
    return whisperFrame
end

-- Parse player names so that we build a clean list.

local function parsePlayerNames(namesText)
    local names = {}
    
    for line in namesText:gmatch("[^\r\n]+") do
        local trimmedName = line:match("^%s*(.-)%s*$")
        if trimmedName and trimmedName ~= "" then
            table.insert(names, trimmedName)
        end
    end
    
    return names
end

-- Create names input so that we capture player names.

local function createNameInput(parentFrame)
    namesScroll = CreateFrame("ScrollFrame", "MultiWhisperAddonScrollFrame", parentFrame, "UIPanelScrollFrameTemplate")
    namesScroll:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 15, -60)
    namesScroll:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -35, 50)
    
    namesInput = CreateFrame("EditBox", "MultiWhisperAddonEditBox", namesScroll)
    namesInput:SetMultiLine(true)
    namesInput:SetAutoFocus(false)
    namesInput:SetFontObject("ChatFontNormal")
    namesInput:SetWidth(namesScroll:GetWidth())
    namesInput:SetScript("OnEscapePressed", function()
        namesInput:ClearFocus()
        whisperFrame:Hide()
    end)
    
    namesScroll:SetScrollChild(namesInput)
    
    local placeholderText = namesInput:CreateFontString(nil, "OVERLAY")
    placeholderText:SetFontObject("ChatFontNormal")
    placeholderText:SetPoint("TOPLEFT", namesInput, "TOPLEFT", 5, -5)
    placeholderText:SetTextColor(0.5, 0.5, 0.5)
    placeholderText:SetText("Enter character names, one per line...")
    
    namesInput:SetScript("OnEditFocusGained", function()
        if namesInput:GetText() == "" then
            placeholderText:Hide()
        end
    end)
    
    namesInput:SetScript("OnEditFocusLost", function()
        if namesInput:GetText() == "" then
            placeholderText:Show()
        end
    end)
    
    namesInput:SetScript("OnTextChanged", function(self)
        local inputText = self:GetText()
        if inputText == "" then
            placeholderText:Show()
            playerNames = nil
        else
            placeholderText:Hide()
            playerNames = parsePlayerNames(inputText)
        end
        local lineCount = select(2, inputText:gsub('\n', '\n')) + 1
        local lineHeight = select(2, namesInput:GetFont()) or 14
        local newHeight = math.max(lineCount * lineHeight, namesScroll:GetHeight() - 20)
        self:SetHeight(newHeight)
    end)
end

-- Send whispers so that we contact listed players.

local function sendWhispers(messageText, names)
    for _, playerName in ipairs(names) do
        if playerName and playerName ~= "" then
            SendChatMessage(messageText, "WHISPER", nil, playerName)
        end
    end
end

-- Create message panel so that we edit whisper text.

local function createMessagePanel()
    local childFrame = CreateFrame("Frame", "MultiWhisperMessageConfigPopup", UIParent, "BasicFrameTemplateWithInset")
    childFrame:SetSize(480, 240)
    childFrame:SetFrameStrata("DIALOG")
    childFrame:SetFrameLevel(1000)
    childFrame:Hide()
    
    -- Focus message input so that typing starts fast.
    
    childFrame:SetScript("OnMouseDown", function(self)
        if self.messageInput then
            self.messageInput:SetFocus()
        end
    end)
    
    -- Add title so that we label the panel.
    
    childFrame.title = childFrame:CreateFontString(nil, "OVERLAY")
    childFrame.title:SetFontObject("GameFontHighlight")
    childFrame.title:SetPoint("CENTER", childFrame.TitleBg, "CENTER", 0, 0)
    childFrame.title:SetText("Multi Whisper Message Settings")
    
    -- Add message label so that we describe the field.
    
    local messageLabel = childFrame:CreateFontString(nil, "OVERLAY")
    messageLabel:SetFontObject("GameFontNormal")
    messageLabel:SetPoint("TOPLEFT", childFrame, "TOPLEFT", 20, -35)
    messageLabel:SetText("Predefined whisper message:")
    
    -- Create message input so that we edit up to three lines.
    
    local messageInput = CreateFrame("EditBox", nil, childFrame)
    messageInput:SetPoint("TOPLEFT", messageLabel, "BOTTOMLEFT", 0, -8)
    messageInput:SetSize(432, 160)
    messageInput:SetMultiLine(true)
    messageInput:SetMaxLetters(260)
    messageInput:SetAutoFocus(false)
    messageInput:SetFontObject("ChatFontNormal")
    
    -- Limit input so that text fits three lines.
    
    messageInput:SetScript("OnTextChanged", function(self)
        local text = self:GetText()
        local lines = 1
        for _ in text:gmatch("\n") do
            lines = lines + 1
        end

        -- Prevent more than three lines of text.

        if lines > 3 then

            -- Remove last character so that we stay within limit.

            local newText = text:sub(1, -2)
            self:SetText(newText)
            self:SetCursorPosition(#newText)
        end
    end)
    
    -- Create close button so that we dismiss panel.
    
    local cancelButton = CreateFrame("Button", nil, childFrame, "GameMenuButtonTemplate")
    cancelButton:SetSize(80, 25)
    cancelButton:SetPoint("BOTTOMLEFT", childFrame, "BOTTOMLEFT", 20, 20)
    cancelButton:SetText("Cancel")
    
    -- Create save button so that we persist message.
    
    local saveButton = CreateFrame("Button", nil, childFrame, "GameMenuButtonTemplate")
    saveButton:SetSize(80, 25)
    saveButton:SetPoint("BOTTOMRIGHT", childFrame, "BOTTOMRIGHT", -20, 20)
    saveButton:SetText("Save")
    
    -- Store original message so that cancel restores state.
    
    local originalMessage = ""
    
    -- Initialize controls so that we sync saved value.
    
    local function initializeControls()
        originalMessage = BentoDB.multiWhisperMessage or ""
        messageInput:SetText(originalMessage)
    end
    
    -- Restore original message so that we discard edits.
    
    cancelButton:SetScript("OnClick", function()
        messageInput:SetText(originalMessage)
        childFrame:Hide()
    end)
    
    -- Save message so that we update saved variables.
    
    saveButton:SetScript("OnClick", function()
        BentoDB.multiWhisperMessage = messageInput:GetText()
        -- Update original message so that cancel remains accurate.
        originalMessage = BentoDB.multiWhisperMessage
    print("|cffffffffBentoPlus: Multi-whisper message |cffffff80saved|r|cffffffff.|r")
        childFrame:Hide()
    end)
    
    -- Store references so that external calls can focus field.
    
    childFrame.messageInput = messageInput
    childFrame.initializeControls = initializeControls
    
    return childFrame
end

-- Show message panel so that we edit whisper text.

local function showMessagePanel()
    if not messagePanel then
        messagePanel = createMessagePanel()
    end
    
    -- Initialize controls so that we load saved text.
    
    messagePanel.initializeControls()
    
    -- Center the panel so that it appears in view.
    
    messagePanel:ClearAllPoints()
    messagePanel:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    messagePanel:Show()
end

-- Create close button so that we hide frame.

local function createCloseButton(parentFrame)
    local closeButton = CreateFrame("Button", "MultiWhisperAddonCancelButton", parentFrame, "UIPanelButtonTemplate")
    closeButton:SetSize(80, 22)
    closeButton:SetPoint("BOTTOMLEFT", parentFrame, "BOTTOMLEFT", 15, 15)
    closeButton:SetText("Close")
    
    closeButton:SetScript("OnClick", function()
        whisperFrame:Hide()
        namesInput:SetText("")
        namesInput:ClearFocus()
    end)
    
    return closeButton
end

-- Create message button so that we open message panel.

local function createMessageButton(parentFrame)
    local configButton = CreateFrame("Button", "MultiWhisperAddonConfigButton", parentFrame, "UIPanelButtonTemplate")
    configButton:SetSize(130, 22)
    configButton:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -135, 15)
    configButton:SetText("Configure Message")
    
    configButton:SetScript("OnClick", function()
        showMessagePanel()
    end)
    
    return configButton
end

-- Create whisper button so that we start batch whisper.

local function createWhisperButton(parentFrame)
    local whisperButton = CreateFrame("Button", "MultiWhisperAddonWhisperButton", parentFrame, "UIPanelButtonTemplate")
    whisperButton:SetSize(100, 22)
    whisperButton:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -15, 15)
    whisperButton:SetText("Multi Whisper")
    
    whisperButton:SetScript("OnClick", function()
        -- Update names so that we use latest text.
        
        local namesText = namesInput:GetText()
        if namesText and namesText ~= "" then
            playerNames = parsePlayerNames(namesText)
        end
        
        -- Open chat so that we prefill command and message.
        
        local prefillText = "/w+ "
        if BentoDB.multiWhisperMessage and BentoDB.multiWhisperMessage ~= "" then
            prefillText = "/w+ " .. BentoDB.multiWhisperMessage
        end
        ChatFrame_OpenChat(prefillText)
    end)
    
    return whisperButton
end

-- Run whisper send so that we message all names.

local function runWhisperSend(messageText)
    if playerNames and #playerNames > 0 then
        sendWhispers(messageText, playerNames)
    end
end

-- Show whisper frame so that we collect and send names.

local function showWhisperFrame()
    if not whisperFrame then
        createWhisperFrame()
        createNameInput(whisperFrame)
        createCloseButton(whisperFrame)
        createMessageButton(whisperFrame)
        createWhisperButton(whisperFrame)
    end
    
    whisperFrame:Show()
    namesInput:SetFocus()
    
    -- Update names so that we sync from input.
    
    local namesText = namesInput:GetText()
    if namesText and namesText ~= "" then
        playerNames = parsePlayerNames(namesText)
    end
end

-- Register command so that we send batch whisper.

SLASH_WHISPERPLUS1 = "/w+"
SlashCmdList["WHISPERPLUS"] = function(messageText)
    if not messageText or messageText == "" then
        
        -- Open list so that user can edit names.
        
        showWhisperFrame()
        return
    end

    -- Update names from current frame so that we use fresh input.
    
    if whisperFrame and whisperFrame:IsShown() then
        local namesText = namesInput:GetText()
        if namesText and namesText ~= "" then
            playerNames = parsePlayerNames(namesText)
        end
    end
    
    runWhisperSend(messageText)
end

-- Initialize saved message so that defaults exist.

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, loadedAddonName)
    if event == "ADDON_LOADED" and loadedAddonName == multiWhisperName then

        -- Initialize saved variables so that we avoid nil.
        
        BentoDB = BentoDB or {}
        BentoDB.multiWhisperMessage = BentoDB.multiWhisperMessage or ""
    end
end)




-- Show hint on login and provide /bento to list commands

local function printCommandList()
  print("Multi Whisper Commands")
  print("/w+: Open multi-whisper UI")
  print("/w+ MESSAGE: Send MESSAGE to whisper list")
end

-- Display login hint shortly after login
local loginHintFrame = CreateFrame("Frame")
loginHintFrame:RegisterEvent("PLAYER_LOGIN")
loginHintFrame:SetScript("OnEvent", function()
  C_Timer.After(2, function()
  print("BentoPlus: type /bento for commands.")
  end)
end)

-- Register slash command to display the command list
SLASH_BENTOPLUS1 = "/multiwhisper"
SlashCmdList["BENTOPLUS"] = printCommandList
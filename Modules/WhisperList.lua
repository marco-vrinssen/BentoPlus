-- MultiWhisper addon for batch whispering multiple players
local addonName = "MultiWhisperAddon"
local whisperFrame = nil
local textScrollFrame = nil
local editBox = nil
local storedPlayerNames = nil
local messageConfigPopup = nil

-- Initialize saved variables for predefined whisper message
BentoDB = BentoDB or {}
BentoDB.multiWhisperMessage = BentoDB.multiWhisperMessage or ""

-- Create main UI frame for multi whisper list
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
    
    -- Helper text instruction
    whisperFrame.helperText = whisperFrame:CreateFontString(nil, "OVERLAY")
    whisperFrame.helperText:SetFontObject("GameFontNormal")
    whisperFrame.helperText:SetPoint("TOPLEFT", whisperFrame, "TOPLEFT", 15, -35)
    whisperFrame.helperText:SetText('Use "/w+ MESSAGE" to send the MESSAGE to all players in this list')
    whisperFrame.helperText:SetTextColor(0.7, 0.7, 0.7)
    
    return whisperFrame
end

-- Parse newline separated player names list
local function parsePlayerNameList(nameText)
    local names = {}
    
    for line in nameText:gmatch("[^\r\n]+") do
        local trimmedName = line:match("^%s*(.-)%s*$")
        if trimmedName and trimmedName ~= "" then
            table.insert(names, trimmedName)
        end
    end
    
    return names
end

-- Create scrollable multiline edit box for player names
local function createTextInputArea(parentFrame)
    textScrollFrame = CreateFrame("ScrollFrame", "MultiWhisperAddonScrollFrame", parentFrame, "UIPanelScrollFrameTemplate")
    textScrollFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 15, -60)
    textScrollFrame:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -35, 50)
    
    editBox = CreateFrame("EditBox", "MultiWhisperAddonEditBox", textScrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetWidth(textScrollFrame:GetWidth())
    editBox:SetScript("OnEscapePressed", function() 
        editBox:ClearFocus()
        whisperFrame:Hide()
    end)
    
    textScrollFrame:SetScrollChild(editBox)
    
    local placeholderText = editBox:CreateFontString(nil, "OVERLAY")
    placeholderText:SetFontObject("ChatFontNormal")
    placeholderText:SetPoint("TOPLEFT", editBox, "TOPLEFT", 5, -5)
    placeholderText:SetTextColor(0.5, 0.5, 0.5)
    placeholderText:SetText("Enter character names, one per line...")
    
    editBox:SetScript("OnEditFocusGained", function()
        if editBox:GetText() == "" then
            placeholderText:Hide()
        end
    end)
    
    editBox:SetScript("OnEditFocusLost", function()
        if editBox:GetText() == "" then
            placeholderText:Show()
        end
    end)
    
    editBox:SetScript("OnTextChanged", function(self)
        local text = self:GetText()
        if text == "" then
            placeholderText:Show()
            storedPlayerNames = nil
        else
            placeholderText:Hide()
            storedPlayerNames = parsePlayerNameList(text)
        end
        local lineCount = select(2, text:gsub('\n', '\n')) + 1
        local lineHeight = select(2, editBox:GetFont()) or 14
        local newHeight = math.max(lineCount * lineHeight, textScrollFrame:GetHeight() - 20)
        self:SetHeight(newHeight)
    end)
end

-- Send whisper message to each player in list
local function sendWhisperMessages(messageText, playerNames)
    local sentCount = 0
    
    for _, playerName in ipairs(playerNames) do
        if playerName and playerName ~= "" then
            SendChatMessage(messageText, "WHISPER", nil, playerName)
            sentCount = sentCount + 1
        end
    end
end

-- Build popup frame to configure predefined whisper message
local function createMessageConfigPopup()
    local childFrame = CreateFrame("Frame", "MultiWhisperMessageConfigPopup", UIParent, "BasicFrameTemplateWithInset")
    childFrame:SetSize(480, 240)
    childFrame:SetFrameStrata("DIALOG")
    childFrame:SetFrameLevel(1000)
    childFrame:Hide()
    
    -- Focus the text input when popup is clicked
    childFrame:SetScript("OnMouseDown", function(self)
        if self.messageEditBox then
            self.messageEditBox:SetFocus()
        end
    end)
    
    -- Title for child popup
    childFrame.title = childFrame:CreateFontString(nil, "OVERLAY")
    childFrame.title:SetFontObject("GameFontHighlight")
    childFrame.title:SetPoint("CENTER", childFrame.TitleBg, "CENTER", 0, 0)
    childFrame.title:SetText("Multi Whisper Message Settings")
    
    -- Input text field label for message at top
    local messageLabel = childFrame:CreateFontString(nil, "OVERLAY")
    messageLabel:SetFontObject("GameFontNormal")
    messageLabel:SetPoint("TOPLEFT", childFrame, "TOPLEFT", 20, -35)
    messageLabel:SetText("Predefined whisper message:")
    
    -- Create multi-line text input (no scroll, fixed size for 3 lines)
    local messageEditBox = CreateFrame("EditBox", nil, childFrame)
    messageEditBox:SetPoint("TOPLEFT", messageLabel, "BOTTOMLEFT", 0, -8)
    messageEditBox:SetSize(432, 160)
    messageEditBox:SetMultiLine(true)
    messageEditBox:SetMaxLetters(260)
    messageEditBox:SetAutoFocus(false)
    messageEditBox:SetFontObject("ChatFontNormal")
    
    -- Limit input to prevent scrolling beyond visible area
    messageEditBox:SetScript("OnTextChanged", function(self)
        local text = self:GetText()
        local lines = 1
        for _ in text:gmatch("\n") do
            lines = lines + 1
        end
        -- Prevent more than 3 lines of text
        if lines > 3 then
            -- Remove the last character that caused overflow
            local newText = text:sub(1, -2)
            self:SetText(newText)
            self:SetCursorPosition(#newText)
        end
    end)
    
    -- Cancel button at bottom-left
    local cancelButton = CreateFrame("Button", nil, childFrame, "GameMenuButtonTemplate")
    cancelButton:SetSize(80, 25)
    cancelButton:SetPoint("BOTTOMLEFT", childFrame, "BOTTOMLEFT", 20, 20)
    cancelButton:SetText("Cancel")
    
    -- Save button at bottom-right
    local saveButton = CreateFrame("Button", nil, childFrame, "GameMenuButtonTemplate")
    saveButton:SetSize(80, 25)
    saveButton:SetPoint("BOTTOMRIGHT", childFrame, "BOTTOMRIGHT", -20, 20)
    saveButton:SetText("Save")
    
    -- Store original values for cancel functionality
    local originalMessage = ""
    
    -- Initialize controls with current values
    local function initializeControls()
        originalMessage = BentoDB.multiWhisperMessage or ""
        messageEditBox:SetText(originalMessage)
    end
    
    -- Cancel button behavior - restore original values and close
    cancelButton:SetScript("OnClick", function()
        messageEditBox:SetText(originalMessage)
        childFrame:Hide()
    end)
    
    -- Save button behavior - persist values and close
    saveButton:SetScript("OnClick", function()
        BentoDB.multiWhisperMessage = messageEditBox:GetText()
        -- Update original values to match saved values
        originalMessage = BentoDB.multiWhisperMessage
        print("|cff00ff00MultiWhisper:|r Message saved successfully!")
        childFrame:Hide()
    end)
    
    -- Store references for external access
    childFrame.messageEditBox = messageEditBox
    childFrame.initializeControls = initializeControls
    
    return childFrame
end

-- Display predefined message configuration popup
local function showMessageConfigPopup()
    if not messageConfigPopup then
        messageConfigPopup = createMessageConfigPopup()
    end
    
    -- Initialize controls with current values
    messageConfigPopup.initializeControls()
    
    -- Center the popup
    messageConfigPopup:ClearAllPoints()
    messageConfigPopup:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    messageConfigPopup:Show()
end

-- Create close button for main frame
local function createCancelButton(parentFrame)
    local cancelButton = CreateFrame("Button", "MultiWhisperAddonCancelButton", parentFrame, "UIPanelButtonTemplate")
    cancelButton:SetSize(80, 22)
    cancelButton:SetPoint("BOTTOMLEFT", parentFrame, "BOTTOMLEFT", 15, 15)
    cancelButton:SetText("Close")
    
    cancelButton:SetScript("OnClick", function()
        whisperFrame:Hide()
        editBox:SetText("")
        editBox:ClearFocus()
    end)
    
    return cancelButton
end

-- Create button to open message configuration popup
local function createConfigureMessageButton(parentFrame)
    local configButton = CreateFrame("Button", "MultiWhisperAddonConfigButton", parentFrame, "UIPanelButtonTemplate")
    configButton:SetSize(130, 22)
    configButton:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -135, 15)
    configButton:SetText("Configure Message")
    
    configButton:SetScript("OnClick", function()
        showMessageConfigPopup()
    end)
    
    return configButton
end

-- Create button to start multi-whisper flow via /w+
local function createMultiWhisperButton(parentFrame)
    local whisperButton = CreateFrame("Button", "MultiWhisperAddonWhisperButton", parentFrame, "UIPanelButtonTemplate")
    whisperButton:SetSize(100, 22)
    whisperButton:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -15, 15)
    whisperButton:SetText("Multi Whisper")
    
    whisperButton:SetScript("OnClick", function()
        -- Update stored player names from current text
        local text = editBox:GetText()
        if text and text ~= "" then
            storedPlayerNames = parsePlayerNameList(text)
        end
        -- Open chat with /w+ prefilled and configured message if available
        local prefillText = "/w+ "
        if BentoDB.multiWhisperMessage and BentoDB.multiWhisperMessage ~= "" then
            prefillText = "/w+ " .. BentoDB.multiWhisperMessage
        end
        ChatFrame_OpenChat(prefillText)
    end)
    
    return whisperButton
end

-- Execute batch whisper send for /w+ command
local function handleWhisperCommand(messageText)
    if storedPlayerNames and #storedPlayerNames > 0 then
        sendWhisperMessages(messageText, storedPlayerNames)
    end
end

-- Show main whisper frame and refresh name list
local function showWhisperWindow()
    if not whisperFrame then
        createWhisperFrame()
        createTextInputArea(whisperFrame)
        createCancelButton(whisperFrame)
        createConfigureMessageButton(whisperFrame)
        createMultiWhisperButton(whisperFrame)
    end
    
    whisperFrame:Show()
    editBox:SetFocus()
    
    -- Update stored player names when window is shown
    local text = editBox:GetText()
    if text and text ~= "" then
        storedPlayerNames = parsePlayerNameList(text)
    end
end

-- Register /multiwhisper command
SLASH_MULTIWHISPER1 = "/multiwhisper"
SlashCmdList["MULTIWHISPER"] = function(msg)
    showWhisperWindow()
end

-- Register /w+ pseudo command for sending predefined message
SLASH_WHISPERPLUS1 = "/w+"
SlashCmdList["WHISPERPLUS"] = function(msg)
    if msg and msg ~= "" then
        -- Update player list from current window if open
        if whisperFrame and whisperFrame:IsShown() then
            local text = editBox:GetText()
            if text and text ~= "" then
                storedPlayerNames = parsePlayerNameList(text)
            end
        end
        handleWhisperCommand(msg)
    end
end

-- Initialize addon saved data when loaded
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, loadedAddonName)
    if event == "ADDON_LOADED" and loadedAddonName == addonName then
        -- Initialize saved variables if they don't exist
        BentoDB = BentoDB or {}
        BentoDB.multiWhisperMessage = BentoDB.multiWhisperMessage or ""
    end
end)

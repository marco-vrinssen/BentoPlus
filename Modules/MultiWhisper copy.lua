-- Multi Whisper addon for sending messages to multiple players
local addonName = "MultiWhisperAddon"
local whisperFrame = nil
local textScrollFrame = nil
local editBox = nil
local storedPlayerNames = nil

-- Create main whisper window frame
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

-- Create scrollable text input area
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

-- Create cancel button
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

-- Create multi whisper button
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
        -- Open chat with /w+ prefilled
        ChatFrame_OpenChat("/w+ ")
    end)
    
    return whisperButton
end

-- Parse player names from text
function parsePlayerNameList(nameText)
    local names = {}
    
    for line in nameText:gmatch("[^\r\n]+") do
        local trimmedName = line:match("^%s*(.-)%s*$")
        if trimmedName and trimmedName ~= "" then
            table.insert(names, trimmedName)
        end
    end
    
    return names
end

-- Send whisper messages to players
function sendWhisperMessages(messageText, playerNames)
    local sentCount = 0
    
    for _, playerName in ipairs(playerNames) do
        if playerName and playerName ~= "" then
            SendChatMessage(messageText, "WHISPER", nil, playerName)
            sentCount = sentCount + 1
        end
    end
end

-- Handle /w+ command
local function handleWhisperCommand(messageText)
    if storedPlayerNames and #storedPlayerNames > 0 then
        sendWhisperMessages(messageText, storedPlayerNames)
    end
end

-- Show whisper window and update player list
local function showWhisperWindow()
    if not whisperFrame then
        createWhisperFrame()
        createTextInputArea(whisperFrame)
        createCancelButton(whisperFrame)
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

-- Slash command handler for /multiwhisper
SLASH_MULTIWHISPER1 = "/multiwhisper"
SlashCmdList["MULTIWHISPER"] = function(msg)
    showWhisperWindow()
end

-- Slash command handler for /w+ 
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

-- Event frame for addon initialization
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, loadedAddonName)
    if event == "ADDON_LOADED" and loadedAddonName == addonName then
        -- Addon loaded silently
    end
end)

-- Recruit addon for adding multiple friends at once
local addonName = "RecruitAddon"
local recruitFrame = nil
local textScrollFrame = nil
local editBox = nil
local storedPlayerNames = nil

-- Create main recruit window frame
local function createRecruitFrame()
    if recruitFrame then
        return recruitFrame
    end
    
    recruitFrame = CreateFrame("Frame", "RecruitAddonFrame", UIParent, "BasicFrameTemplateWithInset")
    recruitFrame:SetSize(500, 600)
    recruitFrame:SetPoint("CENTER")
    recruitFrame:SetMovable(true)
    recruitFrame:EnableMouse(true)
    recruitFrame:RegisterForDrag("LeftButton")
    recruitFrame:SetScript("OnDragStart", recruitFrame.StartMoving)
    recruitFrame:SetScript("OnDragStop", recruitFrame.StopMovingOrSizing)
    recruitFrame:Hide()
    
    recruitFrame.title = recruitFrame:CreateFontString(nil, "OVERLAY")
    recruitFrame.title:SetFontObject("GameFontHighlight")
    recruitFrame.title:SetPoint("LEFT", recruitFrame.TitleBg, "LEFT", 5, 0)
    recruitFrame.title:SetText("Bento Recruit")
    
    -- Helper text instruction
    recruitFrame.helperText = recruitFrame:CreateFontString(nil, "OVERLAY")
    recruitFrame.helperText:SetFontObject("GameFontNormal")
    recruitFrame.helperText:SetPoint("TOPLEFT", recruitFrame, "TOPLEFT", 15, -35)
    recruitFrame.helperText:SetText('Use "/w+ MESSAGE" to send the MESSAGE to all players in this list')
    recruitFrame.helperText:SetTextColor(0.7, 0.7, 0.7)
    
    return recruitFrame
end

-- Create scrollable text input area
local function createTextInputArea(parentFrame)
    textScrollFrame = CreateFrame("ScrollFrame", "RecruitAddonScrollFrame", parentFrame, "UIPanelScrollFrameTemplate")
    textScrollFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 15, -60)
    textScrollFrame:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -35, 50)
    
    editBox = CreateFrame("EditBox", "RecruitAddonEditBox", textScrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetWidth(textScrollFrame:GetWidth())
    editBox:SetScript("OnEscapePressed", function() 
        editBox:ClearFocus()
        recruitFrame:Hide()
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
    
    editBox:SetScript("OnEnterPressed", function(self)
        ChatFrame_OpenChat("")
    end)
    
    editBox:SetScript("OnTextChanged", function(self)
        local text = self:GetText()
        if text == "" then
            placeholderText:Show()
            storedPlayerNames = nil
        else
            placeholderText:Hide()
            -- Update stored player names when text changes
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
    local cancelButton = CreateFrame("Button", "RecruitAddonCancelButton", parentFrame, "UIPanelButtonTemplate")
    cancelButton:SetSize(80, 22)
    cancelButton:SetPoint("BOTTOMLEFT", parentFrame, "BOTTOMLEFT", 15, 15)
    cancelButton:SetText("Close")
    
    cancelButton:SetScript("OnClick", function()
        recruitFrame:Hide()
        editBox:SetText("")
        editBox:ClearFocus()
    end)
    
    return cancelButton
end

-- Create add friends button
local function createAddFriendsButton(parentFrame)
    local addButton = CreateFrame("Button", "RecruitAddonAddButton", parentFrame, "UIPanelButtonTemplate")
    addButton:SetSize(100, 22)
    addButton:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -15, 15)
    addButton:SetText("Add All Friends")
    
    addButton:SetScript("OnClick", function()
        local text = editBox:GetText()
        if text and text ~= "" then
            processNameList(text)
        end
        recruitFrame:Hide()
        editBox:SetText("")
        editBox:ClearFocus()
    end)
    
    return addButton
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

-- Remove all message window related functions since we no longer need them

-- Process list of names and send friend requests
function processNameList(nameText)
    local names = parsePlayerNameList(nameText)
    local processedCount = 0
    
    if #names == 0 then
        return
    end
    
    for _, name in ipairs(names) do
        if name and name ~= "" then
            C_FriendList.AddFriend(name)
            processedCount = processedCount + 1
        end
    end
end

-- Show recruit window and update player list
local function showRecruitWindow()
    if not recruitFrame then
        createRecruitFrame()
        createTextInputArea(recruitFrame)
        createCancelButton(recruitFrame)
        createAddFriendsButton(recruitFrame)
    end
    
    recruitFrame:Show()
    editBox:SetFocus()
    
    -- Update stored player names when window is shown
    local text = editBox:GetText()
    if text and text ~= "" then
        storedPlayerNames = parsePlayerNameList(text)
    end
end

-- Slash command handler for /recruit
SLASH_RECRUIT1 = "/recruit"
SlashCmdList["RECRUIT"] = function(msg)
    showRecruitWindow()
end

-- Slash command handler for /w+ 
SLASH_WHISPERPLUS1 = "/w+"
SlashCmdList["WHISPERPLUS"] = function(msg)
    if msg and msg ~= "" then
        -- Update player list from current window if open
        if recruitFrame and recruitFrame:IsShown() then
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